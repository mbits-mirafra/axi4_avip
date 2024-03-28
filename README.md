
# VIP for Axi4 Lite Protocol

## Key Features 
1. Support Handshake mechanism (valid and ready).
   
## Testbench Architecture Diagram
<img width="910" alt="Screenshot 2024-03-02 at 11 36 46 PM" src="https://github.com/mbits-mirafra/axi4_avip/assets/15922511/cef03f6b-2ee6-4ea2-9b5b-b755fc8574ef">


## Developers, Welcome
We believe in growing together and if you'd like to contribute, please do check out the contributing guide below:  


## Installation - Get the VIP collateral from the GitHub repository

```
# Checking for git software, open the terminal type the command
git version

# Get the VIP collateral
git clone git@github.com:mbits-mirafra/axi4_avip.git

# For handshake flow change branch
git checkout axi4Lite_handshake_flow
```

## Running the test

### Using Mentor's Questasim simulator 

```
cd axi4_avip/projectExamples/vipBack2BackConnection/sim/questasim

# Compilation:  
make compile

# Simulation:
make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>

ex: make simulate test=Axi4LiteValidAndReadyWithProgrammableDelayTest uvm_verbosity=UVM_HIGH

# Wavefrom:  
vsim -view <test_name>/waveform.wlf &

ex: vsim -view Axi4LiteValidAndReadyWithProgrammableDelayTest/waveform.wlf &

# Coverage: 
 ## Individual test:
 firefox <test_name>/html_cov_report/index.html &
 ex: firefox Axi4LiteValidAndReadyWithProgrammableDelayTest/html_cov_report/index.html &

# Check Assertion TB:
cd axi4_avip/projectExamples/vipBack2BackConnection/src

# Compilation && Simulation:  
make compile && make simulate
```

## Contact Mirafra Team  
You can reach out to us over mbits@mirafra.com

For more information regarding Mirafra Technologies please do checkout our officail website:  
https://mirafra.com/
