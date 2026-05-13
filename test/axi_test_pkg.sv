`ifndef AXI_TEST_PKG_SV
`define AXI_TEST_PKG_SV

package axi_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
  
    import axi_m_agent_pkg::*;   
    import axi_s_agent_pkg::*;  
    import axi_env_pkg::*;

    bit [3:0] shared_addr_q[$];   
    `include "axi_base_test.sv"

    `include "axi_fixed_m_wseqs.sv"
    `include "axi_fixed_test.sv"

	`include "axi_wrap_m_wseqs.sv"
	`include "axi_wrap_test.sv"

	`include "axi_incr_m_wseqs.sv"
	`include "axi_incr_test.sv"

    `include "axi_sanity_m_wseqs.sv"
    `include "axi_sanity_test.sv"

    `include "axi_b2b_m_wseqs.sv"
    `include "axi_b2b_test.sv"

    `include "axi_random_m_wseqs.sv"
    `include "axi_random_test.sv"

    `include "axi_corner_m_wseqs.sv"
    `include "axi_corner_test.sv"
    
    `include "axi_lower_m_wseqs.sv"
    `include "axi_lower_test.sv"
    
    `include "axi_coverage_m_wseqs.sv"
    `include "axi_coverage_test.sv"
    
    `include "axi_wrap_cov_m_wseqs.sv"
    `include "axi_wrap_cov_test.sv"
    
    `include "axi_incr_cov_m_wseqs.sv"
    `include "axi_incr_cov_test.sv"
endpackage

`endif
