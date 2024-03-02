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

# // TODO(mshariff): 
# Add .git rules to ignore log files, basically the sim folder except makefile and scripts


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
	echo "To compile use:";
	echo "make compile";
	echo "";
	echo "To provide compilation argument:";
	echo "make compile args=+<macro_name>=<macro_value>";
	echo "";
	echo "make compile args=+DATA_WIDTH=64";
	echo "";
	echo "To simulate individual test:"
	echo "make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>";
	echo "";
	echo "Example:":
	echo "make simulate test=base_test uvm_verbosity=UVM_HIGH";
	echo "";
	echo "To run regression:"
	echo "make regression testlist_name=<regression_testlist_name.list>";
	echo "";
	echo "Example:":
	echo "make regression testlist_name=axi4_transfers_regression.list";
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";

all:
	make clean; make compile; make simulate;

# For Assertions use +acc options
#  +cover=becstf
compile:
	make clean_compile;
	make clean_simulate;
	vlib work; 
	vlog -sv \
	+acc \
	+cover \
	+fcover \
	+define$(args) \
	-l axi4_compile.log \
	-f ../axi4_compile.f 

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

ifndef args
override args = +DATA_WIDTH=32
endif


## For randomized seed
# TODO(mshariff): 
#Add this line after -sva 
#-sv_seed random 

# Setting the default test folder to test name 
ifndef test_folder
override test_folder = $(test)
endif

simulate:
	mkdir $(test_folder)

	# Use -novopt for no optimization - Makes the simulation slower
	# vsim -pli finesim.so -coverage top
	vsim -vopt \
	work.hvl_top \
	work.hdl_top \
	-voptargs=+acc=npr \
	-assertdebug \
	+UVM_TESTNAME=$(test) \
	+UVM_VERBOSITY=$(uvm_verbosity) \
	-l $(test_folder)/$(test).log \
	-sva \
  -coverage \
	-c -do "log -r /*; add wave -r /*; coverage save -onexit -assert -directive -cvg -codeAll $(test_folder)/$(test)_coverage.ucdb; run -all; exit" \
	-wlf $(test_folder)/waveform.wlf


	# For checking and reporting simulation errors
	make simulate_war_err

	## TODO(mshariff): 
	## # For coverage report in text format 
	## #vcover report -text $(test)/$(test)_cov
	# -c -do "log -r /*; add wave -r /*; coverage save -onexit -assert -directive -cvg -codeAll $(test)/coverage.ucdb; coverage report -file $(teset)/coverage.txt -byfile -detail -noannotate -option -directive -cvg -details -verbose; run -all; exit" \
	# vcover report -file  -byfile -detail -noannotate -option -cvg

	# For coverage report in HTML format 
	vcover report -html $(test_folder)/$(test)_coverage.ucdb -htmldir $(test_folder)/html_cov_report -details

	# To open the html coverage report
	# firefox test_folder/html_cov_report/index.html &

	# To open the waveform use the below command 
	# vsim -view waveform.wlf &
	#
	# To open the wavefrom with saved signals
	# vsim -view waveform.wlf -do axi4_waves.do &

clean_simulate:
	rm -rf *_test*

clean_compile:
	rm -rf work/ *_compile.log transcript waveform.wlf
	rm -rf merged_coverage.ucdb merged_cov_html_report

#clean:
#	make clean_compile
#	make clean_simulate

##
## For Regression and coverage merge
##
regression:
	# Run compilation
	#make compile
	make clean_simulate
	# Run simualtion - regression 
	python regression_handling.py $(testlist_name)
	#	# Get the tests from regression list
	#	grep "_test" ../../src/hvl_top/testlists/axi4_simple_fd_regression.list | grep -v "\#" > reg_list
	#	make simulate test=value #Get the name from regression list
	#	Merge coverage
	make merge_cov_report
		
# For merge to happen, the coverage names for each test must be different
#
merge_cov_report:
	rm -rf merged_coverage.ucdb merged_cov_html_report
	# Merging all the coverage
	vcover merge merged_coverage.ucdb -64 */*.ucdb  
	#vcover merge mem_cover mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5 mem_cov6 mem_cov7 mem_cov8
	vcover report -html merged_coverage.ucdb -htmldir ./merged_cov_html_report -details

	echo "";
	echo "-----------------------------------------------------------------";
	echo "Coverage report: firefox merged_cov_html_report/index.html &"
	echo "-----------------------------------------------------------------";
	echo "";

compile_war_err:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------- Compilation Report --------------------------";
	echo "";
	grep "^** " axi4_compile.log;
	echo "";
	grep "^Error" axi4_compile.log;
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
	grep "Error" $(test_folder)/$(test).log;
	echo "";
	echo "UVM Fatal";
	grep "UVM_FATAL" $(test_folder)/$(test).log;
	echo "";
	echo "UVM Errors";
	grep "UVM_ERROR" $(test_folder)/$(test).log;
	echo "";
	echo "UVM Warnings";
	grep "UVM_WARNING" $(test_folder)/$(test).log;
	echo "";
	echo "Testname: $(test)"
	echo "";
	echo "Log file path: $(test_folder)/$(test).log"
	echo "";
	echo "Waveform: vsim -view $(test_folder)/waveform.wlf &"
	echo "";
	echo "Coverage report: firefox $(test_folder)/html_cov_report/index.html &"
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";
