`ifndef AXI4LITESLAVERANDOMREADYDELAYTEST_INCLUDED_
`define AXI4LITESLAVERANDOMREADYDELAYTEST_INCLUDED_
 
class Axi4LiteSlaveRandomReadyDelayTest extends Axi4LiteBaseTest;
  `uvm_component_utils(Axi4LiteSlaveRandomReadyDelayTest)
 
  Axi4LiteVirtualSlaveRandomReadyDelaySeq axi4LiteVirtualSlaveRandomReadyDelaySeq;
 
  extern function new(string name = "Axi4LiteSlaveRandomReadyDelayTest", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
 
endclass : Axi4LiteSlaveRandomReadyDelayTest
 
function Axi4LiteSlaveRandomReadyDelayTest::new(string name = "Axi4LiteSlaveRandomReadyDelayTest",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new
 
function void Axi4LiteSlaveRandomReadyDelayTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
 
// Axi4LiteVirtualBaseSeq::type_id::set_inst_override(Axi4LiteVirtualSlaveRandomReadyDelaySeq::get_type(),"get_full_name().axi4LiteVirtualBaseSeq");
// set_inst_override_by_type("axi4LiteVirtualBaseSeq", Axi4LiteVirtualBaseSeq::get_type(), Axi4LiteVirtualSlaveRandomReadyDelaySeq::get_type());
endfunction : build_phase
 
task Axi4LiteSlaveRandomReadyDelayTest::run_phase(uvm_phase phase);
 
  axi4LiteVirtualSlaveRandomReadyDelaySeq = Axi4LiteVirtualSlaveRandomReadyDelaySeq::type_id::create("axi4LiteVirtualSlaveRandomReadyDelaySeq");
 
  `uvm_info(get_type_name(),$sformatf("Inside run_phase Axi4LiteSlaveRandomReadyDelayTest"),UVM_LOW);
 
  phase.raise_objection(this);
    axi4LiteVirtualSlaveRandomReadyDelaySeq.start(axi4LiteEnv.axi4LiteVirtualSequencer);
    #20;
  phase.drop_objection(this);
 
endtask : run_phase
 
`endif
