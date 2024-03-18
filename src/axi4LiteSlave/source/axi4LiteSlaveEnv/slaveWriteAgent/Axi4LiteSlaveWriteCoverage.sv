`ifndef AXI4LITESLAVEWRITECOVERAGE_INCLUDED_
`define AXI4LITESLAVEWRITECOVERAGE_INCLUDED_

class Axi4LiteSlaveWriteCoverage extends uvm_subscriber#(Axi4LiteSlaveWriteTransaction);
  `uvm_component_utils(Axi4LiteSlaveWriteCoverage)

    covergroup axi4LiteSlaveWriteCovergroup with function sample (Axi4LiteSlaveWriteTransaction packet);
    option.per_instance = 1;
    
   AWADDR_CP : coverpoint packet.awaddr {
      option.comment = "Slave Write Agent awaddress signal";
   }

  endgroup: axi4LiteSlaveWriteCovergroup
  extern function new(string name = "Axi4LiteSlaveWriteCoverage", uvm_component parent = null);
  extern virtual function void write(Axi4LiteSlaveWriteTransaction t);
  extern virtual function void report_phase(uvm_phase phase);
endclass : Axi4LiteSlaveWriteCoverage

function Axi4LiteSlaveWriteCoverage::new(string name = "Axi4LiteSlaveWriteCoverage",uvm_component parent = null);
  super.new(name, parent);
  axi4LiteSlaveWriteCovergroup =new();
endfunction : new

function void Axi4LiteSlaveWriteCoverage::write(Axi4LiteSlaveWriteTransaction t);
 `uvm_info(get_type_name(),$sformatf("Before calling SAMPLE METHOD"),UVM_HIGH);

  axi4LiteSlaveWriteCovergroup.sample(t);

  `uvm_info(get_type_name(),"After calling SAMPLE METHOD",UVM_HIGH);

endfunction: write

function void Axi4LiteSlaveWriteCoverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("AXI4 Slave Agent Coverage = %0.2f %%", axi4LiteSlaveWriteCovergroup.get_coverage()), UVM_NONE);
endfunction: report_phase

`endif

