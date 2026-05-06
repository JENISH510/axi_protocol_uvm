
`ifndef AXI_S_AGENT_PKG_SV
`define AXI_S_AGENT_PKG_SV

`include "axi_defines.svh"
`include "axi_s_inf.sv"

package axi_s_agent_pkg;

   import uvm_pkg::*;
   `include "uvm_macros.svh"

   `include "axi_s_agent_cfg.svh"
   `include "axi_s_seq_item.sv"
   `include "axi_s_seqr.sv"
   `include "axi_s_drv.sv"
   `include "axi_s_mon.sv"
   `include "axi_s_agent.sv"
   `include "axi_s_uvc.sv"
   `include "axi_base_s_seqs.sv"

endpackage

`endif


