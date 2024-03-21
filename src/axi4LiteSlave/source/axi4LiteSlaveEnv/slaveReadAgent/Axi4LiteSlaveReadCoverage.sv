`ifndef AXI4LITESLAVEREADCOVERAGE_INCLUDED_
`define AXI4LITESLAVEREADCOVERAGE_INCLUDED_

class Axi4LiteSlaveReadCoverage extends uvm_subscriber#(Axi4LiteSlaveReadTransaction);
  `uvm_component_utils(Axi4LiteSlaveReadCoverage)

  covergroup axi4LiteSlaveReadCovergroup with function sample (Axi4LiteSlaveReadTransaction packet);
    option.per_instance = 1;

    ARADDR_CP : coverpoint packet.araddr {
      option.comment = "Slave Read Address signals";
    }
  endgroup: axi4LiteSlaveReadCovergroup

  extern function new(string name = "Axi4LiteSlaveReadCoverage", uvm_component parent = null);
  extern virtual function void write(Axi4LiteSlaveReadTransaction t);
  extern virtual function void report_phase(uvm_phase phase);
endclass : Axi4LiteSlaveReadCoverage


function Axi4LiteSlaveReadCoverage::new(string name = "Axi4LiteSlaveReadCoverage",uvm_component parent = null);
  super.new(name, parent);
  axi4LiteSlaveReadCovergroup =new();
endfunction : new


function void Axi4LiteSlaveReadCoverage::write(Axi4LiteSlaveReadTransaction t);
 `uvm_info(get_type_name(),$sformatf("Before calling SAMPLE METHOD"),UVM_HIGH);

  axi4LiteSlaveReadCovergroup.sample(t);

  `uvm_info(get_type_name(),"After calling SAMPLE METHOD",UVM_HIGH);

endfunction: write

function void Axi4LiteSlaveReadCoverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("AXI4 Slave Agent Coverage = %0.2f %%", axi4LiteSlaveReadCovergroup.get_coverage()), UVM_NONE);
endfunction: report_phase

`endif

