// Code your design here
module axi_master (
    input ACLK,
    input ARESETn,
  	// Write Address signals from/to slave
    input             AWREADY_a,
    output reg [31:0] AWADDR_a,
    output reg [3:0]  AWID_a,
    output reg [3:0]  AWLEN_a,
    output reg [2:0]  AWSIZE_a,
    output reg [1:0]  AWBURST_a,
  	output reg [1:0]  AWLOCK_a,
    output reg [3:0]  AWCACHE_a,
    output reg [2:0]  AWPROT_a,
    output reg        AWVALID_a,
    // Write Data signals from/to slave
  	input             WREADY_a,
  	output reg [63:0] WDATA_a,
  	output reg [3:0]  WID_a,
  	output reg [3:0] WSTRB_a,
  	output reg        WLAST_a,
  	output reg        WVALID_a,
  	// Write Response signals from/to slave
    input             BVALID_a,
    input       [3:0] BID_a,
    input       [1:0] BRESP_a,
    output reg        BREADY_a,
    // Read Address signals from/to slave
  	input             ARREADY_a,
    output reg [3:0]  ARID_a,
    output reg [31:0] ARADDR_a,
    output reg [3:0]  ARLEN_a,
    output reg [2:0]  ARSIZE_a,
    output reg [1:0]  ARBURST_a,
  	output reg [1:0]  ARLOCK_a,
    output reg [3:0]  ARCACHE_a,
    output reg [2:0]  ARPROT_a,
    output reg        ARVALID_a,
  	// Read Data signal from/to slave
  	input       [63:0] RDATA_a,
    input       [3:0]  RID_a,
    input       [1:0]  RRESP_a,
    input              RLAST_a,
    input              RVALID_a,
    output reg         RREADY_a,
	// outputs from DECODER
    input 		[3:0] TXN_ID_W_dec,
    input 		[31:0] AWADDR_dec,
    input 		[1:0] AWBURST_dec,
    input 		[3:0] AWLEN_dec,
    input 		[2:0] AWSIZE_dec,
    input 		[1:0] AWLOCK_dec,
    input 		[3:0] AWCACHE_dec,
    input 		[2:0] AWPROT_dec,
    input 		[63:0] WDATA_dec,
    input 		[3:0] WSTRB_dec,
    input 		[3:0] TXN_ID_R_dec,
    input 		[31:0] ARADDR_dec, 
    input 		[1:0] ARBURST_dec,
    input 		[2:0] ARSIZE_dec,
    input 		[3:0] ARLEN_dec,
    input 		[1:0] ARLOCK_dec, 
    input 		[2:0] ARCACHE_dec,
    input 		[2:0] ARPROT_dec,
    input       wr_trn_en,
    input       rd_trn_en,
    // inputs to DECODER
  	output reg [63:0] RDATA_dec,
  	output reg [3:0]  RID_dec,
  	output reg [1:0] RRESP_dec,
  	output reg [1:0] BRESP_dec,
  	output reg [3:0] BID_dec,
    output reg       wr_rsp_en,
    output reg       rd_rsp_en  
);
   
  typedef enum logic [2:0] {
    IDLE = 3'h0,
    WRITE_ADDRESS = 3'h1,
    WRITE_DATA = 3'h2,
    WRITE_RESPONSE = 3'h3,
    READ_ADDRESS = 3'h4,
    READ_DATA = 3'h5,
    DONE = 3'h6 } axi_master_states;
  axi_master_states axi_ps,axi_ns;
  
  // State Transition Logic
  always_ff@(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn)
            axi_ps <= IDLE;
        else begin
                $display("THE NEST STATE IS %s @%0t",axi_ns.name(),$time()); 
            axi_ps <= axi_ns;
         end 
    end
  
  // States Logic
  always_comb begin
        case(axi_ps)
          IDLE: begin
            if(wr_trn_en == 1'b1) begin
              axi_ns = WRITE_ADDRESS;
                 $display("NS IS address @%0t",$time());
            end
            else if (rd_trn_en == 1'b1) begin 
              axi_ns = READ_ADDRESS;
            end
            else
              axi_ns = IDLE;
          end
          WRITE_ADDRESS: begin
            if(AWREADY_a == 1'b1 && TXN_ID_W_dec != 3'd0) begin
              axi_ns = WRITE_DATA; 
                $display("NS IS data @%0t",$time());
            end
            else begin 
              axi_ns = WRITE_ADDRESS; 
            end 
          end
          WRITE_DATA: begin
            $display("WRITE DATA STARTS @%t",$time());
            if((WREADY_a == 1'b1) && (AWLEN_a == 4'h0)) begin
              axi_ns = WRITE_RESPONSE; 
            end
            else
              axi_ns = WRITE_DATA;
          end
          WRITE_RESPONSE: begin
            if(BVALID_a == 1'b1) begin
              axi_ns = DONE;
            end
            else
              axi_ns = WRITE_RESPONSE;
          end
          READ_ADDRESS: begin
            if(ARREADY_a == 1'b1 && TXN_ID_R_dec != 3'd0) begin
              axi_ns = READ_DATA;
          end
            else
              axi_ns = READ_ADDRESS;
          end
          READ_DATA: begin
            if(RVALID_a == 1'b1 && ARLEN_a == 3'd0) begin //wrong logic
              axi_ns = DONE;
          end
            else
              axi_ns = READ_DATA;
          end
          DONE: begin
            axi_ns <= IDLE;
          end
            
        endcase
    end
        
    //Output Logic 
  always_ff@(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
          AWADDR_a <= '0;
          AWID_a <= '0;
          AWLEN_a <= '0;
          AWSIZE_a <= '0;
          AWBURST_a <= '0;
          AWLOCK_a <= '0;
          AWCACHE_a <= '0;
          AWPROT_a <= '0;
          AWVALID_a <= '0;
          WDATA_a <= '0;
          WID_a <= '0;
          WSTRB_a <= '0;
          WVALID_a <= '0;
          BREADY_a <= '0;
          ARID_a <= '0;
          ARADDR_a <= '0;
          ARLEN_a <= '0;
          ARSIZE_a <= '0;
          ARBURST_a <= '0;
          ARLOCK_a <= '0;
          ARCACHE_a <= '0;
          ARPROT_a <= '0;
          ARVALID_a <= '0;
          RREADY_a <= '0;
          RDATA_dec <= '0;
          RID_dec <= '0;
          RRESP_dec <= '0;
          BRESP_dec <= '0;
          BID_dec <= '0;
          wr_rsp_en <= '0;
          rd_rsp_en <= '0; 
      end
      else begin
        case(axi_ps)
          IDLE: begin
              $display("IN IDLE STATE AT @%t",$time());
            AWVALID_a <= 1'b0;
           ARVALID_a <= 0; //make arvalid also zero
          end
          WRITE_ADDRESS: begin
                $display("ADDRESS SATE @%t",$time());
            AWVALID_a = 1'b1;
            AWADDR_a <= AWADDR_dec;
            AWID_a <= TXN_ID_W_dec;
            AWLEN_a <= AWLEN_dec;
            AWSIZE_a <= AWSIZE_dec;
            AWBURST_a <= AWBURST_dec;
            AWLOCK_a <= AWLOCK_dec;
            AWCACHE_a <= AWCACHE_dec;
            AWPROT_a <= AWPROT_dec;          
          end
          WRITE_DATA: begin
                  $display("ENTERED HERE len is %0d",AWLEN_a);
 
            WID_a <= 3'h0;
            WSTRB_a <= WSTRB_dec;
            AWADDR_a <= 32'h0;            
            AWVALID_a <= 1'b0;
            WDATA_a <= WDATA_dec;
            WVALID_a <= 1'b1;
            AWLEN_a <= AWLEN_a-4'h1;
          end
          WRITE_RESPONSE: begin
            BREADY_a <= 1'b1;
            BID_dec <= BID_a;
            BRESP_dec <= BRESP_a;
            wr_rsp_en <= 1'b1;
            WVALID_a <= 1'b0;
          end
          READ_ADDRESS: begin
            ARADDR_a <= ARADDR_dec;
            ARID_a <= TXN_ID_R_dec;
            ARLEN_a <= ARLEN_dec;
            ARSIZE_a <= ARSIZE_dec;
            ARBURST_a <= ARBURST_dec;
            ARLOCK_a <= ARLOCK_dec;
            ARCACHE_a <= ARCACHE_dec;
            ARPROT_a <= ARPROT_dec;
            ARVALID_a <= 1'b1;
          end
          READ_DATA: begin
            RREADY_a <= 1'b1;
            RDATA_dec <= RDATA_a; 
            RID_dec <= RID_a;
            RRESP_dec <= RRESP_a;
            rd_rsp_en <= 1'b1;
            ARLEN_a <=ARLEN_a - 1;
            ARVALID_a <= 0;
          end
          DONE: begin //good if you make read ready zero in done state 
            BREADY_a <= 1'b0;
           RREADY_a <= 1'b0;
          end
            
        endcase
      end
    end
    assign WLAST_a = (AWLEN_a==4'h0)?1'b1:1'b0;
  
endmodule
