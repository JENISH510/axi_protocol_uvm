`ifndef AXI_LOWER_M_WSEQS_SV
`define AXI_LOWER_M_WSEQS_SV

class axi_lower_m_wseqs #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends axi_base_m_seqs#(ADDR_WIDTH,DATA_WIDTH);

    `uvm_object_param_utils(axi_lower_m_wseqs#(ADDR_WIDTH,DATA_WIDTH))

    axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) m_seq_item_h;
    bit [ADDR_WIDTH-1:0] saved_addr;
    bit [7:0]   saved_len;

    function new(string name="axi_lower_m_wseqs");
        super.new(name);
    endfunction

    task body();
            
        repeat(no_of_trans) begin
            
            void'(this.randomize());

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::WRITE;
                
                burst_kind_e == axi_m_agent_pkg::FIXED;
                
                //AWID         == 16'hffff;
                //AWADDR inside {[0:1000]};
                AWADDR       == 32'h0000_0000;
                AWLEN        == 8'd2; 
                AWSIZE       == 8'd3; 

                foreach(WDATA[i])
                    WDATA[i] inside {32'h5555_5555, 32'hAAAA_AAAA,32'hffff_ffff};

                /*foreach(WSTRB[i]) {
                    WSTRB[i] == 4'hF; 
                }*/
            });
            finish_item(m_seq_item_h);

            saved_addr = m_seq_item_h.AWADDR;

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::READ;
                
                burst_kind_e == axi_m_agent_pkg::FIXED;
                
                //ARID         == seq_arid;
                ARID         == 16'h0000;
                ARADDR       == saved_addr;
                ARLEN        == 8'd2; 
                //ARLEN        == saved_len;
                ARSIZE       == 8'd3; 
            });
            finish_item(m_seq_item_h);
        end
      resp(2);
    endtask
    
endclass

`endif

