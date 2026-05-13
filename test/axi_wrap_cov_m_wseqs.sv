`ifndef AXI_WRAP_COV_M_WSEQS_SV
`define AXI_WRAP_COV_M_WSEQS_SV

class axi_wrap_cov_m_wseqs #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends axi_base_m_seqs#(ADDR_WIDTH,DATA_WIDTH);

    `uvm_object_param_utils(axi_wrap_cov_m_wseqs#(ADDR_WIDTH,DATA_WIDTH))

    axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) m_seq_item_h;
    
    rand bit [ADDR_WIDTH-1:0] cov_addr;
    bit [ADDR_WIDTH-1:0] saved_addr;
    bit [7:0]   saved_len;

    constraint cov_addr_c {
        cov_addr inside {32'hFFFF_FFFF, 32'h0000_FFFF, 32'h0000_0000};
    }

    function new(string name="axi_wrap_cov_m_wseqs");
        super.new(name);
    endfunction

    task body();
            
        repeat(no_of_trans) begin
            
            void'(this.randomize());

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::WRITE;
                burst_kind_e == axi_m_agent_pkg::WRAP;
                
                AWSIZE       == 8'd3; 
                
                foreach(WDATA[i])
                    WDATA[i] inside {32'h5555_5555, 32'h0000_0000, 32'hffff_ffff,32'hFFFE_FFFF};
            });
            
            m_seq_item_h.AWADDR = cov_addr;
            
            finish_item(m_seq_item_h);

            saved_addr = m_seq_item_h.AWADDR;
            saved_len  = m_seq_item_h.AWLEN;

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_s_agent_pkg::READ;
                burst_kind_e == axi_s_agent_pkg::WRAP;
                
                ARLEN        == saved_len;
                ARSIZE       == 8'd3; 
            });
            
            m_seq_item_h.ARADDR = saved_addr;
            
            finish_item(m_seq_item_h);
        end
      resp(20);
    endtask
    
endclass

`endif
