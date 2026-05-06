`ifndef AXI_S_SEQR_SV
`define AXI_S_SEQR_SV

class axi_s_seqr #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends uvm_sequencer #(axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH));

    `uvm_component_param_utils(axi_s_seqr#(ADDR_WIDTH,DATA_WIDTH))

     uvm_analysis_export #(axi_s_seq_item#(ADDR_WIDTH,DATA_WIDTH)) item_collected_export;

     uvm_tlm_analysis_fifo #(axi_s_seq_item#(ADDR_WIDTH,DATA_WIDTH)) item_req_fifo;
    
    function new(string name="axi_s_seqr",uvm_component parent);
        super.new(name,parent);
        item_collected_export=new("item_collected_export",this);
        item_req_fifo=new("item_req_fifo",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        item_collected_export.connect(item_req_fifo.analysis_export);
      `uvm_info("Data in s seqr",$sformatf("Data got in slave seqr"),UVM_MEDIUM)
    endfunction

endclass

`endif
