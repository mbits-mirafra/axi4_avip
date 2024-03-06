# -s means silent mode
# The command executed along with the output will be displayed on the terminal
# To get only the ouput use 'silent' mode
#
# make target -s


# -n or --just-print
# The first test I perform on a new makefile target is to invoke make with the --just-print (-n) option.
# This causes make to read the makefile and print every command it would normally execute to
# update the target but without executing them.
#
# make target -n


# When you run make with the -i or --ignore-errors flag,
# errors are ignored in all recipes of all rules.
# A rule in the makefile for the special target .IGNORE has the same effect,
# if there are no prerequisites. This is less flexible but sometimes useful.
# When errors are to be ignored, because of -i flag, make treats an error return just like success,
# except that it prints out a message that tells you the status code the shell exited with,
# and says that the error has been ignored.
#
# make target -i

.IGNORE:
	compile
	simulate

# WE can also use the target where we WANT the silent mode
.SILENT:
	compile
	simulate
	usage

# First target will be executed incase the user doesn't mention
# the target to execute
# In this case, usage will be executed
# Usage
usage:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------------- Usage ---------------------------------";
	echo "";
	echo "make target <options> <variable>=<value>";
	echo "";
	echo "To compile use:"
	echo "make compile";
	echo "";
	echo "To simulate use:"
	echo "make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>";
	echo "";
	echo "Example:":
	echo "make simulate test=base_test uvm_verbosity=UVM_HIGH";
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";

all:
	make clean; make compile; make simulate;

# TODO(mshariff):
# Need some work to point to the
# dir:
#     mkdir -p logfiles_and_waveforms

# For Assertions use +acc options
compile:
	make clean_compile;

	# For Xcelium
	# xrun -c
	# -xmlibdirname INCA_libs \
		#
	# If not given this then the tool will use the default
	# installation of UVM library
	# -uvmhome $(UVMHOME) \

	irun -c \
		-clean \
		-elaborate \
		-coverage a \
		-access +rwc \
		-64 \
		-sv \
		-uvm \
		+access+rw \
		-f ../axi4_compile.f \
		-l axi4_compile.log \
		-top worklib.hdl_top:sv \
		-top worklib.hvl_top:sv \
		-nclibdirname INCA_libs \
		-SVA

	# -s means silent mode
	#  The command executed along with the output will be displayed on the terminal
	#  To get only the ouput use 'silent' mode
	# make compile_war_err -s
	# or use .SILENT
	make compile_war_err

# Setting a default test as base_test
ifndef test
override test = axi4_base_test
endif

# Setting the default uvm_verbosity to UVM_MEDIUM
ifndef uvm_verbosity
override uvm_verbosity = UVM_MEDIUM
endif

simulate:
	echo "Inside simulate"
	make clean_simulate
	mkdir $(test)

	irun -R \
		-licqueue \
		-64 \
		-l $(test)/$(test).log \
		+UVM_TESTNAME=$(test) \
		+UVM_VERBOSITY=$(uvm_verbosity) \
		-input shm.tcl \
		-nclibdirname INCA_libs

	#-seed random
	#-write_metrics \
		#-covfile coverage_config_file \
		#-covdut hdl_top \
		#-uvm \
		#-coverage All

	make simulate_war_err

	# `ifdef VCD_ON
	# $dumpfile("fpga_top.vcd");
	# $dumpvars(0, tb_fpga);
	# `endif
	#
	# `ifdef QUESTA
	#   $wlfdumpvars(0);
	# `else
	#   `ifdef WAVES_OFF
	#   `else
	#     $shm_open("waves.shm");
	#     $shm_probe("AS");
	#   `endif
	# `endif
	#

	# To open the waveform use the below command
	# vsim -view waveform.wlf &
	#
	# To open the wavefrom with saved signals
	# vsim -view waveform.wlf -do axi4_waves.do &
	#
	# Coverage
	# 1) cov_work_paths.txt - Has the path for the coverage files (path consisting of cov_work/scope/test
	# 2) merge_cov.cmd - Has the below contents
	#    merge -out all_cov_merge -overwrite -runfile cov_work_paths.txt -message 1 -initial_model union_all
	#    load -run cov_work/scope/all_cov_merge
	#    report_metrics -out report_s -detail -metrics all
	#    OR
	#    merge -out all_cov_merge -overwrite -runfile cov_work_paths.txt -message 1 -initial_model union_all -out $(merge_dir)
	#    load -run cov_work/scope/$(merge_dir)
	#    report_metrics -out report_s -detail -metrics toggle -inst fpga_top
	# 3) imc -exec merge_cov.cmd
	#

clean_simulate:
	rm -rf *_test cov_work

clean_compile:
	rm -rf INCA_libs *_compile.log *_compile.history

clean:
	make clean_compile
	make clean_simulate

compile_war_err:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------- Compilation Report --------------------------";
	echo "";
	grep "*W" axi4_compile.log;
	echo "";
	grep "*E" axi4_compile.log;
	echo "";
	echo "Log file path: axi4_compile.log"
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";

simulate_war_err:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-------------------- Simulation Report --------------------------";
	echo "";
	echo "Simulator Errors";
	grep "\*E" $(test)/$(test).log;
	echo "";
	grep "\*F" $(test)/$(test).log;
	echo "";
	echo "UVM Fatal";
	grep "UVM_FATAL" $(test)/$(test).log;
	echo "";
	echo "UVM Errors";
	grep "UVM_ERROR" $(test)/$(test).log;
	echo "";
	echo "UVM Warnings";
	grep "UVM_WARNING" $(test)/$(test).log;
	echo "";
	echo "Testname: $(test)"
	echo "Log file path: $(test)/$(test).log"
	echo "Waveform: simvision waves.shm/"
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";
