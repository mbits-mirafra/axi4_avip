`ifndef AXI4_MASTER_BASE_SEQ_INCLUDED_
  `define AXI4_MASTER_BASE_SEQ_INCLUDED_

  //--------------------------------------------------------------------------------------------
  // Class: axi4_master_base_seq 
  // creating axi4_master_base_seq class extends from uvm_sequence
  //--------------------------------------------------------------------------------------------
  class axi4_master_base_seq extends uvm_sequence #(axi4_master_tx);

    //factory registration
    `uvm_object_utils(axi4_master_base_seq)

    awsize_e writeTranSize;

    transfer_type_e writeTransferType;

    awburst_e writeBurstType;

    tx_type_e writeOrRead;

    arsize_e readTranSize;

    transfer_type_e readTransferType;

    arburst_e readBurstType;

    static int transCount;

    static int totalCount;

    //Runtime write tracker shared across write & read seq instances.
    //A write id lives in inflight_* from issue until its get_response(id)
    //returns (BRESP done); then its base moves to committed_base (safe to read).
    static int inflight_base[int];   //id -> base address, still outstanding
    static int inflight_span[int];   //id -> byte span
    static int committed_base[$];    //bases whose BRESP has returned
    static int addr_guard = 64;      //"close to" band in bytes

    //-------------------------------------------------------
    // Externally defined Function
    //-------------------------------------------------------
    extern function new(string name = "axi4_master_base_seq");
    extern task body();
  endclass : axi4_master_base_seq

  //-----------------------------------------------------------------------------
  // Constructor: new
  // Initializes the axi4_master_sequence class object
  //
  // Parameters:
  //  name - instance name of the config_template
  //-----------------------------------------------------------------------------
  function axi4_master_base_seq::new(string name = "axi4_master_base_seq");
    super.new(name);
  endfunction : new

  //-----------------------------------------------------------------------------
  // Task: body
  // based on the request from driver task will drive the transactions
  task axi4_master_base_seq::body();
    super.body();

    if(writeOrRead == WRITE) begin
      totalCount = totalCount + MASTER_TRANSACTION_WRITE_ISSUE_COUNT;
      repeat(MASTER_TRANSACTION_WRITE_ISSUE_COUNT) begin

        req = axi4_master_tx :: type_id :: create("req");
        start_item(req);
        `uvm_info(get_type_name(), $sformatf("Generating WRITE transaction | size=%s burst=%s type=%s",writeTranSize.name(), writeBurstType.name(), writeTransferType.name()), UVM_LOW)
        if(!req.randomize() with {req.awsize == writeTranSize;
          req.tx_type == writeOrRead;
          req.transfer_type == writeTransferType;
          req.awburst == writeBurstType;}) begin
            `uvm_fatal(get_type_name(), $sformatf("Randomization failed for WRITE axi4_master_tx (size=%s burst=%s type=%s)",writeTranSize.name(), writeBurstType.name(), writeTransferType.name()))
        end
        finish_item(req);
        //mark this write in-flight the moment it is issued
        inflight_base[req.get_transaction_id()] = req.awaddr;
        inflight_span[req.get_transaction_id()] = (req.awlen+1)*(2**req.awsize);
        fork
          begin
            automatic int id = req.get_transaction_id();
            RSP rsp;
            `uvm_info(get_type_name(),$sformatf("Waiting for response of transaction id = %0d",id),UVM_MEDIUM)
            get_response(rsp,id);
            //BRESP received -> this address is committed and safe to read back
            committed_base.push_back(inflight_base[id]);
            inflight_base.delete(id);
            inflight_span.delete(id);
            transCount++;
            `uvm_info(get_type_name(),$sformatf("Response received, response count = %0d",transCount),UVM_MEDIUM)
          end
        join_none;
      end 
    end
    else begin
      totalCount= totalCount + MASTER_TRANSACTION_READ_ISSUE_COUNT;
      repeat(MASTER_TRANSACTION_READ_ISSUE_COUNT) begin
        req = axi4_master_tx :: type_id :: create("req");
        start_item(req);
        `uvm_info(get_type_name(), $sformatf("Generating READ transaction | size=%s burst=%s type=%s",writeTranSize.name(), writeBurstType.name(), writeTransferType.name()), UVM_LOW)

        //snapshot the live write tracker so the read avoids in-flight writes
        //and can only read back already-committed addresses
        req.avoid_base = {};
        req.avoid_span = {};
        foreach(inflight_base[id]) begin
          req.avoid_base.push_back(inflight_base[id]);
          req.avoid_span.push_back(inflight_span[id] + 2*addr_guard);
        end
        req.readback_base = committed_base;

        if(!req.randomize() with {req.arsize == readTranSize;
                                  req.tx_type == writeOrRead;
                                  req.transfer_type == readTransferType;
                                  req.arburst == readBurstType;}) begin
          `uvm_fatal(get_type_name(), $sformatf("Randomization failed for READ axi4_master_tx (size=%s burst=%s type=%s)",
            readTranSize.name(), readBurstType.name(), readTransferType.name()))
        end

        finish_item(req);
        fork
          begin  
            automatic int id = req.get_transaction_id();
            RSP rsp;
            get_response(rsp,id);
            transCount++;
          end 
        join_none;
      end 

    end

    wait(transCount == totalCount);
  endtask : body


`endif
