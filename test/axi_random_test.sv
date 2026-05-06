`ifndef AXI_RANDOM_TEST_SV
`define AXI_RANDOM_TEST_SV

class axi_random_vseqs extends axi_base_vseqs;

  `uvm_object_utils(axi_random_vseqs)

    axi_random_m_wseqs m_wseqs_h;

    function new(string name="axi_random_vseqs");
        super.new(name);
    endfunction

    task body();
        super.body();
        `uvm_do_on_with(m_wseqs_h,m_seqr_h,{no_of_trans == 50;})
    endtask

endclass

class axi_random_test extends axi_base_test;

  `uvm_component_utils(axi_random_test)

    axi_random_vseqs vseqs_h;

  function new(string name="axi_random_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        vseqs_h=axi_random_vseqs::type_id::create("vseqs_h");
    endfunction

    task run_phase(uvm_phase phase);
      	super.run_phase(phase);
        phase.raise_objection(this);

        vseqs_h.start(env_h.vseqr_h);

        phase.drop_objection(this);

      phase.phase_done.set_drain_time(this, 10000ns);
    endtask

endclass

`endif


