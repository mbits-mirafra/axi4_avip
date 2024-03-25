`ifndef AXI4LITEMASTERWRITECOVERAGE_INCLUDED_
`define AXI4LITEMASTERWRITECOVERAGE_INCLUDED_

class Axi4LiteMasterWriteCoverage extends uvm_subscriber #(Axi4LiteMasterWriteTransaction);
  `uvm_component_utils(Axi4LiteMasterWriteCoverage)
 
  covergroup axi4LiteMasterWriteCovergroup with function sample (Axi4LiteMasterWriteTransaction packet);
    option.per_instance = 1;
  endgroup: axi4LiteMasterWriteCovergroup

  extern function new(string name = "Axi4LiteMasterWriteCoverage", uvm_component parent = null);
  extern virtual function void write(Axi4LiteMasterWriteTransaction t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : Axi4LiteMasterWriteCoverage

function Axi4LiteMasterWriteCoverage::new(string name = "Axi4LiteMasterWriteCoverage",
                                 uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterWriteCovergroup =new();
endfunction : new

function void Axi4LiteMasterWriteCoverage::write(Axi4LiteMasterWriteTransaction t);
 `uvm_info(get_type_name(),$sformatf("Before calling SAMPLE METHOD"),UVM_HIGH);
  
 axi4LiteMasterWriteCovergroup.sample(t);

  `uvm_info(get_type_name(),"After calling SAMPLE METHOD",UVM_HIGH);
endfunction: write

function void Axi4LiteMasterWriteCoverage::report_phase(uvm_phase phase);
 `uvm_info(get_type_name(),$sformatf("AXI4LITE Master Write Agent Coverage = %0.2f %%", axi4LiteMasterWriteCovergroup.get_coverage()), UVM_NONE);
endfunction: report_phase

`endif

