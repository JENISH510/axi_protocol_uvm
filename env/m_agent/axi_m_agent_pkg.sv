
`ifndef AXI_M_AGENT_PKG_SV
`define AXI_M_AGENT_PKG_SV

`include "axi_defines.svh"
`include "axi_m_inf.sv"

package axi_m_agent_pkg;

   import uvm_pkg::*;
   `include "uvm_macros.svh"

   `include "axi_m_agent_cfg.svh"
   `include "axi_m_seq_item.sv"
   `include "axi_m_seqr.sv"
   `include "axi_m_drv.sv"
   `include "axi_m_mon.sv"
   `include "axi_m_agent.sv"
   `include "axi_m_uvc.sv" 
   `include "axi_base_m_seqs.sv"

endpackage

`endif

