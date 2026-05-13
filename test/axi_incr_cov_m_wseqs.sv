`ifndef AXI_INCR_COV_M_WSEQS_SV
`define AXI_INCR_COV_M_WSEQS_SV

class axi_incr_cov_m_wseqs #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends axi_base_m_seqs#(ADDR_WIDTH,DATA_WIDTH);

    `uvm_object_param_utils(axi_incr_cov_m_wseqs#(ADDR_WIDTH,DATA_WIDTH))

    axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) m_seq_item_h;
    
    bit [ADDR_WIDTH-1:0] saved_addr;
    bit [7:0]            saved_len;
    bit [1:0]            saved_burst;

    function new(string name="axi_incr_cov_m_wseqs");
        super.new(name);
    endfunction

    task body();
            
        repeat(no_of_trans) begin
            
            void'(this.randomize());

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::WRITE;
                burst_kind_e inside {axi_m_agent_pkg::FIXED, axi_m_agent_pkg::INCR};
                AWSIZE       == 8'd3; 
                
                foreach(WDATA[i])
                    WDATA[i] inside {32'h5555_5555, 32'h0000_0000, 32'hffff_ffff,32'hFFFE_FFFF};
            });
            
            if (m_seq_item_h.burst_kind_e == axi_m_agent_pkg::FIXED) begin
                m_seq_item_h.AWADDR = 32'hFFFF_FFFF;
            end else begin
                m_seq_item_h.AWADDR = 32'h0000_0000;
            end
            
            finish_item(m_seq_item_h);

            saved_addr  = m_seq_item_h.AWADDR;
            saved_len   = m_seq_item_h.AWLEN;
            saved_burst = m_seq_item_h.burst_kind_e;

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            
            if (saved_burst == axi_m_agent_pkg::FIXED) begin
                assert(m_seq_item_h.randomize() with {
                    kind_e       == axi_s_agent_pkg::READ;
                    burst_kind_e == axi_s_agent_pkg::FIXED;
                    ARLEN        == saved_len;
                    ARSIZE       == 8'd3; 
                });
            end else begin
                assert(m_seq_item_h.randomize() with {
                    kind_e       == axi_s_agent_pkg::READ;
                    burst_kind_e == axi_s_agent_pkg::INCR;
                    ARLEN        == saved_len;
                    ARSIZE       == 8'd3; 
                });
            end
            
            m_seq_item_h.ARADDR = saved_addr;
            
            finish_item(m_seq_item_h);
        end
        resp(20);
    endtask
    
endclass

`endif
