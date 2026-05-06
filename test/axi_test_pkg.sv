`ifndef AXI_TEST_PKG_SV
`define AXI_TEST_PKG_SV

package axi_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
  
    import axi_m_agent_pkg::*;   
    import axi_s_agent_pkg::*;  
    import axi_env_pkg::*;

    bit [3:0] shared_addr_q[$];   // shared queue
    `include "axi_base_test.sv"

    `include "axi_fixed_m_wseqs.sv"
    `include "axi_fixed_test.sv"

	`include "axi_wrap_m_wseqs.sv"
	`include "axi_wrap_test.sv"

	`include "axi_incr_m_wseqs.sv"
	`include "axi_incr_test.sv"

endpackage

`endif
