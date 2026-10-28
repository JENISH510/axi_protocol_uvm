`ifndef AXI_BASE_VSEQ_SV
`define AXI_BASE_VSEQ_SV

class axi_base_vseqs #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_sequence;

    typedef axi_virtual_seqr #(ADDR_WIDTH, DATA_WIDTH) sequencer_type;
    `uvm_object_param_utils(axi_base_vseqs #(ADDR_WIDTH, DATA_WIDTH))

    // -------------------------------------------------------------------------
    // Declare p_sequencer — gives access to virtual sequencer's sub-handles
    // -------------------------------------------------------------------------
    `uvm_declare_p_sequencer(sequencer_type)

    axi_m_seqr #(ADDR_WIDTH,DATA_WIDTH) m_seqr_h;
    //axi_s_seqr #(32,32) s_seqr_h;
  //axi_m_seq_item #(32,32) req_s;

    function new(string name="axi_base_vseq");
        super.new(name);
    endfunction

    // -------------------------------------------------------------------------
    // body: placeholder — child virtual sequences override this
    // -------------------------------------------------------------------------
    task body();
        m_seqr_h = p_sequencer.m_seqr_h;
        //s_seqr_h = p_sequencer.s_seqr_h;
    endtask
    
  /*task resp(int ctr = 1);
    repeat(ctr)begin
      get_response(req_s);
      `uvm_info("IN V SEQS","display for response",UVM_MEDIUM)
    end
  endtask*/

endclass

`endif
