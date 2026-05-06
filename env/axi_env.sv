`ifndef AXI_ENV_SV
`define AXI_ENV_SV

class axi_env extends uvm_env;

    `uvm_component_utils(axi_env)

    axi_m_uvc #(32,32)       m_uvc_h;
    axi_s_uvc #(32,32)       s_uvc_h;
    axi_sb                   sb_h;
    axi_ref_model            ref_model_h;

    axi_env_cfg              env_cfg_h;
    axi_m_agent_cfg #(32,32) m_agent_cfg_h;
    axi_s_agent_cfg #(32,32) s_agent_cfg_h;

    axi_virtual_seqr         vseqr_h;

    function new(string name="axi_env",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(axi_env_cfg)::get(this,"","env_cfg_h",env_cfg_h))
            `uvm_fatal(get_full_name(), "Can't get data from config db")
        
        m_agent_cfg_h = axi_m_agent_cfg #(32,32)::type_id::create("m_agent_cfg_h");
        s_agent_cfg_h = axi_s_agent_cfg #(32,32)::type_id::create("s_agent_cfg_h"); 

        m_agent_cfg_h.is_active = env_cfg_h.is_m_agt_active;
        s_agent_cfg_h.is_active = env_cfg_h.is_s_agt_active;
      
        uvm_config_db #(axi_m_agent_cfg#(32,32))::set(this,"m_uvc_h*","m_agent_cfg",m_agent_cfg_h);
        uvm_config_db #(axi_s_agent_cfg#(32,32))::set(this,"s_uvc_h*","s_agent_cfg",s_agent_cfg_h);

        m_uvc_h = axi_m_uvc #(32,32)::type_id::create("m_uvc_h",this);
        s_uvc_h = axi_s_uvc #(32,32)::type_id::create("s_uvc_h",this);
        
        sb_h = axi_sb::type_id::create("sb_h",this);
        ref_model_h = axi_ref_model::type_id::create("ref_model_h", this);
        vseqr_h = axi_virtual_seqr::type_id::create("vseqr_h",this);
    endfunction

    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    foreach(m_uvc_h.m_agent_h[i]) begin
        m_uvc_h.m_agent_h[i].m_mon_h.m_port.connect(sb_h.anl_imp_m);
    end

    vseqr_h.m_seqr_h = m_uvc_h.m_agent_h[0].m_seqr_h;
    
      foreach(s_uvc_h.s_agent_h[i])begin
        s_uvc_h.s_agent_h[i].s_mon_h.s_port.connect(ref_model_h.mon_imp);
      end
    //s_uvc_h.s_agent_h.s_mon_h.s_port.connect(ref_model_h.mon_imp);
    ref_model_h.sb_imp.connect(sb_h.anl_imp_ref);

    // vseqr_h.s_seqr_h = s_uvc_h.s_agent_h.s_seqr_h;
endfunction

endclass

`endif