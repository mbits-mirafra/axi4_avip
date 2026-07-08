`ifndef AXI4_SLAVE_BASE_SEQ_INCLUDED_
 `define AXI4_SLAVE_BASE_SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_base_seq 
// creating axi4_slave_base_seq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class axi4_slave_base_seq extends uvm_sequence #(axi4_slave_tx);

  //factory registration
  `uvm_object_utils(axi4_slave_base_seq)
  

  transfer_type_e writeTransferType;
  
  
  tx_type_e writeOrRead;


  transfer_type_e readTransferType;

  int writeCnt;

  int writeIdQueue[MASTER_TRANSACTION_WRITE_ISSUE_COUNT];

  int numWriteGotResp;

  int readCnt;

  int readIdQueue[MASTER_TRANSACTION_READ_ISSUE_COUNT];

  int numReadGotResp;

  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_base_seq");
  extern task body();
endclass : axi4_slave_base_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the axi4_slave_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function axi4_slave_base_seq::new(string name = "axi4_slave_base_seq");
  super.new(name);
endfunction : new

//-----------------------------------------------------------------------------
// Task: body
// based on the request from driver task will drive the transactions
task axi4_slave_base_seq::body();
  super.body();


  if(writeOrRead == WRITE) begin
    
      repeat(MASTER_TRANSACTION_WRITE_ISSUE_COUNT) begin
      
         req = axi4_slave_tx::type_id::create("req");

         start_item(req);
         if(!req.randomize() with { req.transfer_type == writeTransferType;}) begin
            `uvm_fatal(get_type_name(), $sformatf("Randomization failed for WRITE axi4_slave_tx (type=%s)",writeTransferType.name()))
         end

         finish_item(req);

         writeIdQueue[writeCnt] = req.get_transaction_id();

         fork
           begin 
             RSP rsp;
             int id = writeIdQueue[writeCnt++];
             get_response(rsp,id);
             numWriteGotResp++;
             $display("write num got resp");
           end 
         join_none 
      end

      wait(numWriteGotResp == MASTER_TRANSACTION_WRITE_ISSUE_COUNT);
  end
  else begin
      
      repeat(MASTER_TRANSACTION_READ_ISSUE_COUNT) begin
      
         req = axi4_slave_tx::type_id::create("req");

         start_item(req);
         if(!req.randomize() with { req.transfer_type == readTransferType;}) begin
            `uvm_fatal(get_type_name(), $sformatf("Randomization failed for READ axi4_slave_tx (type=%s)",readTransferType.name()))
         end

         finish_item(req);
         readIdQueue[readCnt] = req.get_transaction_id();

         fork
           begin
             RSP rsp;
             int id = readIdQueue[readCnt++];
             get_response(rsp,id);
             numReadGotResp++;
           end 
         join_none 
      end

      wait(numReadGotResp == MASTER_TRANSACTION_READ_ISSUE_COUNT); 
  end
  `uvm_info(get_type_name(), $sformatf("Randomized transaction:\n%s", req.sprint()), UVM_HIGH)

  `uvm_info(get_type_name(), $sformatf("%s transaction sent to driver", writeOrRead.name()), UVM_MEDIUM)

endtask : body  


`endif
