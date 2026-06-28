module axi_master #(
    // ---- bus geometry (keep aligned with the slave) ----
    parameter DATA_WIDTH      = 32,
    parameter ADDR_WIDTH      = 12,
    parameter ID_WIDTH        = 4,
    parameter MEM_DEPTH       = 1024,   // used only to keep addresses in range

    // ---- traffic controls (the knobs you asked for) ----
    parameter NUM_WR_TXN      = 8,      // number of write transactions to send
    parameter NUM_RD_TXN      = 8,      // number of read  transactions to send
    parameter OUTSTANDING     = 0,      // 0 = non-outstanding, 1 = outstanding
    parameter MAX_OUTSTANDING = 4,      // in-flight depth when OUTSTANDING = 1

    // ---- randomization controls ----
    parameter MAX_BURST_LEN   = 7,      // max awlen/arlen (beats-1); MUST be 2^k-1
    parameter RANDOM_WSTRB    = 0,      // 0 = all lanes enabled, 1 = random strobes
    parameter [31:0] SEED     = 32'hACE1_2345,
    parameter VERBOSE         = 1       // 1 = $display per handshake (sim only)
)(
    input  wire                    s_axi_aclk,
    input  wire                    s_axi_aresetn,

    // ------------------------------------------------ Write Address (AW)
    output reg  [ID_WIDTH-1:0]     s_axi_awid,
    output reg  [ADDR_WIDTH-1:0]   s_axi_awaddr,
    output reg  [7:0]              s_axi_awlen,
    output reg  [2:0]              s_axi_awsize,
    output reg  [1:0]              s_axi_awburst,
    output reg                     s_axi_awlock,
    output reg  [3:0]              s_axi_awcache,
    output reg  [2:0]              s_axi_awprot,
    output reg  [3:0]              s_axi_awqos,
    output reg  [3:0]              s_axi_awregion,
    output reg                     s_axi_awvalid,
    input  wire                    s_axi_awready,

    // ------------------------------------------------ Write Data (W)
    output reg  [DATA_WIDTH-1:0]   s_axi_wdata,
    output reg  [DATA_WIDTH/8-1:0] s_axi_wstrb,
    output reg                     s_axi_wlast,
    output reg                     s_axi_wvalid,
    input  wire                    s_axi_wready,

    // ------------------------------------------------ Write Response (B)
    input  wire [ID_WIDTH-1:0]     s_axi_bid,
    input  wire [1:0]              s_axi_bresp,
    input  wire                    s_axi_bvalid,
    output reg                     s_axi_bready,

    // ------------------------------------------------ Read Address (AR)
    output reg  [ID_WIDTH-1:0]     s_axi_arid,
    output reg  [ADDR_WIDTH-1:0]   s_axi_araddr,
    output reg  [7:0]              s_axi_arlen,
    output reg  [2:0]              s_axi_arsize,
    output wire  [1:0]              s_axi_arburst,
    output reg                     s_axi_arlock,
    output reg  [3:0]              s_axi_arcache,
    output reg  [2:0]              s_axi_arprot,
    output reg  [3:0]              s_axi_arqos,
    output reg  [3:0]              s_axi_arregion,
    output reg                     s_axi_arvalid,
    input  wire                    s_axi_arready,

    // ------------------------------------------------ Read Data (R)
    input  wire [ID_WIDTH-1:0]     s_axi_rid,
    input  wire [DATA_WIDTH-1:0]   s_axi_rdata,
    input  wire [1:0]              s_axi_rresp,
    input  wire                    s_axi_rlast,
    input  wire                    s_axi_rvalid,
    output reg                     s_axi_rready,

    // ------------------------------------------------ Status
    output wire                    wr_done,
    output wire                    rd_done,
    output wire                    done
);

    // -------------------------------------------------------------------------
    // Local parameters
    // -------------------------------------------------------------------------
    localparam STRB_WIDTH = DATA_WIDTH / 8;
    localparam BYTE_BITS  = $clog2(STRB_WIDTH);     // byte-offset bits
    localparam [2:0] FULL_SIZE = BYTE_BITS[2:0];    // full-width beats only

    localparam BURST_FIXED = 2'b00,
               BURST_INCR  = 2'b01,
               BURST_WRAP  = 2'b10;

    // Effective in-flight limit selected by the OUTSTANDING switch
    localparam WR_OS_LIMIT = (OUTSTANDING != 0) ? MAX_OUTSTANDING : 1;
    localparam RD_OS_LIMIT = (OUTSTANDING != 0) ? MAX_OUTSTANDING : 1;

    // Bit fields used to slice the address-LFSR into legal transaction params
    localparam AWB      = $clog2(MEM_DEPTH);        // word-index bits
    localparam LEN_BITS = $clog2(MAX_BURST_LEN + 1);

    // LFSR seeds (kept non-zero and de-correlated)
    localparam [31:0]           SEED_AW  = SEED ^ 32'hA5A5_A5A5;
    localparam [31:0]           SEED_AR  = SEED ^ 32'h5A5A_5A5A;
    localparam [DATA_WIDTH-1:0] SEED_DAT = SEED ^ {DATA_WIDTH{1'b1}};

    // -------------------------------------------------------------------------
    // Channel handshake pulses
    // -------------------------------------------------------------------------
    wire aw_hs     = s_axi_awvalid & s_axi_awready;
    wire w_hs      = s_axi_wvalid  & s_axi_wready;
    wire b_hs      = s_axi_bvalid  & s_axi_bready;
    wire ar_hs     = s_axi_arvalid & s_axi_arready;
    wire r_hs      = s_axi_rvalid  & s_axi_rready;
    wire r_last_hs = r_hs & s_axi_rlast;

    // -------------------------------------------------------------------------
    // Free-running pseudo-random sources
    //   - lfsr_aw / lfsr_ar : 32-bit maximal LFSRs (x^32+x^22+x^2+x+1)
    //   - lfsr_dat          : DATA_WIDTH-wide source for write data / strobes
    // Sampling them at handshake instants yields the random fields.
    // -------------------------------------------------------------------------
    reg [31:0]           lfsr_aw, lfsr_ar;
    reg [DATA_WIDTH-1:0] lfsr_dat;

    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) lfsr_aw <= SEED_AW;
        else lfsr_aw <= {lfsr_aw[30:0],
                         lfsr_aw[31]^lfsr_aw[21]^lfsr_aw[1]^lfsr_aw[0]};

    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) lfsr_ar <= SEED_AR;
        else lfsr_ar <= {lfsr_ar[30:0],
                         lfsr_ar[31]^lfsr_ar[21]^lfsr_ar[1]^lfsr_ar[0]};

    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) lfsr_dat <= SEED_DAT;
        else lfsr_dat <= {lfsr_dat[DATA_WIDTH-2:0],
                          lfsr_dat[DATA_WIDTH-1]^lfsr_dat[DATA_WIDTH/2]^
                          lfsr_dat[1]^lfsr_dat[0]};

    assign s_axi_arburst =1;
    // Per-beat write payload (fresh every cycle because lfsr_dat free-runs)
    wire [DATA_WIDTH-1:0] gen_wdata = lfsr_dat;
    wire [STRB_WIDTH-1:0] gen_wstrb = (RANDOM_WSTRB != 0) ? lfsr_dat[STRB_WIDTH-1:0]
                                                          : {STRB_WIDTH{1'b1}};

    // -------------------------------------------------------------------------
    // Bookkeeping counters (each has exactly ONE writer process)
    // -------------------------------------------------------------------------
    reg [31:0] wr_issued, wr_completed;   // AW accepted / B received
    reg [31:0] rd_issued, rd_completed;   // AR accepted / rlast received
    reg [15:0] wr_outstanding;            // AW accepted - B received
    reg [15:0] rd_outstanding;            // AR accepted - rlast received

    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) wr_issued <= 0; else if (aw_hs)     wr_issued    <= wr_issued + 1;
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) wr_completed <= 0; else if (b_hs)   wr_completed <= wr_completed + 1;
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) rd_issued <= 0; else if (ar_hs)     rd_issued    <= rd_issued + 1;
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) rd_completed <= 0; else if (r_last_hs) rd_completed <= rd_completed + 1;

    // The outstanding counters fold both the +1 (request accepted) and the
    // -1 (response received) events, so they have a single driver.
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) wr_outstanding <= 0;
        else                wr_outstanding <= wr_outstanding + aw_hs - b_hs;
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) rd_outstanding <= 0;
        else                rd_outstanding <= rd_outstanding + ar_hs - r_last_hs;

    assign wr_done = (wr_completed >= NUM_WR_TXN);
    assign rd_done = (rd_completed >= NUM_RD_TXN);
    assign done    = wr_done & rd_done;

    // Always able to sink responses
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) s_axi_bready <= 1'b0; else s_axi_bready <= 1'b1;
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if (!s_axi_aresetn) s_axi_rready <= 1'b0; else s_axi_rready <= 1'b1;

    // =========================================================================
    // WRITE engine  (AW + W coupled; B reaped by the counters above)
    //
    //   non-outstanding : WR_OS_LIMIT = 1, so a new AW cannot start until the
    //                     previous B has come back (wr_outstanding == 0).
    //   outstanding     : WR_OS_LIMIT = MAX_OUTSTANDING, so further AW/W bursts
    //                     are launched while earlier B responses are still
    //                     pending (up to MAX_OUTSTANDING of them).
    // =========================================================================
    localparam WR_IDLE = 2'd0, WR_ADDR = 2'd1, WR_DATA = 2'd2;
    reg [1:0] wr_state;
    reg [8:0] w_rem;                 // beats left to send in current burst

    // transaction-generation temporaries (written only in this block)
    reg [1:0]            gw_burst;
    reg [7:0]            gw_len;
    reg [8:0]            gw_beats;
    reg [15:0]           gw_bytes;
    reg [ADDR_WIDTH-1:0] gw_word;
    reg [ADDR_WIDTH-1:0] gw_wordmax;
    reg [ADDR_WIDTH-1:0] gw_addr;
    reg [ADDR_WIDTH-1:0] gw_mask;

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            wr_state       <= WR_IDLE;
            s_axi_awvalid  <= 1'b0;
            s_axi_awid     <= {ID_WIDTH{1'b0}};
            s_axi_awaddr   <= {ADDR_WIDTH{1'b0}};
            s_axi_awlen    <= 8'd0;
            s_axi_awsize   <= FULL_SIZE;
            s_axi_awburst  <= BURST_INCR;
            s_axi_awlock   <= 1'b0;
            s_axi_awcache  <= 4'b0010;
            s_axi_awprot   <= 3'b000;
            s_axi_awqos    <= 4'b0000;
            s_axi_awregion <= 4'b0000;
            s_axi_wvalid   <= 1'b0;
            s_axi_wdata    <= {DATA_WIDTH{1'b0}};
            s_axi_wstrb    <= {STRB_WIDTH{1'b0}};
            s_axi_wlast    <= 1'b0;
            w_rem          <= 9'd0;
        end else begin
            case (wr_state)

                // -- decide whether to launch the next write -------------------
                WR_IDLE: begin
                    s_axi_awvalid <= 1'b0;
                    s_axi_wvalid  <= 1'b0;
                    s_axi_wlast   <= 1'b0;

                    if ((wr_issued < NUM_WR_TXN) &&
                        (wr_outstanding < WR_OS_LIMIT)) begin
                        // --- randomize a legal burst -------------------------
                        gw_burst = lfsr_aw[31:30];
                        if (gw_burst == 2'b11) gw_burst = BURST_INCR; // 11 reserved

                        if (gw_burst == BURST_WRAP) begin
                            // WRAP must be 2/4/8/16 beats -> len 1/3/7/15
                            case (lfsr_aw[29:28])
                                2'd0: gw_len = 8'd1;
                                2'd1: gw_len = 8'd3;
                                2'd2: gw_len = 8'd7;
                                default: gw_len = 8'd15;
                            endcase
                            if (gw_len > MAX_BURST_LEN) gw_len = MAX_BURST_LEN;
                        end else begin
                            gw_len = lfsr_aw[AWB +: LEN_BITS] & MAX_BURST_LEN[7:0];
                        end

                        gw_beats   = gw_len + 1'b1;
                        gw_bytes   = gw_beats << BYTE_BITS;
                        gw_word    = lfsr_aw[AWB-1:0];
                        gw_wordmax = MEM_DEPTH - gw_beats;          // keep in range
                        if (gw_word > gw_wordmax) gw_word = gw_wordmax;
                        gw_addr    = gw_word << BYTE_BITS;
                        if (gw_burst == BURST_WRAP) begin
                            gw_mask = gw_bytes - 1'b1;              // align WRAP base
                            gw_addr = gw_addr & ~gw_mask;
                        end

                        // --- drive the AW channel ----------------------------
                        s_axi_awid    <= lfsr_aw[ID_WIDTH-1:0];
                        s_axi_awaddr  <= gw_addr;
                        s_axi_awlen   <= gw_len;
                        s_axi_awsize  <= FULL_SIZE;
                        s_axi_awburst <= gw_burst;
                        s_axi_awvalid <= 1'b1;
                        w_rem         <= gw_beats;
                        wr_state      <= WR_ADDR;
                    end
                end

                // -- hold AW until accepted, then begin streaming W -----------
                WR_ADDR: begin
                    if (aw_hs) begin
                        s_axi_awvalid <= 1'b0;
                        s_axi_wvalid  <= 1'b1;
                        s_axi_wdata   <= gen_wdata;
                        s_axi_wstrb   <= gen_wstrb;
                        s_axi_wlast   <= (w_rem == 9'd1);
                        wr_state      <= WR_DATA;
                    end
                end

                // -- stream the write-data beats ------------------------------
                WR_DATA: begin
                    if (w_hs) begin
                        if (w_rem == 9'd1) begin
                            s_axi_wvalid <= 1'b0;
                            s_axi_wlast  <= 1'b0;
                            wr_state     <= WR_IDLE;
                        end else begin
                            w_rem        <= w_rem - 1'b1;
                            s_axi_wdata  <= gen_wdata;
                            s_axi_wstrb  <= gen_wstrb;
                            s_axi_wlast  <= (w_rem == 9'd2); // next beat is last
                        end
                    end
                end

                default: wr_state <= WR_IDLE;
            endcase
        end
    end

    // =========================================================================
    // READ engine  (AR issue; R data reaped by the counters above)
    // =========================================================================
    localparam RD_IDLE = 1'b0, RD_ADDR = 1'b1;
    reg rd_state;

    reg [1:0]            gr_burst;
    reg [7:0]            gr_len;
    reg [8:0]            gr_beats;
    reg [15:0]           gr_bytes;
    reg [ADDR_WIDTH-1:0] gr_word;
    reg [ADDR_WIDTH-1:0] gr_wordmax;
    reg [ADDR_WIDTH-1:0] gr_addr;
    reg [ADDR_WIDTH-1:0] gr_mask;

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            rd_state       <= RD_IDLE;
            s_axi_arvalid  <= 1'b0;
            s_axi_arid     <= {ID_WIDTH{1'b0}};
            s_axi_araddr   <= {ADDR_WIDTH{1'b0}};
            s_axi_arlen    <= 8'd0;
            s_axi_arsize   <= FULL_SIZE;
            s_axi_arlock   <= 1'b0;
            s_axi_arcache  <= 4'b0010;
            s_axi_arprot   <= 3'b000;
            s_axi_arqos    <= 4'b0000;
            s_axi_arregion <= 4'b0000;
        end else begin
            case (rd_state)

                RD_IDLE: begin
                    s_axi_arvalid <= 1'b0;
                    if ((rd_issued < NUM_RD_TXN) &&
                        (rd_outstanding < RD_OS_LIMIT)) begin
                        gr_burst = lfsr_ar[31:30];
                        if (gr_burst == 2'b11) gr_burst = BURST_INCR;

                        if (gr_burst == BURST_WRAP) begin
                            case (lfsr_ar[29:28])
                                2'd0: gr_len = 8'd1;
                                2'd1: gr_len = 8'd3;
                                2'd2: gr_len = 8'd7;
                                default: gr_len = 8'd15;
                            endcase
                            if (gr_len > MAX_BURST_LEN) gr_len = MAX_BURST_LEN;
                        end else begin
                            gr_len = lfsr_ar[AWB +: LEN_BITS] & MAX_BURST_LEN[7:0];
                        end

                        gr_beats   = gr_len + 1'b1;
                        gr_bytes   = gr_beats << BYTE_BITS;
                        gr_word    = lfsr_ar[AWB-1:0];
                        gr_wordmax = MEM_DEPTH - gr_beats;
                        if (gr_word > gr_wordmax) gr_word = gr_wordmax;
                        gr_addr    = gr_word << BYTE_BITS;
                        if (gr_burst == BURST_WRAP) begin
                            gr_mask = gr_bytes - 1'b1;
                            gr_addr = gr_addr & ~gr_mask;
                        end

                        s_axi_arid    <= lfsr_ar[ID_WIDTH-1:0];
                        s_axi_araddr  <= gr_addr;
                        s_axi_arlen   <= gr_len;
                        s_axi_arsize  <= FULL_SIZE;
                        s_axi_arvalid <= 1'b1;
                        rd_state      <= RD_ADDR;
                    end
                end

                RD_ADDR: begin
                    if (ar_hs) begin
                        s_axi_arvalid <= 1'b0;
                        rd_state      <= RD_IDLE;
                    end
                end

                default: rd_state <= RD_IDLE;
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // Optional simulation logging (ignored by synthesis)
    // -------------------------------------------------------------------------
`ifndef SYNTHESIS
    always @(posedge s_axi_aclk) if (s_axi_aresetn && (VERBOSE != 0)) begin
        if (aw_hs)
            $display("[%0t] WR  AW  id=%0d addr=0x%0h len=%0d burst=%0d",
                     $time, s_axi_awid, s_axi_awaddr, s_axi_awlen, s_axi_awburst);
        if (b_hs)
            $display("[%0t] WR  B   id=%0d resp=%0d  (%0d/%0d done)",
                     $time, s_axi_bid, s_axi_bresp, wr_completed+1, NUM_WR_TXN);
        if (ar_hs)
            $display("[%0t] RD  AR  id=%0d addr=0x%0h len=%0d burst=%0d",
                     $time, s_axi_arid, s_axi_araddr, s_axi_arlen, s_axi_arburst);
        if (r_last_hs)
            $display("[%0t] RD  R   id=%0d resp=%0d  (%0d/%0d done)",
                     $time, s_axi_rid, s_axi_rresp, rd_completed+1, NUM_RD_TXN);
    end
`endif

endmodule
