`ifndef AXI4LITEMASTERREADAGENTCONFIG_INCLUDED_
`define AXI4LITEMASTERREADAGENTCONFIG_INCLUDED_

class Axi4LiteMasterReadAgentConfig extends uvm_object;
  `uvm_object_utils(Axi4LiteMasterReadAgentConfig)

  //Used for creating the agent in either passive or active mode
  uvm_active_passive_enum isActive=UVM_ACTIVE;  
  
  //Used for enabling the master agent coverage
  bit hasCoverage;

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

  extern function new(string name = "Axi4LiteMasterReadAgentConfig");
  extern function void do_print(uvm_printer printer);
 // extern function void master_min_addr_range(int slave_number, bit [ADDRESS_WIDTH-1:0]slave_min_address_range);
  //extern function void master_max_addr_range(int slave_number, bit [ADDRESS_WIDTH-1:0]slave_max_address_range);
endclass : Axi4LiteMasterReadAgentConfig

function Axi4LiteMasterReadAgentConfig::new(string name = "Axi4LiteMasterReadAgentConfig");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function : master_max_addr_range_array
// Used to store the maximum address ranges of the slaves in the array
// Parameters :
//  slave_number            - int
//  slave_max_address_range - bit [63:0]
//--------------------------------------------------------------------------------------------
/*function void Axi4LiteMasterReadAgentConfig::master_max_addr_range(int slave_number, bit[ADDRESS_WIDTH-1:0]slave_max_address_range);
  master_max_addr_range_array[slave_number] = slave_max_address_range;
endfunction : master_max_addr_range

//--------------------------------------------------------------------------------------------
// Function : master_min_addr_range_array
// Used to store the minimum address ranges of the slaves in the array
// Parameters :
//  slave_number            - int
//  slave_min_address_range - bit [63:0]
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadAgentConfig::master_min_addr_range(int slave_number, bit[ADDRESS_WIDTH-1:0]slave_min_address_range);
  master_min_addr_range_array[slave_number] = slave_min_address_range;
endfunction : master_min_addr_range
*/
//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//
// Parameters :
// printer  - uvm_printer
//--------------------------------------------------------------------------------------------
function void Axi4LiteMasterReadAgentConfig::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_string ("isActive",isActive.name());
  printer.print_field ("hasCoverage",  hasCoverage, $bits(hasCoverage),  UVM_DEC);
endfunction : do_print

`endif

