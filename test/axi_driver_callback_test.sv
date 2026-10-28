`ifndef AXI_DRIVER_CALLBACK_TEST_SV
`define AXI_DRIVER_CALLBACK_TEST_SV

class axi_reset_m_cb extends axi_m_drv_cb_32;
    `uvm_object_utils(axi_reset_m_cb)
    virtual axi_s_inf#(32,32) s_vif;
    bit reset_done;

    function new(string name="axi_reset_m_cb");
        super.new(name);
    endfunction

    virtual task before_transfer(
        virtual axi_m_inf#(32,32).MDRV_MP vif,
        string channel,
        inout int unsigned transfer_count
    );
        transfer_count++;
        if (!reset_done && transfer_count > 3) begin
            reset_done = 1;
            vif.m_drv_cb.ARESETn = 1'b0;
            s_vif.ARESETn = 1'b0;
            repeat (3) @(vif.m_drv_cb);
            vif.m_drv_cb.ARESETn = 1'b1;
            s_vif.ARESETn = 1'b1;
        end
        wait(vif.m_drv_cb.ARESETn);
    endtask
endclass

class axi_ready_toggle_s_cb extends axi_s_drv_cb_32;
    `uvm_object_utils(axi_ready_toggle_s_cb)
    int unsigned cycle;

    function new(string name="axi_ready_toggle_s_cb");
        super.new(name);
    endfunction

    virtual task get_ready(
        virtual axi_s_inf#(32,32).SDRV_MP vif,
        string channel,
        output bit ready
    );
        cycle++;
        ready = vif.s_drv_cb.ARESETn && ((cycle % 3) != 0);
    endtask
endclass

class axi_valid_wait_m_cb extends axi_m_drv_cb_32;
    `uvm_object_utils(axi_valid_wait_m_cb)
    int unsigned wait_count;

    function new(string name="axi_valid_wait_m_cb");
        super.new(name);
    endfunction

    virtual task before_valid(
        virtual axi_m_inf#(32,32).MDRV_MP vif,
        string channel
    );
        wait_count++;
        repeat (wait_count % 3) @(vif.m_drv_cb);
    endtask
endclass

class axi_reset_callback_test extends axi_base_test;
    `uvm_component_utils(axi_reset_callback_test)
    axi_reset_m_cb reset_cb;

    function new(string name="axi_reset_callback_test", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        reset_cb = axi_reset_m_cb::type_id::create("reset_cb");
        reset_cb.s_vif = s_vif;
        uvm_callbacks#(axi_m_drv_32, axi_m_drv_cb_32)::add(
            env_h.m_uvc_h.m_agent_h[0].m_drv_h, reset_cb);
    endfunction

    task run_phase(uvm_phase phase);
        axi_sanity_vseqs seq;
        super.run_phase(phase);
        phase.raise_objection(this);
        seq = axi_sanity_vseqs::type_id::create("seq");
        seq.start(env_h.vseqr_h);
        phase.drop_objection(this);
    endtask
endclass

class axi_ready_toggle_callback_test extends axi_base_test;
    `uvm_component_utils(axi_ready_toggle_callback_test)
    axi_ready_toggle_s_cb ready_cb;
    axi_valid_wait_m_cb valid_cb;

    function new(string name="axi_ready_toggle_callback_test", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        ready_cb = axi_ready_toggle_s_cb::type_id::create("ready_cb");
        valid_cb = axi_valid_wait_m_cb::type_id::create("valid_cb");
        uvm_callbacks#(axi_s_drv_32, axi_s_drv_cb_32)::add(
            env_h.s_uvc_h.s_agent_h[0].s_drv_h, ready_cb);
        uvm_callbacks#(axi_m_drv_32, axi_m_drv_cb_32)::add(
            env_h.m_uvc_h.m_agent_h[0].m_drv_h, valid_cb);
    endfunction

    task run_phase(uvm_phase phase);
        axi_b2b_vseqs seq;
        super.run_phase(phase);
        phase.raise_objection(this);
        seq = axi_b2b_vseqs::type_id::create("seq");
        seq.start(env_h.vseqr_h);
        phase.drop_objection(this);
    endtask
endclass

`endif
