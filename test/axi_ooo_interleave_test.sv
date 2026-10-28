`ifndef AXI_OOO_INTERLEAVE_TEST_SV
`define AXI_OOO_INTERLEAVE_TEST_SV

class axi_ooo_interleave_vseqs extends axi_base_vseqs;
    `uvm_object_utils(axi_ooo_interleave_vseqs)

    axi_ooo_interleave_m_wseqs m_wseqs_h;

    function new(string name = "axi_ooo_interleave_vseqs");
        super.new(name);
    endfunction

    task body();
        super.body();
        `uvm_do_on(m_wseqs_h, m_seqr_h)
    endtask
endclass

class axi_ooo_interleave_test extends axi_base_test;
    `uvm_component_utils(axi_ooo_interleave_test)

    function new(string name = "axi_ooo_interleave_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_cfg_h.allow_narrow_transfer = 1;
        env_cfg_h.narrow_transfer_size = 1;
        env_cfg_h.allow_out_of_order = 1;
        env_cfg_h.allow_interleaving = 1;
        env_cfg_h.reset_between_transactions = 1;
    endfunction

    task run_phase(uvm_phase phase);
        axi_ooo_interleave_vseqs first_seq;
        axi_ooo_interleave_vseqs second_seq;

        super.run_phase(phase);
        phase.raise_objection(this);

        first_seq = axi_ooo_interleave_vseqs::type_id::create("first_seq");
        second_seq = axi_ooo_interleave_vseqs::type_id::create("second_seq");
        first_seq.start(env_h.vseqr_h);
        pulse_reset(env_cfg_h.reset_cycles);
        second_seq.start(env_h.vseqr_h);

        phase.drop_objection(this);
        phase.phase_done.set_drain_time(this, 50000ns);
    endtask
endclass

`endif
