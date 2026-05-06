`ifndef AXI_M_SEQR_SV
`define AXI_M_SEQR_SV

class axi_m_seqr #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends uvm_sequencer #(axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH));

    `uvm_component_param_utils(axi_m_seqr #(ADDR_WIDTH,DATA_WIDTH))

    function new(string name="axi_m_seqr", uvm_component parent);
        super.new(name,parent);
    endfunction

endclass

`endif

