`ifndef AXI_BASE_TEST_SV
`define AXI_BASE_TEST_SV

class axi_base_test #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_test;

    typedef axi_env #(ADDR_WIDTH,DATA_WIDTH) env_type;
    typedef virtual axi_m_inf #(ADDR_WIDTH,DATA_WIDTH) m_vif_type;
    typedef virtual axi_s_inf #(ADDR_WIDTH,DATA_WIDTH) s_vif_type;

    `uvm_component_param_utils(axi_base_test #(ADDR_WIDTH, DATA_WIDTH))

    axi_env #(ADDR_WIDTH,DATA_WIDTH) env_h;
    axi_env_cfg env_cfg_h; 
    m_vif_type m_vif;
    s_vif_type s_vif;

    //axi_base_m_seqs #(32,32) m_seq_h;
    axi_base_s_seqs #(ADDR_WIDTH,DATA_WIDTH) s_seq_h;

    function new(string name="axi_base_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_cfg_h = axi_env_cfg::type_id::create("env_cfg_h");

        env_cfg_h.is_m_agt_active = UVM_ACTIVE;
        env_cfg_h.is_s_agt_active = UVM_ACTIVE;
        if (!uvm_config_db#(m_vif_type)::get(this,"","m_vif",m_vif))
            `uvm_fatal(get_full_name(), "Can't get master interface")
        if (!uvm_config_db#(s_vif_type)::get(this,"","s_vif",s_vif))
            `uvm_fatal(get_full_name(), "Can't get slave interface")

        uvm_config_db #(axi_env_cfg)::set(this,"*","env_cfg_h",env_cfg_h);

        env_h = env_type::type_id::create("env_h",this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        // m_seq_h = axi_base_m_seqs #(32,32)::type_id::create("m_seq_h");
        //s_seq_h = axi_base_s_seqs #(32,32)::type_id::create("s_seq_h");
      foreach(env_h.s_uvc_h.s_agent_h[i])begin
        automatic int idx = i;
        fork
          begin
            s_seq_h = axi_base_s_seqs #(ADDR_WIDTH,DATA_WIDTH)::type_id::create($sformatf("s_seq_h_%0d", idx));
            // m_seq_h.start(env_h.m_uvc_h.m_agent_h.m_seqr_h);
            s_seq_h.start(env_h.s_uvc_h.s_agent_h[idx].s_seqr_h);
          end
        join_none
      end
    endtask

    task pulse_reset(int unsigned cycles = 2);
        m_vif.ARESETn = 1'b0;
        s_vif.ARESETn = 1'b0;
        repeat (cycles) @(posedge m_vif.ACLK);
        m_vif.ARESETn = 1'b1;
        s_vif.ARESETn = 1'b1;
    endtask

endclass

`endif
