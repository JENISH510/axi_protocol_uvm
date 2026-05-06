`ifndef AXI_ENV_PKG_SV
`define AXI_ENV_PKG_SV

`include "axi_defines.svh"
package axi_env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import axi_m_agent_pkg::*;
    import axi_s_agent_pkg::*;

    `include "axi_env_cfg.svh"
    `include "axi_coverage.sv"
	`include "axi_ref_model.sv"
    `include "axi_sb.sv"
    `include "axi_virtual_seqr.sv"
    `include "axi_base_vseqs.sv"
    `include "axi_env.sv"

endpackage

`endif
