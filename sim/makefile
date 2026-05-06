#makefile

UVM_TESTNAME=''

comp:
	vlog ../env/m_agent/axi_m_agent_pkg.sv ../env/s_agent/axi_s_agent_pkg.sv ../env/axi_env_pkg.sv ../test/axi_test_pkg.sv ../top/axi_tb_top.sv +incdir+../env/m_agent +incdir+../env/s_agent +incdir+../env +incdir+../test +incdir+../top

comp1:
	vlog -coveropt 3 +acc +cover ../env/m_agent/axi_m_agent_pkg.sv ../env/s_agent/axi_s_agent_pkg.sv ../env/axi_env_pkg.sv ../test/axi_test_pkg.sv ../top/axi_tb_top.sv +incdir+../env/m_agent +incdir+../env/s_agent +incdir+../env +incdir+../test +incdir+../top
sim:
	vsim -voptargs=+acc axi_tb_top -c -do "run -all; exit" +UVM_TESTNAME=$(UVM_TESTNAME)

sim1:
	vsim -voptargs=+acc axi_tb_top -do "do wave.do; run -all; exit" +UVM_TESTNAME=$(UVM_TESTNAME)

sim2:
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_cg.ucdb; run -all; exit" +UVM_TESTNAME=$(UVM_TESTNAME)

report:
	vcover report -details -html -output axi_cg axi_cg.ucdb

regress:
	vlog -coveropt 3 +acc +cover ../env/m_agent/axi_m_agent_pkg.sv ../env/s_agent/axi_s_agent_pkg.sv ../env/axi_env_pkg.sv ../test/axi_test_pkg.sv ../top/axi_tb_top.sv +incdir+../env/m_agent +incdir+../env/s_agent +incdir+../env +incdir+../test +incdir+../top
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_wrap_test.ucdb; run -all; exit" +UVM_TESTNAME=axi_wrap_test -l axi_wrap_test.log
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_incr_test.ucdb; run -all; exit" +UVM_TESTNAME=axi_incr_test -l axi_incr_test.log
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_fixed_test.ucdb; run -all; exit" +UVM_TESTNAME=axi_fixed_test -l axi_fixed_test.log
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_sanity_test.ucdb; run -all; exit" +UVM_TESTNAME=axi_sanity_test -l axi_sanity_test.log
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_random_test.ucdb; run -all; exit" +UVM_TESTNAME=axi_random_test -l axi_random_test.log
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_b2b_test.ucdb; run -all; exit" +UVM_TESTNAME=axi_b2b_test -l axi_b2b_test.log
	vsim -coverage -voptargs=+acc axi_tb_top -c -do "coverage save -onexit -directive -cvg -codeall axi_corner_test.ucdb; run -all; exit" +UVM_TESTNAME=axi_corner_test -l axi_corner_test.log
	vcover merge func_cov.ucdb axi_wrap_test.ucdb axi_incr_test.ucdb axi_fixed_test.ucdb axi_sanity_test.ucdb axi_random_test.ucdb axi_b2b_test.ucdb axi_corner_test.ucdb
	vcover report -html -details -output func_cov func_cov.ucdb
	rm axi_wrap_test.ucdb axi_incr_test.ucdb axi_fixed_test.ucdb axi_sanity_test.ucdb axi_random_test.ucdb axi_b2b_test.ucdb axi_corner_test.ucdb
