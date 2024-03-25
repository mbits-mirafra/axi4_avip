`ifndef AXI4LITEMASTERREADCOVERAGE_INCLUDED_
`define AXI4LITEMASTERREADCOVERAGE_INCLUDED_

class Axi4LiteMasterReadCoverage extends uvm_subscriber #(Axi4LiteMasterReadTransaction);
  `uvm_component_utils(Axi4LiteMasterReadCoverage)

  covergroup axi4LiteMasterReadCovergroup with function sample (Axi4LiteMasterReadTransaction packet);
    option.per_instance = 1;
  endgroup : axi4LiteMasterReadCovergroup


  extern function new(string name = "Axi4LiteMasterReadCoverage", uvm_component parent = null);
  extern virtual function void write(Axi4LiteMasterReadTransaction t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : Axi4LiteMasterReadCoverage

function Axi4LiteMasterReadCoverage::new(string name = "Axi4LiteMasterReadCoverage",
                                         uvm_component parent = null);
  super.new(name, parent);
  axi4LiteMasterReadCovergroup = new();
endfunction : new

function void Axi4LiteMasterReadCoverage::write(Axi4LiteMasterReadTransaction t);
  `uvm_info(get_type_name(), $sformatf("Before calling SAMPLE METHOD"), UVM_HIGH);

  axi4LiteMasterReadCovergroup.sample(t);

  `uvm_info(get_type_name(), "After calling SAMPLE METHOD", UVM_HIGH);
endfunction : write

function void Axi4LiteMasterReadCoverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf(
            "AXI4 Master Read Agent Coverage = %0.2f %%", axi4LiteMasterReadCovergroup.get_coverage()),
            UVM_NONE);
endfunction : report_phase

`endif

