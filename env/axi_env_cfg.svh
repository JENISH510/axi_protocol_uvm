`ifndef AXI_ENV_CFG_SVH
`define AXI_ENV_CFG_SVH

class axi_env_cfg extends uvm_object;

  uvm_active_passive_enum is_m_agt_active;
  uvm_active_passive_enum is_s_agt_active;
  bit reset_enable = 1;
  int unsigned reset_cycles = 5;
  bit reset_between_transactions;
  bit allow_narrow_transfer;
  int unsigned narrow_transfer_size = 1;
  bit allow_out_of_order;
  bit allow_interleaving;
  int unsigned max_outstanding = 8;

  `uvm_object_utils_begin(axi_env_cfg)
    `uvm_field_enum(uvm_active_passive_enum, is_m_agt_active, UVM_ALL_ON)
    `uvm_field_enum(uvm_active_passive_enum, is_s_agt_active, UVM_ALL_ON)
    `uvm_field_int(reset_enable, UVM_ALL_ON)
    `uvm_field_int(reset_cycles, UVM_ALL_ON)
    `uvm_field_int(reset_between_transactions, UVM_ALL_ON)
    `uvm_field_int(allow_narrow_transfer, UVM_ALL_ON)
    `uvm_field_int(narrow_transfer_size, UVM_ALL_ON)
    `uvm_field_int(allow_out_of_order, UVM_ALL_ON)
    `uvm_field_int(allow_interleaving, UVM_ALL_ON)
    `uvm_field_int(max_outstanding, UVM_ALL_ON)
  `uvm_object_utils_end


   function new(string name = "axi_env_cfg");
     super.new(name);
   endfunction

endclass

`endif
