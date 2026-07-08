// compile filelist : builds standalone master, standalone slave and back to back packages
// production runs the back to back master to slave VIP verification
+incdir+../../src/globals/
+incdir+../../src/hvl_top/test/sequences/master_sequences/
+incdir+../../src/hvl_top/test/sequences/slave_sequenes/
+incdir+../../src/hvl_top/master/
+incdir+../../src/hdl_top/master_agent_bfm/
+incdir+../../src/hvl_top/env/virtual_sequencer/
+incdir+../../src/hvl_top/test/virtual_sequences/
+incdir+../../src/hvl_top/test/virtual_sequences/standalone_master/
+incdir+../../src/hvl_top/test/virtual_sequences/standalone_slave/
+incdir+../../src/hvl_top/test/virtual_sequences/back_to_back/
+incdir+../../src/hvl_top/env
+incdir+../../src/hvl_top/slave
+incdir+../../src/hvl_top/test
+incdir+../../src/hvl_top/test/standalone_master/
+incdir+../../src/hvl_top/test/standalone_slave/
+incdir+../../src/hvl_top/test/back_to_back/
+incdir+../../src/hdl_top/slave_agent_bfm
+incdir+../../src/hdl_top/axi4_interface
../../src/globals/axi4_globals_pkg.sv
../../src/hvl_top/master/axi4_master_pkg.sv
../../src/hvl_top/slave/axi4_slave_pkg.sv
../../src/hvl_top/test/sequences/master_sequences/axi4_master_seq_pkg.sv
../../src/hvl_top/test/sequences/slave_sequenes/axi4_slave_seq_pkg.sv
../../src/hvl_top/env/axi4_env_pkg.sv
../../src/hvl_top/test/virtual_sequences/axi4_vseq_base_pkg.sv
// Mode-selected test-package families (toggled in place by 'make compile MODE=...').
// Exactly one family is active at a time; do not remove the //@MODE= tags.
//../../src/hvl_top/test/virtual_sequences/standalone_master/axi4_standalone_master_vseq_pkg.sv //@MODE=master
//../../src/hvl_top/test/virtual_sequences/standalone_slave/axi4_standalone_slave_vseq_pkg.sv //@MODE=slave
../../src/hvl_top/test/virtual_sequences/back_to_back/axi4_back_to_back_vseq_pkg.sv //@MODE=b2b
../../src/hvl_top/test/axi4_test_base_pkg.sv
//../../src/hvl_top/test/standalone_master/axi4_standalone_master_test_pkg.sv //@MODE=master
//../../src/hvl_top/test/standalone_slave/axi4_standalone_slave_test_pkg.sv //@MODE=slave
../../src/hvl_top/test/back_to_back/axi4_back_to_back_test_pkg.sv //@MODE=b2b
../../src/hdl_top/axi4_interface/axi4_if.sv
../../src/hdl_top/master_agent_bfm/axi4_master_driver_bfm.sv
../../src/hdl_top/master_agent_bfm/axi4_master_monitor_bfm.sv
../../src/hdl_top/master_agent_bfm/axi4_master_agent_bfm.sv
../../src/hdl_top/slave_agent_bfm/axi4_slave_driver_bfm.sv
../../src/hdl_top/slave_agent_bfm/axi4_slave_monitor_bfm.sv
../../src/hdl_top/slave_agent_bfm/axi4_slave_agent_bfm.sv
../../src/hdl_top/hdl_top.sv
../../src/hvl_top/hvl_top.sv
../../src/hdl_top/master_assertions.sv
../../src/hdl_top/slave_assertions.sv
