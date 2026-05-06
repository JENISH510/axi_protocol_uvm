`ifndef AXI_S_AGENT_SV
`define AXI_S_AGENT_SV

class axi_s_agent #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_agent;

    `uvm_component_param_utils(axi_s_agent#(ADDR_WIDTH,DATA_WIDTH))

    virtual axi_s_inf#(ADDR_WIDTH,DATA_WIDTH) s_vif;
    axi_s_agent_cfg                           s_agt_cfg;

    axi_s_seqr #(ADDR_WIDTH,DATA_WIDTH)       s_seqr_h;
    axi_s_drv #(ADDR_WIDTH,DATA_WIDTH)        s_drv_h;
    axi_s_mon #(ADDR_WIDTH,DATA_WIDTH)        s_mon_h;

    function new(string name="axi_s_agent", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db #(virtual axi_s_inf#(ADDR_WIDTH,DATA_WIDTH))::get(this,"","s_vif",s_vif))
            `uvm_fatal(get_full_name(), "Can't get s_vif from config db")
            
        if(!uvm_config_db#(axi_s_agent_cfg)::get(this,"","s_agent_cfg",s_agt_cfg))
            `uvm_fatal(get_full_name(),"Can't get s_agent_cfg from config db")

        if(s_agt_cfg.is_active == UVM_ACTIVE) begin
            s_seqr_h = axi_s_seqr#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_seqr_h",this);
            s_drv_h  = axi_s_drv#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_drv_h",this);
        end

        s_mon_h = axi_s_mon#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_mon_h",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(s_agt_cfg.is_active == UVM_ACTIVE) begin
            s_drv_h.seq_item_port.connect(s_seqr_h.seq_item_export);
            s_drv_h.s_vif = s_vif;
        end
        s_mon_h.s_vif = s_vif;
        s_mon_h.s_port.connect(s_seqr_h.item_collected_export);
    endfunction

endclass

`endif