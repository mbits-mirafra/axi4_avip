all:
	make clean; make sim; make clean;

VCS_CMD_RAND    = vcs -V -R  -full64 -sverilog +v2k -debug_access+all -ntb_opts uvm-1.2 -debug_pp +ntb_random_seed_automatic -override_timescale=1ps/1ps
 
sim:
	${VCS_CMD_RAND} \
	+incdir+../../src/hvl_top/master/ \
	+incdir+../../src/hdl_top/master_agent_bfm/  \
	+incdir+../../src/hvl_top/env/virtual_sequencer/ \
  +incdir+../../src/hvl_top/test/virtual_sequence/ \
	+incdir+../../src/hvl_top/env \
	+incdir+../../src/hvl_top/slave \
	+incdir+../../src/hvl_top/test \
	+incdir+../../src/hdl_top/slave_agent_bfm \
	+incdir+../../src/hdl_top/spi_interface \
	../../src/hvl_top/test/test_pkg.sv \
	../../src/hdl_top/spi_interface/spi_if.sv \
	../../src/hdl_top/hdl_top.sv \
	../../src/hvl_top/hvl_top.sv \
	+UVM_VERBOSITY=MEDIUM \
	+plusarg_ignore \
	-l transcript_vcs.log

	#+incdir+/projects/UVM/uvm-1.2/src \
	#/projects/UVM/uvm-1.2/src/uvm_pkg.sv \

	#vsim -novopt work.hvl_top work.hdl_top -c -do "log -r /*; add wave -r /*; run -all;" \
	#-wlf waveform.wlf
	# To open the waveform use the below command 
	# vsim -view waveform.wlf &

clean:
	rm -rf work/ transcript waveform.wlf
