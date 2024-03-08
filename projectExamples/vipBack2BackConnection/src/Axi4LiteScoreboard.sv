`ifndef AXI4LITESCOREBOARD_INCLUDED_
`define AXI4LITESCOREBOARD_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: Axi4LiteScoreboard
// Scoreboard the data getting from monitor port that goes into the implementation port
//--------------------------------------------------------------------------------------------
class Axi4LiteScoreboard extends uvm_scoreboard;
  `uvm_component_utils(Axi4LiteScoreboard)


  extern function new(string name = "Axi4LiteScoreboard", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void check_phase (uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);

endclass : Axi4LiteScoreboard

function Axi4LiteScoreboard::new(string name = "Axi4LiteScoreboard",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

function void Axi4LiteScoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

function void Axi4LiteScoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

function void Axi4LiteScoreboard::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

function void Axi4LiteScoreboard::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase


task Axi4LiteScoreboard::run_phase(uvm_phase phase);

  super.run_phase(phase);
/*
  fork
    axi4_write_address();
    axi4_write_data();
    axi4_write_response();
    axi4_read_address();
    axi4_read_data();
  join
*/
endtask : run_phase

//--------------------------------------------------------------------------------------------
// Function: check_phase
// Display the result of simulation
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteScoreboard::check_phase(uvm_phase phase);
  super.check_phase(phase);

  `uvm_info(get_type_name(),$sformatf("--\n----------------------------------------------SCOREBOARD CHECK PHASE---------------------------------------"),UVM_HIGH) 
  
  `uvm_info (get_type_name(),$sformatf(" Scoreboard Check Phase is starting"),UVM_HIGH); 
  `uvm_info(get_type_name(),$sformatf("--\n----------------------------------------------END OF SCOREBOARD CHECK PHASE---------------------------------------"),UVM_HIGH)

endfunction : check_phase

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Display the result of simulation
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void Axi4LiteScoreboard::report_phase(uvm_phase phase);
  super.report_phase(phase);
  
  $display(" ");
  $display("-------------------------------------------- ");
  $display("SCOREBOARD REPORT PHASE");
  $display("-------------------------------------------- ");
  $display(" ");
endfunction : report_phase

`endif

