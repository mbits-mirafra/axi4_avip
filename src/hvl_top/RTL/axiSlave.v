module axi_ram #(
    parameter DATA_WIDTH = 512,
    parameter ADDR_WIDTH = 32,
    parameter ID_WIDTH   = 4,
    parameter MEM_DEPTH  = 1024,
    parameter FIFO_DEPTH = 32,
    parameter AR_READY_DELAY = 5      // cycles to wait after arvalid before arready
)(
    input  wire                     s_axi_aclk,
    input  wire                     s_axi_aresetn,
    input  wire [ID_WIDTH-1:0]      s_axi_awid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire [7:0]               s_axi_awlen,
    input  wire [2:0]               s_axi_awsize,
    input  wire [1:0]               s_axi_awburst,
    input  wire                     s_axi_awlock,
    input  wire [3:0]               s_axi_awcache,
    input  wire [2:0]               s_axi_awprot,
    input  wire [3:0]               s_axi_awqos,
    input  wire [3:0]               s_axi_awregion,
    input  wire                     s_axi_awvalid,
    output reg                      s_axi_awready,
    input  wire [DATA_WIDTH-1:0]    s_axi_wdata,
    input  wire [DATA_WIDTH/8-1:0]  s_axi_wstrb,
    input  wire                     s_axi_wlast,
    input  wire                     s_axi_wvalid,
    output reg                      s_axi_wready,
    output reg  [ID_WIDTH-1:0]      s_axi_bid,
    output reg  [1:0]               s_axi_bresp,
    output reg                      s_axi_bvalid,
    input  wire                     s_axi_bready,
    input  wire [ID_WIDTH-1:0]      s_axi_arid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [7:0]               s_axi_arlen,
    input  wire [2:0]               s_axi_arsize,
    input  wire [1:0]               s_axi_arburst,
    input  wire                     s_axi_arlock,
    input  wire [3:0]               s_axi_arcache,
    input  wire [2:0]               s_axi_arprot,
    input  wire [3:0]               s_axi_arqos,
    input  wire [3:0]               s_axi_arregion,
    input  wire                     s_axi_arvalid,
    output reg                      s_axi_arready,
    output reg  [ID_WIDTH-1:0]      s_axi_rid,
    output reg  [DATA_WIDTH-1:0]    s_axi_rdata,
    output reg  [1:0]               s_axi_rresp,
    output reg                      s_axi_rlast,
    output reg                      s_axi_rvalid,
    input  wire                     s_axi_rready
);

    localparam RESP_OKAY   = 2'b00;
    localparam RESP_SLVERR = 2'b10;
    localparam BURST_FIXED = 2'b00;
    localparam BURST_INCR  = 2'b01;
    localparam BURST_WRAP  = 2'b10;
    localparam STRB_WIDTH  = DATA_WIDTH / 8;
    localparam BYTE_BITS   = $clog2(STRB_WIDTH);
    localparam PTR_W       = $clog2(FIFO_DEPTH);
    localparam MEM_BYTES   = MEM_DEPTH * STRB_WIDTH;   // total byte-addressable depth

    // Byte-addressed memory: mem[byteAddr] holds one byte, exactly like the
    // scoreboard's referenceData[tempAddress]. The byte at AXI address A always
    // lives at mem[A] and is carried on bus lane (A % STRB_WIDTH).
    reg [7:0] mem [0:MEM_BYTES-1];

    // ---- INCR/WRAP write staging ----
    // Per the slave's intended behaviour, memory is updated only when the WRITE
    // RESPONSE (B) handshake completes -- the same point the scoreboard commits
    // referenceData. So strobed bytes are held here during the W-data phase and
    // flushed into mem on the B handshake. One write is in flight at a time, so
    // this is sized to a single maximum-length AXI burst.
    localparam WSTG_DEPTH = 256 * STRB_WIDTH;
    reg [ADDR_WIDTH-1:0] wstg_addr [0:WSTG_DEPTH-1];
    reg [7:0]            wstg_data [0:WSTG_DEPTH-1];
    reg [15:0]           wstg_count;

    // ---- byte FIFO (committed data) ----
    reg [7:0]        fifo_mem [0:FIFO_DEPTH-1];
    reg [PTR_W-1:0]  fifo_wr_ptr;
    reg [PTR_W-1:0]  fifo_rd_ptr;
    reg [PTR_W:0]    fifo_count;

    // ---- staging buffer (uncommitted FIXED-write bytes) ----
    reg [7:0]        stg_mem [0:FIFO_DEPTH-1];
    reg [PTR_W:0]    stg_store;   // bytes currently staged (0..FIFO_DEPTH)
    reg              stg_ovf;     // staging exceeded FIFO capacity

    // ---------------------------------------------------------------- init
    // Zero-fill all storage at time 0 so any read of an address/byte that
    // was never written returns a deterministic 0 instead of simulation X.
    // (Most FPGA BRAM primitives support this as a power-on init value too;
    // for ASIC flows where memory truly powers up unknown, remove this block.)
    integer init_idx;
    initial begin
        for (init_idx = 0; init_idx < MEM_BYTES;  init_idx = init_idx + 1) mem[init_idx]      = 8'h00;
        for (init_idx = 0; init_idx < FIFO_DEPTH; init_idx = init_idx + 1) fifo_mem[init_idx]  = 8'h00;
        for (init_idx = 0; init_idx < FIFO_DEPTH; init_idx = init_idx + 1) stg_mem[init_idx]   = 8'h00;
    end

    // ---------------------------------------------------------------- helpers
    function [ADDR_WIDTH-1:0] wrap_mask;
        input [7:0] len; input [2:0] size;
        reg [ADDR_WIDTH-1:0] bytes;
        begin bytes = (len + 1) << size; wrap_mask = bytes - 1; end
    endfunction

    function [ADDR_WIDTH-1:0] next_addr;
        input [ADDR_WIDTH-1:0] addr; input [1:0] burst;
        input [2:0] size; input [ADDR_WIDTH-1:0] mask;
        reg [ADDR_WIDTH-1:0] sz_align, addr_aligned;
        begin
            sz_align     = (1 << size) - 1;     // size-alignment mask
            // Realign to the size boundary before advancing. AXI4 only allows
            // the FIRST beat of any burst to be partial/unaligned; every beat
            // after that must be size-aligned. The INCR branch already did
            // this; the WRAP branch needs it too -- otherwise a misaligned
            // start (whose first beat covers fewer than 'size' bytes) advances
            // as if a full step had been taken from the unaligned address,
            // which overshoots the wrap window and preserves the wrong offset
            // instead of snapping to the window's absolute base, like the
            // scoreboard's byte-wise tempAddress walk does.
            addr_aligned = addr & ~sz_align;
            case (burst)
                BURST_FIXED: next_addr = addr;
                BURST_INCR:  next_addr = addr_aligned + (1 << size);
                BURST_WRAP:  next_addr = (addr_aligned & ~mask) | ((addr_aligned + (1 << size)) & mask);
                default:     next_addr = addr_aligned + (1 << size);
            endcase
        end
    endfunction

    function integer lane_count_f;
        input [ADDR_WIDTH-1:0] addr; input [2:0] size;
        integer s, off, lane, c, top;
        begin
            s = (1 << size); off = addr % STRB_WIDTH;
            top = ((off / s) * s) + s;   // end of the size container holding 'off'
            c = 0;
            for (lane = 0; lane < STRB_WIDTH; lane = lane + 1)
                if (lane >= off && lane < top) c = c + 1;
            lane_count_f = c;
        end
    endfunction

    // Active byte-lane mask for a beat at the given address/size (handles
    // narrow + unaligned; clipped to the bus). Used to honor a(w/r)size on
    // the memory path.
    function [STRB_WIDTH-1:0] lane_mask_f;
        input [ADDR_WIDTH-1:0] addr; input [2:0] size;
        integer s, off, lane, top;
        reg [STRB_WIDTH-1:0] m;
        begin
            s = (1 << size); off = addr % STRB_WIDTH;
            top = ((off / s) * s) + s;   // size-container end
            m = {STRB_WIDTH{1'b0}};
            for (lane = 0; lane < STRB_WIDTH; lane = lane + 1)
                if (lane >= off && lane < top) m[lane] = 1'b1;
            lane_mask_f = m;
        end
    endfunction

    function integer strb_count_f;
        input [STRB_WIDTH-1:0] strb;
        integer i, c;
        begin c = 0; for (i = 0; i < STRB_WIDTH; i = i + 1) c = c + strb[i]; strb_count_f = c; end
    endfunction

    // Peek a read beat. When fwd_en=1 (a FIFO commit is happening this cycle),
    // the bytes being committed are forwarded straight from the staging buffer,
    // since they are not yet visible in fifo_mem on this clock edge.
    task fifo_assemble;
        input  [ADDR_WIDTH-1:0]  addr;
        input  [2:0]             size;
        input                    fwd_en;
        output [DATA_WIDTH-1:0]  data_o;
        output                   underflow_o;
        integer s, off, lane, k, need, space, cbytes, avail;
        reg [STRB_WIDTH-1:0] mask;
        begin
            space  = FIFO_DEPTH - fifo_count;
            cbytes = fwd_en ? ((stg_store <= space) ? stg_store : space) : 0; // committed this cycle
            avail  = fifo_count + cbytes;                                      // forwardable bytes
            s = (1 << size); off = addr % STRB_WIDTH; mask = 0; need = 0;
            for (lane = 0; lane < STRB_WIDTH; lane = lane + 1)
                if (lane >= off && lane < (((off / s) * s) + s)) begin mask[lane] = 1'b1; need = need + 1; end
            underflow_o = (need > avail);
            data_o = {DATA_WIDTH{1'b0}};
            k = 0;
            for (lane = 0; lane < STRB_WIDTH; lane = lane + 1) begin
                if (mask[lane]) begin
                    if (k < fifo_count)
                        data_o[lane*8 +: 8] = fifo_mem[(fifo_rd_ptr + k) % FIFO_DEPTH];
                    else if (k < avail)
                        data_o[lane*8 +: 8] = stg_mem[k - fifo_count];   // forwarded byte
                    k = k + 1;
                end
            end
        end
    endtask

    // Fetch one memory byte. When fwd=1 (an INCR/WRAP write is committing this
    // same cycle), the staged byte for that address is forwarded, since the mem
    // array update is non-blocking and not yet visible. Last staged write to an
    // address wins (later beats override earlier ones).
    function [7:0] mem_byte;
        input [ADDR_WIDTH-1:0] a;
        input                  fwd;
        integer k; reg [7:0] v;
        begin
            v = (a < MEM_BYTES) ? mem[a] : 8'h00;
            if (fwd)
                for (k = 0; k < wstg_count; k = k + 1)
                    if (wstg_addr[k] == a) v = wstg_data[k];
            mem_byte = v;
        end
    endfunction

    // =====================================================================
    //  WRITE FSM
    // =====================================================================
    localparam WR_IDLE = 2'd0, WR_DATA = 2'd1, WR_RESP = 2'd2;

    reg [1:0]            wr_state;
    reg [ID_WIDTH-1:0]   wr_id;
    reg [ADDR_WIDTH-1:0] wr_addr;
    reg [7:0]            wr_len;
    reg [1:0]            wr_burst;
    reg [2:0]            wr_size;
    reg [ADDR_WIDTH-1:0] wr_wrap_mask;
    reg [ADDR_WIDTH-1:0] wr_vaddr;     // virtual byte address that walks across
                                       // beats (like the scoreboard's tempAddress)
                                       // so FIXED staging rotates the lane/strobe
    reg                  wr_inflight;   // write accepted, B handshake not yet done
    reg                  wr_is_fifo;    // in-flight write is FIXED (targets the FIFO)
    reg [ADDR_WIDTH+8:0] wr_range_lo;   // byte range covered by the in-flight write
    reg [ADDR_WIDTH+8:0] wr_range_hi;


    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            wr_state      <= WR_IDLE;
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;
            s_axi_bvalid  <= 1'b0;
            s_axi_bid     <= {ID_WIDTH{1'b0}};
            s_axi_bresp   <= RESP_OKAY;
            stg_store     <= {(PTR_W+1){1'b0}};
            stg_ovf       <= 1'b0;
            wr_inflight   <= 1'b0;
            wstg_count    <= 16'd0;
            wr_vaddr      <= {ADDR_WIDTH{1'b0}};
            // Parity with the read-side fix: these have no other reset, so
            // without this they sit at X from time 0 until the first AW is
            // accepted. Harmless once a write has happened (wr_addr etc. are
            // never read before WR_IDLE sets them), but kept defined for clean
            // waveforms and to avoid manufacturing X on the RTL side.
            wr_addr       <= {ADDR_WIDTH{1'b0}};
            wr_len        <= 8'd0;
            wr_burst      <= BURST_FIXED;
            wr_size       <= 3'd0;
            wr_wrap_mask  <= {ADDR_WIDTH{1'b0}};
        end else begin
            case (wr_state)
                WR_IDLE: begin
                    s_axi_awready <= 1'b1;
                    s_axi_wready  <= 1'b0;
                    s_axi_bvalid  <= 1'b0;
                    if (s_axi_awvalid && s_axi_awready) begin
                        wr_id        <= s_axi_awid;
                        wr_addr      <= s_axi_awaddr;
                        wr_len       <= s_axi_awlen;
                        wr_burst     <= s_axi_awburst;
                        wr_size      <= s_axi_awsize;
                        wr_wrap_mask <= wrap_mask(s_axi_awlen, s_axi_awsize);
                        wr_vaddr     <= s_axi_awaddr;        // start the lane walk
                        stg_store    <= {(PTR_W+1){1'b0}};   // fresh staging
                        stg_ovf      <= 1'b0;
                        wstg_count   <= 16'd0;                // fresh mem staging
                        wr_inflight  <= 1'b1;                 // write now in flight
                        wr_is_fifo   <= (s_axi_awburst == BURST_FIXED);
                        // Byte range this write covers (conservative span)
                        wr_range_lo  <= s_axi_awaddr;
                        wr_range_hi  <= s_axi_awaddr +
                                        (((s_axi_awlen + 1) << s_axi_awsize) - 1);
                        s_axi_awready <= 1'b0;
                        s_axi_wready  <= 1'b1;
                        wr_state      <= WR_DATA;
                    end
                end

                WR_DATA: begin
                    if (s_axi_wvalid && s_axi_wready) begin
                        if (wr_burst != BURST_FIXED) begin
                            // INCR/WRAP -> stage byte-addressed writes; they are
                            // flushed into mem on the B handshake (not now). The
                            // byte on lane b belongs to AXI address (bus-aligned
                            // wr_addr) + b, stored iff strobed and in the size
                            // window. mem[addr] = wdata[addr % bus].
                            begin : byte_loop
                                integer b, sc; reg [STRB_WIDTH-1:0] wlm;
                                reg [ADDR_WIDTH-1:0] wbase, baddr;
                                wlm   = lane_mask_f(wr_addr, wr_size);
                                wbase = wr_addr & ~(STRB_WIDTH-1);   // bus-aligned base
                                sc    = wstg_count;
                                for (b = 0; b < STRB_WIDTH; b = b + 1) begin
                                    baddr = wbase + b;               // this byte's address
                                    if (s_axi_wstrb[b] && wlm[b] && (baddr < MEM_BYTES)
                                        && (sc < WSTG_DEPTH)) begin
                                        wstg_addr[sc] <= baddr;
                                        wstg_data[sc] <= s_axi_wdata[b*8 +: 8];
                                        sc = sc + 1;
                                    end
                                end
                                wstg_count <= sc;
                            end
                        end else begin : stage_loop
                            // FIXED -> stage strobed bytes (not yet in FIFO).
                            // The lane mask rotates with wr_vaddr (which walks
                            // continuously across beats), so beat0 covers
                            // [off, size-container), beat1 the next size window,
                            // etc. -- identical to the scoreboard's tempAddress
                            // walk (j = tempAddress % bus). A byte is staged only
                            // if it is strobed AND inside this beat's rotating
                            // window, in increasing lane order. wr_vaddr itself
                            // advances ONLY at line ~358 (non-blocking) -- it must
                            // not also be advanced here, or it double-counts.
                            integer b, sc; reg ovf; reg [STRB_WIDTH-1:0] wlm;
                            sc = stg_store; ovf = stg_ovf;
                            wlm = lane_mask_f(wr_vaddr, wr_size);
                            for (b = 0; b < STRB_WIDTH; b = b + 1) begin
                                if (s_axi_wstrb[b] && wlm[b]) begin
                                    if (sc < FIFO_DEPTH) begin
                                        stg_mem[sc] <= s_axi_wdata[b*8 +: 8];
                                        sc = sc + 1;
                                    end else ovf = 1'b1;
                                end
                            end
                            stg_store <= sc;
                            stg_ovf   <= ovf;
                        end

                        if (s_axi_wlast) begin
                            s_axi_wready <= 1'b0;
                            s_axi_bvalid <= 1'b1;
                            s_axi_bid    <= wr_id;
                            if (wr_burst == BURST_FIXED) begin
                                // total staged = prior + this beat's strobed bytes
                                // INSIDE the size window (matches the staging mask)
                                if (stg_ovf ||
                                    ((stg_store +
                                      strb_count_f(s_axi_wstrb & lane_mask_f(wr_vaddr, wr_size))) >
                                     (FIFO_DEPTH - fifo_count)))
                                    s_axi_bresp <= RESP_SLVERR;
                                else
                                    s_axi_bresp <= RESP_OKAY;
                            end else begin
                                s_axi_bresp <= ((wr_addr & ~(STRB_WIDTH-1)) + STRB_WIDTH-1 < MEM_BYTES)
                                               ? RESP_OKAY : RESP_SLVERR;
                            end
                            wr_state <= WR_RESP;
                        end else begin
                            wr_addr <= next_addr(wr_addr, wr_burst, wr_size, wr_wrap_mask);
                            // virtual lane address always advances INCR-style
                            // (continuous, realigning), even for FIXED -- this is
                            // exactly the scoreboard's tempAddress progression.
                            wr_vaddr <= next_addr(wr_vaddr, BURST_INCR, wr_size, wr_wrap_mask);
                            wr_len  <= wr_len - 1;
                        end
                    end
                end

                WR_RESP: begin
                    if (s_axi_bvalid && s_axi_bready) begin
                        // Commit point: on the B handshake the staged INCR/WRAP
                        // bytes are written into mem (FIXED commits to the FIFO in
                        // the FIFO control block). This is the same instant the
                        // scoreboard updates referenceData, so a read sees a write
                        // exactly when the response completes -- not before.
                        if (!wr_is_fifo) begin : commit_loop
                            integer k;
                            for (k = 0; k < wstg_count; k = k + 1)
                                mem[wstg_addr[k]] <= wstg_data[k];
                        end
                        s_axi_bvalid  <= 1'b0;
                        s_axi_awready <= 1'b1;
                        wr_inflight   <= 1'b0;   // write fully complete
                        wr_state      <= WR_IDLE;
                    end
                end
                default: wr_state <= WR_IDLE;
            endcase
        end
    end

    // FIXED-write commit pulse: staged bytes enter the FIFO on the B handshake.
    wire fifo_commit = (wr_state == WR_RESP) && s_axi_bvalid && s_axi_bready &&
                       (wr_burst == BURST_FIXED);

    // =========================================================================
    //  DEBUG MONITOR -- simulation only, fires once per X occurrence with full
    //  context. Remove or comment out for synthesis / once root-caused.
    //  Reports the FIRST cycle wr_addr (or any of its direct inputs) goes X,
    //  alongside aresetn, wr_state, and the AW/W handshake signals at that same
    //  instant -- this pins down whether the cause is reset polarity/timing,
    //  the AW capture itself, or the beat-to-beat next_addr advance.
    // =========================================================================
    reg dbg_wr_addr_was_x;
    initial dbg_wr_addr_was_x = 1'b0;   // ensure the gate itself isn't X on the first check
    always @(posedge s_axi_aclk) begin
        if (^wr_addr === 1'bx || ^wr_burst === 1'bx ||
            ^wr_size === 1'bx || ^wr_wrap_mask === 1'bx) begin
            if (!dbg_wr_addr_was_x) begin
                $display("=== DEBUG: wr_addr-family went X at t=%0t ===", $time);
                $display("  s_axi_aresetn=%b  wr_state=%0d  wr_len=%0d  wr_inflight=%b",
                          s_axi_aresetn, wr_state, wr_len, wr_inflight);
                $display("  wr_addr=%b  wr_burst=%b  wr_size=%b  wr_wrap_mask=%b",
                          wr_addr, wr_burst, wr_size, wr_wrap_mask);
                $display("  s_axi_awvalid=%b  s_axi_awready=%b  s_axi_awaddr=%b  s_axi_awburst=%b  s_axi_awsize=%b  s_axi_awlen=%b",
                          s_axi_awvalid, s_axi_awready, s_axi_awaddr, s_axi_awburst, s_axi_awsize, s_axi_awlen);
                $display("  s_axi_wvalid=%b  s_axi_wready=%b  s_axi_wlast=%b",
                          s_axi_wvalid, s_axi_wready, s_axi_wlast);
                dbg_wr_addr_was_x <= 1'b1;
            end
        end else begin
            dbg_wr_addr_was_x <= 1'b0;
        end
    end

    // =====================================================================
    //  READ FSM  (with write->read interlock)
    //    AR may be accepted at any time, but the FIRST rvalid is held until
    //    any in-flight write has completed its B handshake, so a read never
    //    returns data ahead of the write meant to update it.
    // =====================================================================
    localparam RD_IDLE = 2'd0, RD_WAIT = 2'd1, RD_DATA = 2'd2;

    reg [1:0]            rd_state;
    reg [ID_WIDTH-1:0]   rd_id;
    reg [ADDR_WIDTH-1:0] rd_addr;
    reg [7:0]            rd_len;
    reg [1:0]            rd_burst;
    reg [2:0]            rd_size;
    reg [ADDR_WIDTH-1:0] rd_wrap_mask;
    reg [7:0]            ar_delay_cnt;   // counts cycles arvalid has waited for arready

    reg [ADDR_WIDTH-1:0] rd_nxt_addr;
    reg [DATA_WIDTH-1:0] fa_data;
    reg                  fa_uf;
    reg [ADDR_WIDTH+8:0] rd_range_lo;   // byte range of the accepted read (for RD_WAIT)
    reg [ADDR_WIDTH+8:0] rd_range_hi;

    // ---- write -> read interlock (address / resource aware) ----
    wire b_handshake  = (wr_state == WR_RESP) && s_axi_bvalid && s_axi_bready;
    // INCR/WRAP memory commit pulse (staged bytes flushed into mem this cycle).
    wire mem_commit   = b_handshake && !wr_is_fifo;

    // Range of the read currently being evaluated: incoming AR in RD_IDLE,
    // latched values in RD_WAIT.
    wire [ADDR_WIDTH+8:0] ar_lo = s_axi_araddr;
    wire [ADDR_WIDTH+8:0] ar_hi = s_axi_araddr + (((s_axi_arlen + 1) << s_axi_arsize) - 1);
    wire [ADDR_WIDTH+8:0] cur_rd_lo = (rd_state == RD_IDLE) ? ar_lo : rd_range_lo;
    wire [ADDR_WIDTH+8:0] cur_rd_hi = (rd_state == RD_IDLE) ? ar_hi : rd_range_hi;
    wire rd_is_fifo_now = (rd_state == RD_IDLE) ? (s_axi_arburst == BURST_FIXED)
                                               : (rd_burst       == BURST_FIXED);

    wire ranges_overlap = (wr_range_lo <= cur_rd_hi) && (cur_rd_lo <= wr_range_hi);

    // Hazard rules:
    //   FIFO read  vs FIFO write  -> always (shared FIFO, address-agnostic)
    //   mem  read  vs mem  write  -> only if the byte ranges overlap
    //   mixed (one FIFO, one mem) -> independent storage -> no hazard
    wire hazard = wr_inflight &&
                  ( (wr_is_fifo && rd_is_fifo_now)            ? 1'b1 :
                    (!wr_is_fifo && !rd_is_fifo_now)          ? ranges_overlap : 1'b0 );

    // Read may proceed if there is no hazard, or the hazarding write is
    // completing its B handshake this cycle (data now visible / forwardable).
    wire read_allowed = (!hazard) || b_handshake;

    // First-beat load events: fast path from IDLE, or release from WAIT.
    wire ld_first_idle = (rd_state == RD_IDLE) && s_axi_arvalid && s_axi_arready && read_allowed;
    wire ld_first_wait = (rd_state == RD_WAIT) && read_allowed;

    wire rd_first_fixed = (ld_first_idle && (s_axi_arburst == BURST_FIXED)) ||
                          (ld_first_wait && (rd_burst       == BURST_FIXED));
    wire rd_next_fixed  = (rd_state == RD_DATA) && s_axi_rvalid && s_axi_rready &&
                          (rd_len != 8'd0) && (rd_burst == BURST_FIXED);
    // Subsequent beats follow a virtual INCR-advancing address (even for FIXED
    // reads): the lane offset rotates with that address, matching the scoreboard
    // which walks tempAddress byte-by-byte. WRAP keeps its wrap behaviour.
    wire [ADDR_WIDTH-1:0] rd_next_lane_addr =
        next_addr(rd_addr, (rd_burst == BURST_WRAP) ? BURST_WRAP : BURST_INCR,
                  rd_size, rd_wrap_mask);

    wire        fifo_pop_req   = rd_first_fixed || rd_next_fixed;
    wire [7:0]  fifo_pop_count =
        ld_first_idle ? lane_count_f(s_axi_araddr,      s_axi_arsize) :
        ld_first_wait ? lane_count_f(rd_addr,           rd_size)      :
        rd_next_fixed ? lane_count_f(rd_next_lane_addr, rd_size)      : 8'd0;

    // Present the first beat of a read on the R channel. Pop / forwarding are
    // resolved in the FIFO control block via the wires above.
    task load_first_beat;
        input [ADDR_WIDTH-1:0] addr;
        input [2:0]            size;
        input [1:0]            burst;
        input [7:0]            len;
        input [ID_WIDTH-1:0]   id;
        reg [ADDR_WIDTH-1:0] wbase;
        reg [STRB_WIDTH-1:0] rlm;
        reg [DATA_WIDTH-1:0] rmasked;
        integer mb;
        begin
            s_axi_rvalid <= 1'b1;
            s_axi_rid    <= id;
            s_axi_rlast  <= (len == 8'd0);
            if (burst == BURST_FIXED) begin
                fifo_assemble(addr, size, fifo_commit, fa_data, fa_uf);
                s_axi_rdata <= fa_data;
                s_axi_rresp <= fa_uf ? RESP_SLVERR : RESP_OKAY;
            end else begin
                // INCR/WRAP -> byte-addressed read, mirroring the scoreboard:
                // rdata[8*b +: 8] = mem[(addr aligned to bus) + b] for the
                // addressed lanes; unaddressed lanes are driven 0.
                wbase = addr & ~(STRB_WIDTH-1);
                rlm = lane_mask_f(addr, size);
                rmasked = {DATA_WIDTH{1'b0}};
                for (mb = 0; mb < STRB_WIDTH; mb = mb + 1)
                    if (rlm[mb] && ((wbase + mb) < MEM_BYTES))
                        rmasked[mb*8 +: 8] = mem_byte(wbase + mb, mem_commit);
                if ((wbase + STRB_WIDTH-1) < MEM_BYTES) begin
                    s_axi_rdata <= rmasked;
                    s_axi_rresp <= RESP_OKAY;
                end else begin
                    s_axi_rdata <= {DATA_WIDTH{1'b0}};
                    s_axi_rresp <= RESP_SLVERR;
                end
            end
        end
    endtask

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            rd_state      <= RD_IDLE;
            s_axi_arready <= 1'b0;
            ar_delay_cnt  <= 8'd0;
            s_axi_rvalid  <= 1'b0;
            s_axi_rlast   <= 1'b0;
            s_axi_rid     <= {ID_WIDTH{1'b0}};
            s_axi_rdata   <= {DATA_WIDTH{1'b0}};
            s_axi_rresp   <= RESP_OKAY;
            // rd_addr/rd_size/rd_burst/rd_wrap_mask feed the continuous
            // rd_next_lane_addr wire (next_addr call), which is evaluated every
            // cycle regardless of read activity. Without a reset value they sit
            // at X from time 0 until the first AR completes, so next_addr shows
            // X in waveforms during that window (harmless, since it's gated by
            // rd_next_fixed before use, but defined values are cleaner and avoid
            // false X-propagation/lint flags).
            rd_addr       <= {ADDR_WIDTH{1'b0}};
            rd_len        <= 8'd0;
            rd_burst      <= BURST_FIXED;
            rd_size       <= 3'd0;
            rd_wrap_mask  <= {ADDR_WIDTH{1'b0}};
        end else begin
            case (rd_state)
                RD_IDLE: begin
                    s_axi_rvalid  <= 1'b0;
                    s_axi_rlast   <= 1'b0;
                    if (s_axi_arready) begin
                        // arready already asserted: complete the AR handshake
                        if (s_axi_arvalid) begin
                            rd_id        <= s_axi_arid;
                            rd_addr      <= s_axi_araddr;
                            rd_len       <= s_axi_arlen;
                            rd_burst     <= s_axi_arburst;
                            rd_size      <= s_axi_arsize;
                            rd_wrap_mask <= wrap_mask(s_axi_arlen, s_axi_arsize);
                            rd_range_lo  <= ar_lo;
                            rd_range_hi  <= ar_hi;
                            s_axi_arready <= 1'b0;
                            ar_delay_cnt  <= 8'd0;
                            if (read_allowed) begin
                                // No write pending -> present first beat now
                                load_first_beat(s_axi_araddr, s_axi_arsize,
                                                s_axi_arburst, s_axi_arlen, s_axi_arid);
                                rd_state <= RD_DATA;
                            end else begin
                                // Write in flight -> hold data until B handshake
                                rd_state <= RD_WAIT;
                            end
                        end
                    end else begin
                        // arready low: wait AR_READY_DELAY cycles after arvalid,
                        // then assert arready for one cycle to accept the address.
                        if (s_axi_arvalid) begin
                            if (ar_delay_cnt >= (AR_READY_DELAY - 1)) begin
                                s_axi_arready <= 1'b1;
                                ar_delay_cnt  <= 8'd0;
                            end else begin
                                ar_delay_cnt  <= ar_delay_cnt + 8'd1;
                            end
                        end else begin
                            ar_delay_cnt <= 8'd0;
                        end
                    end
                end

                RD_WAIT: begin
                    s_axi_rvalid <= 1'b0;          // no rvalid before the write response
                    if (read_allowed) begin
                        load_first_beat(rd_addr, rd_size, rd_burst, rd_len, rd_id);
                        rd_state <= RD_DATA;
                    end
                end

                RD_DATA: begin
                    if (s_axi_rvalid && s_axi_rready) begin
                        if (rd_len == 8'd0) begin
                            s_axi_rvalid  <= 1'b0;
                            s_axi_rlast   <= 1'b0;
                            s_axi_arready <= 1'b0;    // re-arm AR_READY_DELAY for next read
                            ar_delay_cnt  <= 8'd0;
                            rd_state      <= RD_IDLE;
                        end else begin
                            rd_nxt_addr = rd_next_lane_addr;   // INCR-advance (FIXED too); WRAP wraps
                            rd_addr     <= rd_nxt_addr;
                            rd_len      <= rd_len - 1;
                            s_axi_rlast <= (rd_len == 8'd1);
                            if (rd_burst == BURST_FIXED) begin
                                // Lanes follow the advanced virtual address
                                fifo_assemble(rd_nxt_addr, rd_size, fifo_commit, fa_data, fa_uf);
                                s_axi_rdata <= fa_data;
                                s_axi_rresp <= fa_uf ? RESP_SLVERR : RESP_OKAY;
                            end else begin : rmask_blk
                                integer mb; reg [STRB_WIDTH-1:0] rlm;
                                reg [DATA_WIDTH-1:0] rmasked;
                                reg [ADDR_WIDTH-1:0] rbase;
                                rbase = rd_nxt_addr & ~(STRB_WIDTH-1);
                                rlm = lane_mask_f(rd_nxt_addr, rd_size);
                                rmasked = {DATA_WIDTH{1'b0}};
                                for (mb = 0; mb < STRB_WIDTH; mb = mb + 1)
                                    if (rlm[mb] && ((rbase + mb) < MEM_BYTES))
                                        rmasked[mb*8 +: 8] = mem_byte(rbase + mb, mem_commit);
                                if ((rbase + STRB_WIDTH-1) < MEM_BYTES) begin
                                    s_axi_rdata <= rmasked;
                                    s_axi_rresp <= RESP_OKAY;
                                end else begin
                                    s_axi_rdata <= {DATA_WIDTH{1'b0}};
                                    s_axi_rresp <= RESP_SLVERR;
                                end
                            end
                        end
                    end
                end
                default: rd_state <= RD_IDLE;
            endcase
        end
    end

    // =====================================================================
    //  FIFO CONTROL
    //    PUSH (commit) on B-channel handshake; POP on FIXED read beats.
    //    A pop coincident with a commit may consume the just-committed bytes
    //    (store-to-load forwarding), matching the read-data bypass above.
    // =====================================================================
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            fifo_wr_ptr <= {PTR_W{1'b0}};
            fifo_rd_ptr <= {PTR_W{1'b0}};
            fifo_count  <= {(PTR_W+1){1'b0}};
        end else begin : fifo_ctrl
            integer i, pushed, popped, wp;
            wp = fifo_wr_ptr;
            pushed = 0;
            // COMMIT: move staged bytes into the FIFO at the B handshake
            if (fifo_commit) begin
                for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
                    if ((i < stg_store) && ((fifo_count + pushed) < FIFO_DEPTH)) begin
                        fifo_mem[wp % FIFO_DEPTH] <= stg_mem[i];
                        wp     = wp + 1;
                        pushed = pushed + 1;
                    end
                end
            end
            // POP: oldest bytes for a FIXED read beat. Forwarding allowed:
            // available = pre-existing bytes + bytes committed this same cycle.
            popped = 0;
            if (fifo_pop_req)
                popped = (fifo_pop_count <= (fifo_count + pushed)) ?
                          fifo_pop_count : (fifo_count + pushed);

            fifo_wr_ptr <= wp % FIFO_DEPTH;
            fifo_rd_ptr <= (fifo_rd_ptr + popped) % FIFO_DEPTH;
            fifo_count  <= fifo_count + pushed - popped;
        end
    end

endmodule
