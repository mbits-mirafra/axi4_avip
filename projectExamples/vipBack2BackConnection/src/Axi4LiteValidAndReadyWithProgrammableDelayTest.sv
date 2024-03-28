`ifndef AXI4LITEVALIDANDREADYWITHPROGRAMMABLEDELAYTEST_INCLUDED_
`define AXI4LITEVALIDANDREADYWITHPROGRAMMABLEDELAYTEST_INCLUDED_
 
class Axi4LiteValidAndReadyWithProgrammableDelayTest extends Axi4LiteBaseTest;
  `uvm_component_utils(Axi4LiteValidAndReadyWithProgrammableDelayTest)
 
  Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq;
 
  extern function new(string name = "Axi4LiteValidAndReadyWithProgrammableDelayTest", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
 
endclass : Axi4LiteValidAndReadyWithProgrammableDelayTest
 
function Axi4LiteValidAndReadyWithProgrammableDelayTest::new(string name = "Axi4LiteValidAndReadyWithProgrammableDelayTest",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new
 
function void Axi4LiteValidAndReadyWithProgrammableDelayTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
 
// Axi4LiteVirtualBaseSeq::type_id::set_inst_override(Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq::get_type(),"get_full_name().axi4LiteVirtualBaseSeq");
// set_inst_override_by_type("axi4LiteVirtualBaseSeq", Axi4LiteVirtualBaseSeq::get_type(), Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq::get_type());
endfunction : build_phase
 
task Axi4LiteValidAndReadyWithProgrammableDelayTest::run_phase(uvm_phase phase);
 
  axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq = Axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq::type_id::create("axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq");
 
  `uvm_info(get_type_name(),$sformatf("Inside run_phase Axi4LiteValidAndReadyWithProgrammableDelayTest"),UVM_LOW);
 
  phase.raise_objection(this);
    axi4LiteVirtualValidAndReadyWithProgrammableDelaySeq.start(axi4LiteEnv.axi4LiteVirtualSequencer);
    #20;
  phase.drop_objection(this);
 
endtask : run_phase
 
`endif
