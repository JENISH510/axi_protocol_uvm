`ifndef AXI_COVERAGE_M_WSEQS_SV
`define AXI_COVERAGE_M_WSEQS_SV

class axi_coverage_m_wseqs #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends axi_base_m_seqs#(ADDR_WIDTH,DATA_WIDTH);

    `uvm_object_param_utils(axi_coverage_m_wseqs#(ADDR_WIDTH,DATA_WIDTH))

    axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) m_seq_item_h;
    bit [ADDR_WIDTH-1:0] saved_addr;
    bit [7:0]   saved_len;

    function new(string name="axi_coverage_m_wseqs");
        super.new(name);
    endfunction

    task body();
            
        repeat(no_of_trans) begin
            
            void'(this.randomize());

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::WRITE;
                burst_kind_e inside {axi_m_agent_pkg::INCR,axi_m_agent_pkg::WRAP};
                
                //AWID         == 16'hffff;
                AWADDR inside {32'h0000_0000,32'hFFFF_FFFF,[32'h0000_0001 : 32'h0000_FFFF],[32'h0001_0000 : 32'hEFFF_FFFF],[32'hF000_0000 : 32'hFFFE_FFFF]};
                AWLEN  inside {[0:15]}; 
                AWSIZE       == 8'd3; 
                
                foreach(WDATA[i])
                    WDATA[i] inside {32'h5555_5555, 32'h0000_0000, 32'hffff_ffff/*,[32'h0000_0001 : 32'hFFFE_FFFF]*/};
            });
            finish_item(m_seq_item_h);

            saved_addr = m_seq_item_h.AWADDR;
            saved_len  = m_seq_item_h.AWLEN;

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_s_agent_pkg::READ;
                burst_kind_e inside {axi_s_agent_pkg::INCR,axi_s_agent_pkg::WRAP};
                
                //ARID         == seq_arid;
                //ARID         == 16'hffff;
                ARADDR       == saved_addr;
                //ARLEN        == 8'd3; 
                ARLEN        == saved_len;
                ARSIZE       == 8'd3; 
            });
            finish_item(m_seq_item_h);
        end
      resp(20);
    endtask
    
endclass

`endif

