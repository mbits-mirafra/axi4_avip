`ifndef HVLTOP_INCLUDED_
`define HVLTOP_INCLUDED_

module HvlTop;

  import Axi4LiteTestPkg::*;
  import uvm_pkg::*;

  initial begin : START_TEST 
    
    run_test("Axi4LiteBaseTest");

  end

endmodule : HvlTop

`endif
