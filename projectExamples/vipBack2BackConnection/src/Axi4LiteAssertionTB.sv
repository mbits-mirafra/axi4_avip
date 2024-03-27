`ifndef AXI4LITEASSERTIONTB_INCLUDED_
`define AXI4LITEASSERTIONTB_INCLUDED_

`include "uvm_macros.svh"
import uvm_pkg::*;

module Axi4LiteAssertionTB;
  bit aclk;
  bit aresetn;
  logic valid;
  logic ready;
  
  string name = "AXI4LITE_ASSERTIONS_TB";

  initial begin
    `uvm_info(name,$sformatf("TEST_BENCH_FOR_AXI4LITE_ASSERTIONS"),UVM_LOW);
  end
  always #10 aclk = ~aclk;

  Axi4LiteAssertions axi4LiteAssertions(.aclk(aclk),
                                        .aresetn(aresetn)
                                       );


  initial begin
    #3000;
    $finish;
  end

  initial begin
    When_aresetnIsAssertedValidIsZeroAtSameClk_Expect_AssertionPass();
    When_aresetnIsAssertedBeforePosedgeAclkValidIsZero_Expect_AssertionPass ();
    When_aresetnAssertedAndValidAlwaysUnknown_Expect_AssertionFail();
    When_aresetnAssertedAndAfterSomeDelayValidIsZero_Expect_AssertionFail();
    When_aresetnIsAssertedBeforePosedgeAclkValidIsZeroWithRespectToPosedgeClk_Expect_AssertionFail();
    
    When_validAndReadyAreTrueAtSameClk_Expect_AssertionPass();
    When_validIsAssertedBeforeReadyAsserted_Expect_AssertionPass();
    When_readyIsAssertedBeforeValidAsserted_Expect_AssertionPass();
    When_readyIsAlwaysHighAndValidAssertedAnytime_Expect_AssertionPass();
    When_validIsAssertedTillReadyNotBeAssertedAndResetIsAsserted_Expect_AssertionFail();
    When_validAndReadyNotTrueAtSameClk_Expect_AssertionFail();
    When_validIsAssertedAndAfterSomeClkValidDeassertedThenReadyAsserted_Expect_AssertionFail();

    When_validAndReadyAreTrueWithinThe16Clk_Expect_AssertionPass();
    When_validIsAssertedAndReadyIsAssertedWithinThe16Clk_Expect_AssertionPass();
    When_validIsAssertedAndReadyIsAssertedAfter16Clk_Expect_AssertionFail();
  
  end

  //AXI4LITE_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.isUnknown(valid,0));
  //AXI4LITE_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(valid));

  AXI4LITE_SIGNALS_CHECK_IFUNKNOWN: assert property (axi4LiteAssertions.ifSignalsAreUnknown(valid));
  AXI4LITE_SIGNALS_CHECK_VALIDHIGH_UNITILL_READYASSERTED: assert property (axi4LiteAssertions.validAssertedThenRemainsHighUntillReadyAsserted(valid,ready));
  AXI4LITE_SIGNALS_CHECK_VALIDASSERTED_READYNEEDSTOBEASSERTED_WITHIN16CLK: assert property (axi4LiteAssertions.validAssertedThenReadyNeedsToBeAssertedWithin16Clk(valid,ready));

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
    {signal: [
       ['ax4Lite Signals',
        {name: 'aresetn', wave: '1...0..'},
        {name: 'valid', wave: 'x...0..'},
       ],
      ],
      head:{
      text:
      ['tspan',
      ['tspan', {class:'h5'}, 'Scenario:1.1'],
      ],
      tick:0,
     },
      foot:{ text:
     ['tspan',
      ['tspan', {class:'success h3'}, '           ↑     '],
      ],
     }
    }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
  task When_aresetnIsAssertedValidIsZeroAtSameClk_Expect_AssertionPass();
    `uvm_info(name,$sformatf("When_aresetnIsAssertedValidIsZeroAtSameClk_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      repeat(4) begin
        @(posedge aclk);
      end
      aresetn <= 1'b0;
      valid <= 1'b0;
    `uvm_info(name,$sformatf("When_aresetnIsAssertedValidIsZeroAtSameClk_Expect_AssertionPass Task Ended"),UVM_NONE);
  endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
    {signal: [
       ['ax4Lite Signals',
        {name: 'aclk', wave: 'P.........'},
        {name: 'aresetn', wave: '1.....0.................',     period:.4},
        {name: 'valid', wave: 'x.....0.................',     period:.4},
       ],
      ],
      head:{
      text:
      ['tspan',
      ['tspan', {class:'h5'}, 'Scenario:1.2'],
      ],
      tick:0,
     },
      foot:{ text:
     ['tspan',
      ['tspan', {class:'success h3'}, '↑                          '],
      ],
     }
    } 
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
  task When_aresetnIsAssertedBeforePosedgeAclkValidIsZero_Expect_AssertionPass ();
    `uvm_info(name,$sformatf("When_aresetnIsAssertedBeforePosedgeAclkValidIsZero_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      repeat(2) begin
        @(posedge aclk);
      end
      #15;
      aresetn <= 1'b0;
      valid <= 1'b0;
   `uvm_info(name,$sformatf("When_aresetnIsAssertedBeforePosedgeAclkValidIsZero_Expect_AssertionPass Task ended"),UVM_NONE);
  endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
        {name: 'aresetn', wave: '1..0....'},
        {name: 'valid', wave: 'x.......'},
       ],
      ],
      head:{
      text:
      ['tspan',
      ['tspan', {class:'h5'}, 'Scenario:1.3'],
      ],
      tick:0,
     },
      foot:{ text:
     ['tspan',
      ['tspan', {class:'error h3'}, '↓           '],
      ],
     }
    }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
  task When_aresetnAssertedAndValidAlwaysUnknown_Expect_AssertionFail();
    `uvm_info(name,$sformatf("When_aresetnAssertedAndValidAlwaysUnknown_Expect_AssertionFail Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      repeat(3) begin
        @(posedge aclk);
      end
      aresetn <= 1'b0;
    `uvm_info(name,$sformatf("When_aresetnAssertedAndValidAlwaysUnknown_Expect_AssertionFail Task ended"),UVM_NONE);
  endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
        ['ax4Lite Signals',
         {name: 'aresetn', wave: '1..0.....'},
         {name: 'valid', wave: 'x...0....'},
        ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:1.4'],
       ],
       tick:0,
      },
       foot:{ text:
      ['tspan',
       ['tspan', {class:'error h3'}, '↓                 '],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
  task When_aresetnAssertedAndAfterSomeDelayValidIsZero_Expect_AssertionFail();
    `uvm_info(name,$sformatf("When_aresetnAssertedAndAfterSomeDelayValidIsZero_Expect_AssertionFail Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      repeat(3) begin
        @(posedge aclk);
      end
      aresetn <= 1'b0;
      @(posedge aclk);
      valid <= 1'b0;
    `uvm_info(name,$sformatf("When_aresetnAssertedAndAfterSomeDelayValidIsZero_Expect_AssertionFail Task ended"),UVM_NONE);
  endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
        ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave: '1.....0.................',     period:.4},
         {name: 'valid', wave: 'x..0......'},
        ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:1.5'],
       ],
       tick:0,
      },
       foot:{ text:
      ['tspan',
       ['tspan', {class:'error h3'}, '↓                          '],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_aresetnIsAssertedBeforePosedgeAclkValidIsZeroWithRespectToPosedgeClk_Expect_AssertionFail();
    `uvm_info(name,$sformatf("When_aresetnIsAssertedBeforePosedgeAclkValidIsZeroWithRespectToPosedgeClk_Expect_AssertionFail Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      repeat(2) begin
        @(posedge aclk);
      end
      #15;
      aresetn <= 1'b0;
      @(posedge aclk);
      valid <= 1'b0;
    `uvm_info(name,$sformatf("When_aresetnIsAssertedBeforePosedgeAclkValidIsZeroWithRespectToPosedgeClk_Expect_AssertionFail Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave:'101.......'},
         {name: 'valid', wave: 'x0..10....'},
         {name: 'ready', wave: 'x0..10....'},
       ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:2.1'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'success h3'}, '↑          '],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validAndReadyAreTrueAtSameClk_Expect_AssertionPass();
    `uvm_info(name,$sformatf("When_validAndReadyAreTrueAtSameClk_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      repeat(2) begin
        @(posedge aclk);
      end
      valid <= 1'b1;
      ready <= 1'b1;
      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
    `uvm_info(name,$sformatf("When_validAndReadyAreTrueAtSameClk_Expect_AssertionPass Task ended"),UVM_NONE);
 endtask
 
  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave:'101.......'},
         {name: 'valid', wave: 'x0.1..0...'},
         {name: 'ready', wave: 'x0...10...'},
       ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:2.2'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'success h3'}, '↑'],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validIsAssertedBeforeReadyAsserted_Expect_AssertionPass();
    `uvm_info(name,$sformatf("When_validIsAssertedBeforeReadyAsserted_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      @(posedge aclk);
      valid <= 1'b1;
      repeat(2) begin
        @(posedge aclk);
      end
      ready <= 1'b1;
      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
    `uvm_info(name,$sformatf("When_validIsAssertedBeforeReadyAsserted_Expect_AssertionPass Task ended"),UVM_NONE);
 endtask
 
  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave:'101.......'},
         {name: 'valid', wave: 'x0...10...'},
         {name: 'ready', wave: 'x0.1..0...'},
       ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:2.3'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'success h3'}, '↑'],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_readyIsAssertedBeforeValidAsserted_Expect_AssertionPass();
    `uvm_info(name,$sformatf("When_readyIsAssertedBeforeValidAsserted_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      @(posedge aclk);
      ready <= 1'b1;
      repeat(2) begin
        @(posedge aclk);
      end
      valid <= 1'b1;
      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
    `uvm_info(name,$sformatf("When_readyIsAssertedBeforeValidAsserted_Expect_AssertionPass Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave:'101.......'},
         {name: 'valid', wave: 'x0....10..'},
         {name: 'ready', wave: 'x01.......'},
       ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:2.4'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'success h3'}, '           ↑'],
       ],
      }
     } 
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_readyIsAlwaysHighAndValidAssertedAnytime_Expect_AssertionPass();
    `uvm_info(name,$sformatf("When_readyIsAlwaysHighAndValidAssertedAnytime_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;
      ready <= 1'b1;

      repeat(4) begin
        @(posedge aclk);
      end
      valid <= 1'b1;
      @(posedge aclk);
      valid <= 1'b0;
    `uvm_info(name,$sformatf("When_readyIsAlwaysHighAndValidAssertedAnytime_Expect_AssertionPass Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave:'101...0...'},
         {name: 'valid', wave: 'x0.1..0...'},
         {name: 'ready', wave: 'x0........'},
       ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:2.5'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'error h3'}, '           ↓'],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validIsAssertedTillReadyNotBeAssertedAndResetIsAsserted_Expect_AssertionFail();
    `uvm_info(name,$sformatf("When_validIsAssertedTillReadyNotBeAssertedAndResetIsAsserted_Expect_AssertionFail Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      @(posedge aclk);
      valid <= 1'b1;
      repeat(3) begin
        @(posedge aclk);
      end
      aresetn <= 1'b0;
      valid <= 1'b0;
    `uvm_info(name,$sformatf("When_validIsAssertedTillReadyNotBeAssertedAndResetIsAsserted_Expect_AssertionFail Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave:'101.......'},
         {name: 'valid', wave: 'x0....1.0.'},
         {name: 'ready', wave: 'x0.1.0....'},
       ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:2.6'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'error h3'}, '                                ↓'],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validAndReadyNotTrueAtSameClk_Expect_AssertionFail();
    `uvm_info(name,$sformatf("When_validAndReadyNotTrueAtSameClk_Expect_AssertionFail Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      @(posedge aclk);
      ready <= 1'b1;
      repeat(2) begin
        @(posedge aclk);
      end
      ready <= 1'b0;
      @(posedge aclk);
      valid <= 1'b1;
      repeat(2) begin
        @(posedge aclk);
      end
      valid <= 1'b0;
    `uvm_info(name,$sformatf("When_validAndReadyNotTrueAtSameClk_Expect_AssertionFail Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.........'},
         {name: 'aresetn', wave:'101.......'},
         {name: 'valid', wave: 'x0.1..0...'},
         {name: 'ready', wave: 'x0.....1..'},
       ],
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:2.7'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'error h3'}, '           ↓'],
       ],
      }
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validIsAssertedAndAfterSomeClkValidDeassertedThenReadyAsserted_Expect_AssertionFail();
    `uvm_info(name,$sformatf("When_validIsAssertedAndAfterSomeClkValidDeassertedThenReadyAsserted_Expect_AssertionFail Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      @(posedge aclk);
      valid <= 1'b1;
      repeat(3) begin
        @(posedge aclk);
      end
      valid <= 1'b0;
      @(posedge aclk);
      ready <= 1'b1;
    `uvm_info(name,$sformatf("When_validIsAssertedAndAfterSomeClkValidDeassertedThenReadyAsserted_Expect_AssertionFail Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P...................'},
         {name: 'aresetn', wave:'101.................'},
         {name: 'valid', wave: 'x0.....1.0..........'},
         {name: 'ready', wave: 'x0......10..........'},
       ],
         {               node: '..G...............M', phase:0.2},
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:3.1'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'success h3'}, '↑                     '],
       ],
      },
      edge: [
        'G<->M 16 clk',
      ]
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validAndReadyAreTrueWithinThe16Clk_Expect_AssertionPass();
    `uvm_info(name,$sformatf("When_validAndReadyAreTrueWithinThe16Clk_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      repeat(5) begin
        @(posedge aclk);
      end
      valid <= 1'b1;
      @(posedge aclk);
      ready <= 1'b1;
      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
    `uvm_info(name,$sformatf("When_validAndReadyAreTrueWithinThe16Clk_Expect_AssertionPass Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
      {signal: [
        ['ax4Lite Signals',
          {name: 'aclk', wave: 'P...................'},
          {name: 'aresetn', wave:'101.................'},
          {name: 'valid', wave: 'x0...1......0.......'},
          {name: 'ready', wave: 'x0.........10.......'},
        ],
          {               node: '..G...............M', phase:0.2},
        ],
        head:{
        text:
        ['tspan',
        ['tspan', {class:'h5'}, 'Scenario:3.2'],
        ],
        tick:0,
       },
        foot:{ text:
        ['tspan',
         ['tspan', {class:'success h3'}, '           ↑'],
        ],
       },
       edge: [
         'G<->M 16 clk',
       ]
      }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validIsAssertedAndReadyIsAssertedWithinThe16Clk_Expect_AssertionPass();
    `uvm_info(name,$sformatf("When_validIsAssertedAndReadyIsAssertedWithinThe16Clk_Expect_AssertionPass Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      repeat(3) begin
        @(posedge aclk);
      end
      valid <= 1'b1;
      repeat(6) begin
       @(posedge aclk);
      end
      ready <= 1'b1;
      @(posedge aclk);
      valid <= 1'b0;
      ready <= 1'b0;
    `uvm_info(name,$sformatf("When_validIsAssertedAndReadyIsAssertedWithinThe16Clk_Expect_AssertionPass Task ended"),UVM_NONE);
 endtask

  //----------------------------------------------------------------------------
  //**** WAVEDROM_SCENARIO_CODE_START ****
  /*
     {signal: [
       ['ax4Lite Signals',
         {name: 'aclk', wave: 'P.....................'},
         {name: 'aresetn', wave:'101...................'},
         {name: 'valid', wave: 'x0..1.................'},
         {name: 'ready', wave: 'x0...................1'},
       ],
         {               node: '....G...............M', phase:0.2},
       ],
       head:{
       text:
       ['tspan',
       ['tspan', {class:'h5'}, 'Scenario:3.3'],
       ],
       tick:0,
      },
       foot:{ text:
       ['tspan',
        ['tspan', {class:'error h3'}, '                                                                                                 ↓'],
       ],
      },
      edge: [
        'G<->M 16 clk',
      ]
     }
  */
  //**** WAVEDROM_SCENARIO_CODE_END ****
  //----------------------------------------------------------------------------

  //Test for the above wavedrom scenario
 task When_validIsAssertedAndReadyIsAssertedAfter16Clk_Expect_AssertionFail();
    `uvm_info(name,$sformatf("When_validIsAssertedAndReadyIsAssertedAfter16Clk_Expect_AssertionFail Task started"),UVM_NONE);
      aresetn <= 1'b1;
      valid <= 1'bx;
      ready <= 1'bx;
      @(posedge aclk);
      aresetn <= 1'b0;
      valid <= 1'b0;
      ready <= 1'b0;
      @(posedge aclk);
      aresetn <= 1'b1;

      repeat(2) begin
        @(posedge aclk);
      end
      valid <= 1'b1;
      repeat(17) begin
       @(posedge aclk);
      end
      ready <= 1'b1;
    `uvm_info(name,$sformatf("When_validIsAssertedAndReadyIsAssertedAfter16Clk_Expect_AssertionFail Task ended"),UVM_NONE);
 endtask

endmodule : Axi4LiteAssertionTB

`endif

