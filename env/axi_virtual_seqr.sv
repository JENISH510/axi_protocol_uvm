`ifndef AXI_VIRTUAL_SEQR_SV
`define AXI_VIRTUAL_SEQR_SV

class axi_virtual_seqr #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_sequencer;

    `uvm_component_param_utils(axi_virtual_seqr #(ADDR_WIDTH, DATA_WIDTH))

    // -------------------------------------------------------------------------
    // Handles to real sequencers — set by axi_env in connect_phase
    // -------------------------------------------------------------------------
    axi_m_seqr #(ADDR_WIDTH,DATA_WIDTH) m_seqr_h;
    //axi_s_seqr #(32,32) s_seqr_h;

    function new(string name="axi_vrtual_seqr", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

`endif
