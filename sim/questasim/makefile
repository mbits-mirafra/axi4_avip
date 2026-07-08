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
	echo "To select which test-package family to compile (edits compile.f in place):";
	echo "make compile MODE=<b2b|slave|master>   (default: b2b)";
	echo "";
	echo "  b2b    - back-to-back master<->slave VIP";
	echo "  slave  - standalone slave RTL test package only";
	echo "  master - standalone master RTL test package only";
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
	echo "To provide seed number (default is random):"
	echo "make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL> seed=<value>";
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

# Select which test-package family is active in the shared filelist.
# Edits the EXISTING ../axi4_compile.f in place (no new file is generated):
#   - comments every //@MODE= tagged line, then re-enables only MODE's lines
#   - points hvl_top at the matching test package
select_mode:
	case "$(MODE)" in \
	  slave|master|b2b) ;; \
	  *) echo "ERROR: invalid MODE '$(MODE)'. Use MODE=slave|master|b2b"; exit 1 ;; \
	esac
	echo "Selecting compile MODE = $(MODE) (editing ../axi4_compile.f + hvl_top.sv in place)";
	sed -i -E '/@MODE=/ { /^\/\// ! s|^|//| }' ../axi4_compile.f
	sed -i -E '/@MODE=$(MODE)/ s|^//||' ../axi4_compile.f
	case "$(MODE)" in \
	  slave)  pkg=axi4_standalone_slave_test_pkg ;; \
	  master) pkg=axi4_standalone_master_test_pkg ;; \
	  b2b)    pkg=axi4_back_to_back_test_pkg ;; \
	esac; \
	sed -i -E "s|import axi4_[a-z0-9_]*_test_pkg::\*;|import $$pkg::*;|" ../../src/hvl_top/hvl_top.sv

# For Assertions use +acc options
#  +cover=becstf
compile:
	make clean_compile;
	make clean_simulate;
	make select_mode MODE=$(MODE);
	vlib work;
	vlog -sv \
	+acc \
	+cover \
	+fcover \
	+define+AXI_MODE_$(MODE) \
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
override uvm_verbosity = UVM_NONE
endif

ifndef args
override args = +DATA_WIDTH=32
endif

# Setting the default compile MODE (which test-package family to build)
# Valid values:
#   b2b    - back-to-back master<->slave VIP (default)
#   slave  - standalone slave RTL test package only
#   master - standalone master RTL test package only
ifndef MODE
override MODE = b2b
endif


## For randomized seed
# TODO(mshariff): 
#Add this line after -sva 
#-sv_seed random 

# Setting the default seed value to random
ifndef seed
override seed = random
endif


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
	-sv_seed $(seed) \
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
	make clean_simulate
	make compile MODE=$(MODE)
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
