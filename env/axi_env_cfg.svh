`ifndef AXI_ENV_CFG_SVH
`define AXI_ENV_CFG_SVH

class axi_env_cfg extends uvm_object;

  uvm_active_passive_enum is_m_agt_active;
  uvm_active_passive_enum is_s_agt_active;

  `uvm_object_utils_begin(axi_env_cfg)
    `uvm_field_enum(uvm_active_passive_enum, is_m_agt_active, UVM_ALL_ON)
    `uvm_field_enum(uvm_active_passive_enum, is_s_agt_active, UVM_ALL_ON)
  `uvm_object_utils_end


   function new(string name = "axi_env_cfg");
     super.new(name);
   endfunction

endclass

`endif

