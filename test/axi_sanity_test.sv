`ifndef AXI_SANITY_TEST_SV
`define AXI_SANITY_TEST_SV

class axi_sanity_vseqs extends axi_base_vseqs;

  `uvm_object_utils(axi_sanity_vseqs)

    axi_sanity_m_wseqs m_wseqs_h;

    function new(string name="axi_sanity_vseqs");
        super.new(name);
    endfunction

    task body();
        super.body();
        `uvm_do_on_with(m_wseqs_h,m_seqr_h,{no_of_trans == 1;})
    endtask

endclass

class axi_sanity_test extends axi_base_test;

  `uvm_component_utils(axi_sanity_test)

    axi_sanity_vseqs vseqs_h;

  function new(string name="axi_sanity_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        vseqs_h=axi_sanity_vseqs::type_id::create("vseqs_h");
    endfunction

    task run_phase(uvm_phase phase);
      	super.run_phase(phase);
        phase.raise_objection(this);

        vseqs_h.start(env_h.vseqr_h);

        phase.drop_objection(this);

      phase.phase_done.set_drain_time(this, 100ns);
    endtask

endclass

`endif

