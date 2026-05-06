`ifndef AXI_M_AGENT_SV
`define AXI_M_AGENT_SV

class axi_m_agent #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_agent;

    `uvm_component_param_utils(axi_m_agent#(ADDR_WIDTH,DATA_WIDTH))

    virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH) m_vif;
    axi_m_agent_cfg                           m_agt_cfg;

    axi_m_seqr #(ADDR_WIDTH,DATA_WIDTH)       m_seqr_h;
    axi_m_drv #(ADDR_WIDTH,DATA_WIDTH)        m_drv_h;
    axi_m_mon #(ADDR_WIDTH,DATA_WIDTH)        m_mon_h;

    function new(string name="axi_m_agent", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db #(virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH))::get(this,"","m_vif",m_vif))
            `uvm_fatal(get_full_name(), "Can't get m_vif from config db")
            
        if(!uvm_config_db#(axi_m_agent_cfg)::get(this,"","m_agent_cfg",m_agt_cfg))
            `uvm_fatal(get_full_name(),"Can't get m_agent_cfg from config db")

        if(m_agt_cfg.is_active == UVM_ACTIVE) begin
            m_seqr_h = axi_m_seqr#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_seqr_h",this);
            m_drv_h  = axi_m_drv#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_drv_h",this);
        end

        m_mon_h = axi_m_mon#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_mon_h",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(m_agt_cfg.is_active == UVM_ACTIVE) begin
            m_drv_h.seq_item_port.connect(m_seqr_h.seq_item_export);
            m_drv_h.m_vif = m_vif;
        end
        m_mon_h.m_vif = m_vif;
    endfunction

endclass

`endif