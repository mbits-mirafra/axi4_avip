`ifndef AXI4LITEVIRTUALBASESEQ_INCLUDED_
`define AXI4LITEVIRTUALBASESEQ_INCLUDED_

class Axi4LiteVirtualBaseSeq extends uvm_sequence;
  `uvm_object_utils(Axi4LiteVirtualBaseSeq)

  `uvm_declare_p_sequencer(Axi4LiteVirtualSequencer);

  Axi4LiteEnvConfig axi4LiteEnvConfig;

  extern function new(string name = "Axi4LiteVirtualBaseSeq");
  extern task pre_body();
  extern task body();
  extern task post_body();

endclass : Axi4LiteVirtualBaseSeq

function Axi4LiteVirtualBaseSeq::new(string name = "Axi4LiteVirtualBaseSeq");
  super.new(name);
endfunction : new

task Axi4LiteVirtualBaseSeq::pre_body();

endtask : pre_body

task Axi4LiteVirtualBaseSeq::body();

  if (!uvm_config_db#(Axi4LiteEnvConfig)::get(
          null, get_full_name(), "Axi4LiteEnvConfig", axi4LiteEnvConfig
      )) begin
    `uvm_fatal("ENVCONFIG", "cannot get() ENV_cfg from uvm_config_db.Have you set() it?")
  end
  if (!$cast(p_sequencer, m_sequencer)) begin
    `uvm_error(get_full_name(), "Virtual sequencer pointer cast failed")
  end

endtask : body

task Axi4LiteVirtualBaseSeq::post_body();


endtask : post_body

`endif
