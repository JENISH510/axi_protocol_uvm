`ifndef AXI_VIRTUAL_SEQR_SV
`define AXI_VIRTUAL_SEQR_SV

class axi_virtual_seqr extends uvm_sequencer;

    `uvm_component_utils(axi_virtual_seqr)

    // -------------------------------------------------------------------------
    // Handles to real sequencers — set by axi_env in connect_phase
    // -------------------------------------------------------------------------
    axi_m_seqr #(32,32) m_seqr_h;
    //axi_s_seqr #(32,32) s_seqr_h;

    function new(string name="axi_vrtual_seqr", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

`endif
