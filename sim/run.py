import sys
import os

# Default UVM_TESTNAME (checks environment variables first)
uvm_testname = os.environ.get("UVM_TESTNAME", "base_test")

# Get the target (comp, sim, or sim1)
target = sys.argv[1] if len(sys.argv) > 1 else ""

# Allow overriding test name as a second argument (e.g., python run.py sim my_test)
if len(sys.argv) > 2:
    uvm_testname = sys.argv[2]

# Define and run the commands
if target == "comp":
    cmd = "vlog ../env/m_agent/axi_m_agent_pkg.sv ../env/s_agent/axi_s_agent_pkg.sv ../env/axi_env_pkg.sv ../test/axi_test_pkg.sv ../top/axi_tb_top.sv +incdir+../env/m_agent +incdir+../env/s_agent +incdir+../env +incdir+../test +incdir+../top"
    print("Running: " + cmd)
    os.system(cmd)

elif target == "comp1":
    cmd = "vlog -coveropt 3 +acc +cover ../env/m_agent/axi_m_agent_pkg.sv ../env/s_agent/axi_s_agent_pkg.sv ../env/axi_env_pkg.sv ../test/axi_test_pkg.sv ../top/axi_tb_top.sv +incdir+../env/m_agent +incdir+../env/s_agent +incdir+../env +incdir+../test +incdir+../top"
    print("Running: " + cmd)
    os.system(cmd)

elif target == "sim":
    cmd = 'vsim -voptargs=+acc axi_tb_top -c -do "run -all; exit" +UVM_TESTNAME=' + uvm_testname
    print("Running: " + cmd)
    os.system(cmd)

elif target == "sim1":
    cmd = 'vsim -voptargs=+acc axi_tb_top -do "do wave.do; run -all; exit" +UVM_TESTNAME=' + uvm_testname
    print("Running: " + cmd)
    os.system(cmd)

elif target == "sim2":
    cmd = 'vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_cg.ucdb; run -all; exit" +UVM_TESTNAME=' + uvm_testname
    print("Running: " + cmd)
    os.system(cmd)

elif target == "report":
    cmd = 'vcover report -details -html -output axi_cg axi_cg.ucdb'
    print("Running: " + cmd)
    os.system(cmd)

else:
    print("Usage: python run.py [comp | sim | sim1] [optional_testname]")
