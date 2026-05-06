`ifndef AXI_WRAP_TEST_SV
`define AXI_WRAP_TEST_SV

class axi_wrap_vseqs extends axi_base_vseqs;

  `uvm_object_utils(axi_wrap_vseqs)

    axi_wrap_m_wseqs m_wseqs_h;
    //axi_base_s_seqs #(32,32) s_seqs_h;

    function new(string name="axi_sanity_vseqs");
        super.new(name);
    endfunction

    task body();
      	//s_seqs_h=axi_base_s_seqs#(32,32)::type_id::create("s_seqs_h");
        super.body();
      	//fork
      	//s_seqs_h.start(s_seqr_h);
      `uvm_do_on_with(m_wseqs_h,m_seqr_h,{no_of_trans == 100;})
        //join_any
    endtask

endclass

class axi_wrap_test extends axi_base_test;

  `uvm_component_utils(axi_wrap_test)

    axi_wrap_vseqs vseqs_h;
  	//axi_base_s_seqs#(ADDR_WIDTH,DATA_WIDTH) s_seqs_h;

  function new(string name="axi_wrap_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        vseqs_h=axi_wrap_vseqs::type_id::create("vseqs_h");
        //s_seqs_h=axi_base_s_seqs::type_id::create("s_seqs_h",this);
    endfunction

    task run_phase(uvm_phase phase);
      	super.run_phase(phase);
        phase.raise_objection(this);

      //fork
        //s_seqs_h.start(env_h.s_agent_h.s_seqr_h);
        vseqs_h.start(env_h.vseqr_h);
      //join_any

        phase.drop_objection(this);

      phase.phase_done.set_drain_time(this, 10000ns);
    endtask

endclass

`endif
