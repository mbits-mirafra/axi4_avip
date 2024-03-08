`ifndef AXI4LITEVIRTUALBASESEQ_INCLUDED_
`define AXI4LITEVIRTUALBASESEQ_INCLUDED_

class Axi4LiteVirtualBaseSeq extends uvm_sequence;
  `uvm_object_utils(Axi4LiteVirtualBaseSeq)

  `uvm_declare_p_sequencer(Axi4LiteMasterVirtualSequencer);
//  `uvm_declare_p_sequencer(Axi4LiteSlaveVirtualSequencer);

  Axi4LiteMasterEnvConfig axi4LiteMasterEnvConfig;
  Axi4LiteSlaveEnvConfig axi4LiteSlaveEnvConfig;

  extern function new(string name="Axi4LiteVirtualBaseSeq");
  extern task body();

endclass:Axi4LiteVirtualBaseSeq

function Axi4LiteVirtualBaseSeq::new(string name="Axi4LiteVirtualBaseSeq");
  super.new(name);
endfunction:new


task Axi4LiteVirtualBaseSeq::body();

   if(!uvm_config_db#(Axi4LiteMasterEnvConfig) ::get(null,get_full_name(),"Axi4LiteMasterEnvConfig",axi4LiteMasterEnvConfig)) begin
    `uvm_fatal("MasterENVCONFIG","cannot get() env_cfg from uvm_config_db.Have you set() it?")
  end
   if(!uvm_config_db#(Axi4LiteSlaveEnvConfig) ::get(null,get_full_name(),"Axi4LiteSlaveEnvConfig",axi4LiteSlaveEnvConfig)) begin
    `uvm_fatal("SlaveENVCONFIG","cannot get() env_cfg from uvm_config_db.Have you set() it?")
  end


  if(!$cast(p_sequencer,m_sequencer))begin
    `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
  end
  
endtask:body

`endif
