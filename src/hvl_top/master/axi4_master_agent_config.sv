`ifndef AXI4_MASTER_AGENT_CONFIG_INCLUDED_
`define AXI4_MASTER_AGENT_CONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: axi4_master_agent_config
// Used as the configuration class for axi4_master agent, for configuring number of slaves and number
// of active passive agents to be created
//--------------------------------------------------------------------------------------------
class axi4_master_agent_config extends uvm_object;
  `uvm_object_utils(axi4_master_agent_config)

  //Variable: is_active
  //Used for creating the agent in either passive or active mode
  uvm_active_passive_enum is_active=UVM_ACTIVE;  
  
  //Variable: has_coverage
  //Used for enabling the master agent coverage
  bit has_coverage;

  //Variable : master_memory
  //Used to store all the data from the slaves
  //Each location of the master memory stores 32 bit data
  bit [MEMORY_WIDTH-1:0]master_memory[(SLAVE_MEMORY_SIZE+SLAVE_MEMORY_GAP)*NO_OF_SLAVES:0];

  //Variable : master_min_array
  //An associative array used to store the min address ranges of every slave
  //Index - type    - int
  //        stores  - slave number
  //Value - stores the minimum address range of that slave.
  bit [ADDRESS_WIDTH-1:0]master_min_addr_range_array[int];

  //Variable : master_max_array
  //An associative array used to store the max address ranges of every slave
  //Index - type    - int
  //        stores  - slave number
  //Value - stores the maximum address range of that slave.
  bit [ADDRESS_WIDTH-1:0]master_max_addr_range_array[int];
  
  //Variable : wait_count_write_address_channel;
  //Used to determine the number of wait states inserted for write address channel
  int wait_count_write_address_channel;
  
  //Variable : wait_count_write_data_channel;
  //Used to determine the number of wait states inserted for write data channel
  int wait_count_write_data_channel;
  
  //Variable : wait_count_read_address_channel;
  //Used to determine the number of wait states inserted for read address channel
  int wait_count_read_address_channel;

  //Variable : outstanding_write_tx
  //Used to send the outstanding transactions
  rand int outstanding_write_tx;
  
  //Variable : outstanding_read_tx
  //Used to send the outstanding transactions
  rand int outstanding_read_tx;

  //Used to store the read data type
  read_data_type_mode_e read_data_mode;


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_master_agent_config");
  extern function void do_print(uvm_printer printer);
  extern function void master_min_addr_range(int slave_number, bit [ADDRESS_WIDTH-1:0]slave_min_address_range);
  extern function void master_max_addr_range(int slave_number, bit [ADDRESS_WIDTH-1:0]slave_max_address_range);
endclass : axi4_master_agent_config

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - axi4_master_agent_config
//--------------------------------------------------------------------------------------------
function axi4_master_agent_config::new(string name = "axi4_master_agent_config");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function : master_max_addr_range_array
// Used to store the maximum address ranges of the slaves in the array
// Parameters :
//  slave_number            - int
//  slave_max_address_range - bit [63:0]
//--------------------------------------------------------------------------------------------
function void axi4_master_agent_config::master_max_addr_range(int slave_number, bit[ADDRESS_WIDTH-1:0]slave_max_address_range);
  master_max_addr_range_array[slave_number] = slave_max_address_range;
endfunction : master_max_addr_range

//--------------------------------------------------------------------------------------------
// Function : master_min_addr_range_array
// Used to store the minimum address ranges of the slaves in the array
// Parameters :
//  slave_number            - int
//  slave_min_address_range - bit [63:0]
//--------------------------------------------------------------------------------------------
function void axi4_master_agent_config::master_min_addr_range(int slave_number, bit[ADDRESS_WIDTH-1:0]slave_min_address_range);
  master_min_addr_range_array[slave_number] = slave_min_address_range;
endfunction : master_min_addr_range

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//
// Parameters :
// printer  - uvm_printer
//--------------------------------------------------------------------------------------------
function void axi4_master_agent_config::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_string ("is_active",is_active.name());
  printer.print_field ("has_coverage",  has_coverage, $bits(has_coverage),  UVM_DEC);
  
  //Memory Mapping Minimum and Maximum Address Range 
  foreach(master_max_addr_range_array[i]) begin
    printer.print_field($sformatf("master_min_addr_range_array[%0d]",i),master_min_addr_range_array[i],
                                   $bits(master_min_addr_range_array[i]),UVM_HEX);
    printer.print_field($sformatf("master_max_addr_range_array[%0d]",i),master_max_addr_range_array[i],
                                   $bits(master_max_addr_range_array[i]),UVM_HEX);
  end

  printer.print_field("wait_count_write_address_channel",wait_count_write_address_channel,
                       $bits(wait_count_write_address_channel),UVM_DEC);
  printer.print_field("wait_count_write_data_channel",wait_count_write_data_channel,
                       $bits(wait_count_write_data_channel),UVM_DEC);
  printer.print_field("wait_count_read_address_channel",wait_count_read_address_channel,
                       $bits(wait_count_read_address_channel),UVM_DEC);
  printer.print_field("outstanding_write_tx",outstanding_write_tx,$bits(outstanding_write_tx),UVM_DEC);
  printer.print_field("outstanding_read_tx",outstanding_read_tx,$bits(outstanding_read_tx),UVM_DEC);
  
endfunction : do_print

`endif

