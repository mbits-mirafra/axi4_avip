# Accelerated VIP for AXI4 Protocol

The idea of using Accelerated VIP is to push the synthesizable part of the testbench into the separate top module along with the interface and it is named as HDL TOP and the unsynthesizable part is pushed into the HVL TOP. This setup provides the ability to run the longer tests quickly. This particular testbench can be used for the simulation as well as the emulation based on mode of operation.


# Features:
1. Support read and write Independent channels
2. Separate address/control and data phases
3. outstanding and Non outstanding Transfers
4. Parallel write and read transfer
5. Support outstanding transfer
6. No strict timing relationship between address and data operations
7. Support different types of Burst based transactions (fixed, incr, wrap)
8. Support okay and slave error response
9. Support for Out-of-order transaction
10. Support for Unaligned address transfers
11. Support for Custom Slave memory 
12. Support for Narrow transfers 

# Architecture Diagram  
![AXI4](https://user-images.githubusercontent.com/15922511/183240262-b28b57cd-bda3-4cd8-ae2b-620d07f7a92b.jpg)

# Developers, Welcome
We believe in growing together and if you'd like to contribute, please do check out the contributing guide below:  
https://github.com/mbits-mirafra/axi4_avip/blob/production/contribution_guidelines.md

# Installation - Get the VIP collateral from the GitHub repository

```
# Checking for git software, open the terminal type the command
git version

# Get the VIP collateral
git clone git@github.com:mbits-mirafra/axi4_avip.git
```

# Test Packages and Mode Selection

The testbench is organised into three independent **test-package families** that share a common base test (`axi4_test_base_pkg`). Exactly one family is compiled at a time, chosen with the `MODE` switch at compile time based on what you are verifying:

| MODE | Test package | DUT / role | When to use |
|------|--------------|-----------|-------------|
| `b2b` (default) | `axi4_back_to_back_test_pkg` | Active master &harr; active slave VIP | Full protocol verification with both agents active — write/read, non-outstanding & outstanding, in-order & out-of-order responses, across all data widths and burst types |
| `slave` | `axi4_standalone_slave_test_pkg` | Slave RTL as DUT (master active) | Verifying a **slave** DUT: the AVIP master generates transaction across all widths, burst and response types while the slave rtl respondes |
| `master` | `axi4_standalone_master_test_pkg` | Master RTL as DUT (slave active) | Verifying a **master** DUT: the dut master drives the transfers while the slave avip stays active |

Each family has its own regression testlist under `src/hvl_top/testlists/`:

- `axi4_back_to_back_regression.list`
- `axi4_standalone_slave_regression.list`
- `axi4_standalone_master_regression.list`

Select the mode when compiling (the base test package and shared components are always built; only the selected family's test and virtual-sequence packages are enabled, toggled in place in `sim/axi4_compile.f` via `//@MODE=` markers):

```
make compile MODE=<b2b|slave|master>      # default: b2b
```

# Running the test

### Using Mentor's Questasim simulator 

```
cd axi4_avip/sim/questasim

# Compilation (select the test-package family):  
make compile MODE=<b2b|slave|master>      # default: b2b

# Simulation:
make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>

ex: make simulate test=axi4_back_to_back_write_read_test uvm_verbosity=UVM_HIGH

# Note: You can find all the test case names in the per-mode regression lists   
axi4_avip/src/hvl_top/testlists/axi4_back_to_back_regression.list
axi4_avip/src/hvl_top/testlists/axi4_standalone_slave_regression.list
axi4_avip/src/hvl_top/testlists/axi4_standalone_master_regression.list

# Wavefrom:  
vsim -view <test_name>/waveform.wlf &

ex: vsim -view axi4_back_to_back_write_read_test/waveform.wlf &

# Regression:
make regression testlist_name=<regression_testlist_name.list> MODE=<b2b|slave|master>
ex: make regression testlist_name=axi4_back_to_back_regression.list MODE=b2b

# Coverage: 
 ## Individual test:
 firefox <test_name>/html_cov_report/index.html &
 ex: firefox axi4_back_to_back_write_read_test/html_cov_report/index.html &

 ## Regression:
 firefox merged_cov_html_report/index.html &

```
### Latest regression coverage report link

https://github.com/mbits-mirafra/axi4_avip/issues/108

## Technical Document 
https://github.com/mbits-mirafra/axi4_avip/blob/production/doc/axi4_avip_architecture_document.pdf 

## User Guide  
https://github.com/mbits-mirafra/axi4_avip/blob/production/doc/axi4_avip_user_guide.pdf

## Contact Mirafra Team  
You can reach out to us over mbits@mirafra.com

For more information regarding Mirafra Technologies please do checkout our officail website:  
https://mirafra.com/
