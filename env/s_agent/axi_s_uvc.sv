`ifndef AXI_S_UVC_SV
`define AXI_S_UVC_SV

class axi_s_uvc #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_agent;
  
  `uvm_component_param_utils(axi_s_uvc#(ADDR_WIDTH,DATA_WIDTH))
  
  axi_s_agent_cfg #(ADDR_WIDTH,DATA_WIDTH)  s_agt_cfg;
    
  axi_s_agent_cfg #(ADDR_WIDTH,DATA_WIDTH)  sagt_cfg[];
    
  axi_s_agent #(ADDR_WIDTH,DATA_WIDTH)      s_agent_h[];
  
  function new(string name="axi_s_uvc", uvm_component parent);
        super.new(name,parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
      if(!uvm_config_db#(axi_s_agent_cfg#(ADDR_WIDTH,DATA_WIDTH))::get(this,"","s_agent_cfg",s_agt_cfg))
        `uvm_warning(get_full_name(),"Can't get s_agent_cfg from config db. Using default values.")

        sagt_cfg  = new[s_agt_cfg.no_of_axi_s];
      s_agent_h = new[s_agt_cfg.no_of_axi_s];
      
      foreach(sagt_cfg[i]) begin
        sagt_cfg[i] = axi_s_agent_cfg#(ADDR_WIDTH,DATA_WIDTH)::type_id::create($sformatf("sagt_cfg[%0d]", i));
            
        sagt_cfg[i].is_active = s_agt_cfg.is_active;

        s_agent_h[i] = axi_s_agent#(ADDR_WIDTH,DATA_WIDTH)::type_id::create($sformatf("s_agent_h[%0d]", i), this);
            
        uvm_config_db#(axi_s_agent_cfg#(ADDR_WIDTH,DATA_WIDTH))::set(this, $sformatf("m_agent_h[%0d]*", i), "s_agent_cfg", sagt_cfg[i]);
        end

    endfunction
  
endclass

`endif