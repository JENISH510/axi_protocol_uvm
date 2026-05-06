`ifndef AXI_S_AGENT_CFG_SVH
`define AXI_S_AGENT_CFG_SVH

class axi_s_agent_cfg#(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_object;

  uvm_active_passive_enum is_active;
  int no_of_axi_s = 1; 

  `uvm_object_param_utils_begin(axi_s_agent_cfg#(ADDR_WIDTH,DATA_WIDTH))
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(no_of_axi_s, UVM_ALL_ON)
  `uvm_object_utils_end

   function new(string name = "axi_s_agent_cfg");
     super.new(name);
   endfunction

endclass

`endif