`ifndef AXI_BASE_M_SEQS_SV
`define AXI_BASE_M_SEQS_SV

class axi_base_m_seqs #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends uvm_sequence #(axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH));

    rand int no_of_trans;
    constraint ITR_c {soft no_of_trans == 20;}

    `uvm_object_param_utils_begin(axi_base_m_seqs #(ADDR_WIDTH,DATA_WIDTH))
        `uvm_field_int(no_of_trans,UVM_ALL_ON)
    `uvm_object_utils_end
    
    axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH) m_seq_item_h;
    axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH) req_s;

    function new(string name="axi_base_m_seqs");
        super.new(name);
    endfunction
    
    task body();
    endtask

    task resp(int ctr = 1);
        repeat(ctr) begin
            get_response(req_s);
            `uvm_info("IN V SEQS","Got B-channel response from driver",UVM_MEDIUM)
        end
    endtask
  
endclass
`endif