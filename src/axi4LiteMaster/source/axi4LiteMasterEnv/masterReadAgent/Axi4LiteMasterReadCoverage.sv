`ifndef AXI4LITEMASTERREADCOVERAGE_INCLUDED_
`define AXI4LITEMASTERREADCOVERAGE_INCLUDED_

//--------------------------------------------------------------------------------------------
// master_coverage determines the how much code is covered for better functionality of the TB.
//--------------------------------------------------------------------------------------------
class Axi4LiteMasterReadCoverage extends uvm_subscriber #(Axi4LiteMasterReadTransaction);
  `uvm_component_utils(Axi4LiteMasterReadCoverage)

  // Declaring handle for master agent configuration class 
  Axi4LiteMasterReadAgentConfig axi4LiteMasterReadAgentConfig;
 
  //-------------------------------------------------------
  // Covergroup: axi4_master_covergroup
  // Covergroup consists of the various coverpoints based on
  // no. of the variables used to improve the coverage.
  //-------------------------------------------------------
/*  covergroup axi4_master_covergroup with function sample (Axi4LiteMasterReadAgentConfig cfg, Axi4LiteMasterReadTransaction packet);
    option.per_instance = 1;

    //-------------------------------------------------------
    // Read channel signals 
    //-------------------------------------------------------
   
    AWLEN_CP : coverpoint packet.awlen {
      option.comment = "Read Address Length values";
      bins AWLEN_1      = {0};
      bins AWLEN_2      = {1};
      bins AWLEN_4      = {3};
      bins AWLEN_8      = {7};
      bins AWLEN_16     = {15};
      bins AWLEN_32     = {31};
      bins AWLEN_64     = {63};
      bins AWLEN_128    = {127};
      bins AWLEN_256    = {255};
      bins AWLEN_DEFAULT = default ;
    }

    AWBURST_CP : coverpoint packet.awburst {
      option.comment = "Read Address Burst values";
      bins READ_FIXED = {0};
      bins READ_INCR = {1}; 
      bins READ_WRAP  = {2};     
      illegal_bins ILLEGAL_BIN_OF_AWBURST = {3};     
    }

    AWSIZE_CP : coverpoint packet.awsize {
      option.comment = "Read Address size values";
      bins AWSIZE_1BYTE    = {0};
      bins AWSIZE_2BYTES   = {1};
      bins AWSIZE_4BYTES   = {2};
      bins AWSIZE_8BYTES   = {3};
      bins AWSIZE_16BYTES  = {4};
      bins AWSIZE_32BYTES  = {5};
      bins AWSIZE_64BYTES  = {6};
      bins AWSIZE_128BYTES = {7};
    }

    AWLOCK_CP :coverpoint packet.awlock {
      option.comment= "Read Address Lock values";
      bins AWLOCK[] = {0,1};
    }

    AWCACHE_CP : coverpoint packet.awcache {
      option.comment = "Read Address Cache values";
      bins READ_BUFFERABLE     = {0};
      bins READ_MODIFIABLE     = {1};
      bins READ_OTHER_ALLOCATE = {2}; 
      bins READ_ALLOCATE       = {3};
    }

    AWPROT_CP : coverpoint packet.awprot {
      option.comment = "Read Address Protection values";
      bins AWPROT[] = {[0:$]};
    }

    AWID_CP : coverpoint packet.awid {
      option.comment = "Read Address ID values";
      bins AWID[] = {[0:$]};
    }

    BRESP_CP : coverpoint packet.bresp {
      option.comment    = "Read Response values";
      bins READ_OKAY   = {0};
      bins READ_EXOKAY = {1};
      bins READ_SLVERR = {2};
      bins READ_DECERR = {3};
    }

    //-------------------------------------------------------
    // Read channel signals 
    //-------------------------------------------------------
    
    ARLEN_CP : coverpoint packet.arlen {
      option.comment = "Read Address Length values";
      bins ARLEN_1   = {0};
      bins ARLEN_2   = {1};
      bins ARLEN_4   = {3};
      bins ARLEN_8   = {7};
      bins ARLEN_16  = {15};
      bins ARLEN_32  = {31};
      bins ARLEN_64  = {63};
      bins ARLEN_128 = {127};
      bins ARLEN_256 = {255};
      bins ARLEN_DEFAULT= default ;
    }

    ARBURST_CP : coverpoint packet.arburst {
      option.comment = "Read Address Burst values";
      bins READ_FIXED ={0};
      bins READ_INCR ={1}; 
      bins READ_WRAP  ={2};   
      illegal_bins ILLEGAL_BIN_OF_ARBURST = {3};   
    }

    ARSIZE_CP : coverpoint packet.arsize {
      option.comment = "Read Address Size values";
      bins ARSIZE_1BYTE    = {0};
      bins ARSIZE_2BYTES   = {1};
      bins ARSIZE_4BYTES   = {2};
      bins ARSIZE_8BYTES   = {3};
      bins ARSIZE_16BYTES  = {4};
      bins ARSIZE_32BYTES  = {5};
      bins ARSIZE_64BYTES  = {6};
      bins ARSIZE_128BYTES = {7};
    }

    ARLOCK_CP :coverpoint packet.arlock {
      option.comment= "Read Address Lock values";
      bins ARLOCK[] = {0,1};
    }

    ARCACHE_CP : coverpoint packet.arcache {
      option.comment = "Read Address Cache values";
      bins READ_BUFFERABLE = {0};
      bins READ_MODIFIABLE = {1};
      bins READ_OTHER_ALLOCATE = {2}; 
      bins READ_ALLOCATE = {3};
    }

    ARPROT_CP : coverpoint packet.arprot {
      option.comment = "Read Address Protection values";
      bins ARPROT[] = {[0:$]};
    }

    BID_CP : coverpoint packet.bid {
      option.comment = "Read Response values";
      bins BID[] = {[0:$]};
    }

    ARID_CP : coverpoint packet.rid {
      option.comment = "Read Address ID values";
      bins ARID[] = {[0:$]};
    }

    RID_CP : coverpoint packet.rid {
      option.comment = "Read ID values";
      bins RID[] = {[0:$]};
    }
    
    RRESP_CP : coverpoint packet.rresp {
      option.comment    = "Read Response values";
      bins READ_OKAY    = {0};
      bins READ_EXOKAY  = {1};
      bins READ_SLVERR  = {2};
      bins READ_DECERR  = {3};
    }
    

    TRANSFER_TYPE_CP : coverpoint packet.transfer_type {
      option.comment = "transfer type";
      bins BLOCKING_READ     = {0};
      bins BLOCKING_READ      = {1};
      bins NON_BLOCKING_READ = {2};
      bins NON_BLOCKING_READ  = {3};
    }

    //-------------------------------------------------------
    // Cross of coverpoints
    //-------------------------------------------------------

    AWLENGTH_CP_X_AWSIZE_X_AWBURST    :cross AWLEN_CP,AWSIZE_CP,AWBURST_CP;
    ARLENGTH_CP_X_ARSIZE_X_ARBURST    :cross ARLEN_CP,ARSIZE_CP,ARBURST_CP;
    BID_CP_X_BRESP_CP                 :cross BID_CP,BRESP_CP;
    RID_CP_X_RRESP_CP                 :cross BID_CP,BRESP_CP;
    AWBURST_CP_X_AWLEN_CP_X_AWSIZE_CP :cross AWBURST_CP,AWLEN_CP,AWSIZE_CP;
    ARBURST_CP_X_ARLEN_CP_X_ARSIZE_CP :cross ARBURST_CP,ARLEN_CP,ARSIZE_CP;
    // TRANSFER_TYPE_CP_X_BURST_TYPE_CP  :cross TRANSFER_TYPE_CP,BURST_TYPE_CP;

  endgroup: axi4_master_covergroup
*/

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "Axi4LiteMasterReadCoverage", uvm_component parent = null);
  extern virtual function void write(Axi4LiteMasterReadTransaction t);
  //extern virtual function void report_phase(uvm_phase phase);

endclass : Axi4LiteMasterReadCoverage

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - Axi4LiteMasterReadCoverage
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function Axi4LiteMasterReadCoverage::new(string name = "Axi4LiteMasterReadCoverage",
                                 uvm_component parent = null);
  super.new(name, parent);
  // GopalS: axi4_master_covergroup =new();
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: write
// sampling is done
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadCoverage::write(Axi4LiteMasterReadTransaction t);
 `uvm_info(get_type_name(),$sformatf("Before calling SAMPLE METHOD"),UVM_HIGH);

//  axi4_master_covergroup.sample(axi4LiteMasterReadAgentConfig,t);

  `uvm_info(get_type_name(),"After calling SAMPLE METHOD",UVM_HIGH);
endfunction: write

/*
//--------------------------------------------------------------------------------------------
// Function: report_phase
// Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadCoverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("AXI4 Master Agent Coverage = %0.2f %%", axi4_master_covergroup.get_coverage()), UVM_NONE);
endfunction: report_phase
*/
`endif

