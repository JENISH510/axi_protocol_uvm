`ifndef AXI_M_UVC_SV
`define AXI_M_UVC_SV

class axi_m_uvc #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_agent;
  
    `uvm_component_param_utils(axi_m_uvc#(ADDR_WIDTH,DATA_WIDTH))
  
    axi_m_agent_cfg #(ADDR_WIDTH,DATA_WIDTH)  m_agt_cfg;
    
    axi_m_agent_cfg #(ADDR_WIDTH,DATA_WIDTH)  magt_cfg[];
    
    axi_m_agent #(ADDR_WIDTH,DATA_WIDTH)      m_agent_h[];
  
    function new(string name="axi_m_uvc", uvm_component parent);
        super.new(name,parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(axi_m_agent_cfg#(ADDR_WIDTH,DATA_WIDTH))::get(this,"","m_agent_cfg",m_agt_cfg))
            `uvm_warning(get_full_name(),"Can't get m_agent_cfg from config db. Using default values.")

        magt_cfg  = new[m_agt_cfg.no_of_axi_m];
        m_agent_h = new[m_agt_cfg.no_of_axi_m];
      
        foreach(magt_cfg[i]) begin
            magt_cfg[i] = axi_m_agent_cfg#(ADDR_WIDTH,DATA_WIDTH)::type_id::create($sformatf("magt_cfg[%0d]", i));
            
            magt_cfg[i].is_active = m_agt_cfg.is_active;
            magt_cfg[i].allow_out_of_order = m_agt_cfg.allow_out_of_order;
            magt_cfg[i].allow_interleaving = m_agt_cfg.allow_interleaving;
            magt_cfg[i].max_outstanding = m_agt_cfg.max_outstanding;

            m_agent_h[i] = axi_m_agent#(ADDR_WIDTH,DATA_WIDTH)::type_id::create($sformatf("m_agent_h[%0d]", i), this);
            
            uvm_config_db#(axi_m_agent_cfg#(ADDR_WIDTH,DATA_WIDTH))::set(this, $sformatf("m_agent_h[%0d]*", i), "m_agent_cfg", magt_cfg[i]);
        end

    endfunction
  
endclass

`endif