`ifndef AXI4_SLAVE_AGENT_CONFIG_INCLUDED_
`define AXI4_SLAVE_AGENT_CONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_slave_agent_config
// Used as the configuration class for axi4_slave agent and it's components
//--------------------------------------------------------------------------------------------
class axi4_slave_agent_config extends uvm_object;
  `uvm_object_utils(axi4_slave_agent_config)

  //Variable: is_active
  //Used for creating the agent in either passive or active mode
  uvm_active_passive_enum is_active = UVM_ACTIVE;  
  
  //Variable: has_coverage
  //Used for enabling the master agent coverage
  bit has_coverage;

  //Variable: slave_id
  //Gives the slave id
  int slave_id;
  
  //Variable : max_address
  //Used to store the maximum address value of this slave
  bit [ADDRESS_WIDTH-1:0] max_address;

  //Variable : min_address
  //Used to store the minimum address value of this slave
  bit [ADDRESS_WIDTH-1:0] min_address;
  
  //Variable : wait_count_write_response_channel;
  //Used to determine the number of wait states inserted for write response channel
  int wait_count_write_response_channel;
  
  //Variable : wait_count_read_data_channel;
  //Used to determine the number of wait states inserted for read data channel
  int wait_count_read_data_channel;

  //Variable: slave_response_mode
  //Used to enable the out_of_order for writres and reads
  response_mode_e slave_response_mode;

  //Variable: minimum_transactions
  //Used to set the minimum txns for out_of_order
  protected bit[1:0] minimum_transactions = 2;

  //Variable: maximum_transactions
  //Used to set the maximumm txns for out_of_order
  bit[3:0] maximum_transactions;

  //Variable: read_data_mode
  //Used to set type of data to read
  read_data_type_mode_e read_data_mode;

  //Variable: user_rdata
  //Used to set default read data
  bit[DATA_WIDTH-1:0] user_rdata;

  //constraint: maximum_txns
  //Make sure to have minimum txns to perform out_of_order
  constraint maximum_txns_c{maximum_transactions >= minimum_transactions;}


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_slave_agent_config");
  extern function void do_print(uvm_printer printer);
  extern function int get_minimum_transactions();
endclass : axi4_slave_agent_config

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_slave_agent_config
//--------------------------------------------------------------------------------------------
function axi4_slave_agent_config::new(string name = "axi4_slave_agent_config");
  super.new(name); 
endfunction : new

function int axi4_slave_agent_config::get_minimum_transactions();
  return (this.minimum_transactions);
endfunction

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//
// Parameters:
//  printer - uvm_printer
//--------------------------------------------------------------------------------------------
function void axi4_slave_agent_config::do_print(uvm_printer printer);
  super.do_print(printer);

  printer.print_string ("is_active",   is_active.name());
  printer.print_field ("slave_id",     slave_id,     $bits(slave_id),     UVM_DEC);
  printer.print_field ("has_coverage", has_coverage, $bits(has_coverage), UVM_DEC);
  printer.print_field ("min_address",  min_address,  $bits(max_address),  UVM_HEX);
  printer.print_field ("max_address",  max_address,  $bits(max_address),  UVM_HEX);
  printer.print_string ("slave_response_type",   slave_response_mode.name());
  printer.print_field ("minimum_transactions",  minimum_transactions,  $bits(minimum_transactions),  UVM_HEX);
  printer.print_field ("maximum_transactions",  maximum_transactions,  $bits(maximum_transactions),  UVM_HEX);
  printer.print_string ("read_data_mode", read_data_mode.name());  
  printer.print_field ("wait_count_write_response_channel",wait_count_write_response_channel,$bits(wait_count_write_response_channel),UVM_DEC);
  printer.print_field ("wait_count_read_data_channel",wait_count_read_data_channel,$bits(wait_count_read_data_channel),UVM_DEC);
         
endfunction : do_print

`endif

