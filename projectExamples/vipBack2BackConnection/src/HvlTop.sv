module HvlTop;

  import Axi4LiteTestPkg::*;
  import uvm_pkg::*;

  initial begin : START_TEST 
    
    // The test to start is given at the command line
    // The command-line UVM_TESTNAME takes the precedance
    run_test("Axi4LiteBaseTest");

  end

endmodule : HvlTop
