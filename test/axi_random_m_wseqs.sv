`ifndef AXI_RANDOM_M_WSEQS_SV
`define AXI_RANDOM_M_WSEQS_SV

class axi_random_m_wseqs #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends axi_base_m_seqs#(ADDR_WIDTH,DATA_WIDTH);

    `uvm_object_param_utils(axi_random_m_wseqs#(ADDR_WIDTH,DATA_WIDTH))

    axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) m_seq_item_h;
    bit [ADDR_WIDTH-1:0] saved_addr;
    bit [7:0]   saved_len;

    function new(string name="axi_random_m_wseqs");
        super.new(name);
    endfunction

    task body();
            
        repeat(no_of_trans) begin
            
            void'(this.randomize());

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::WRITE;
                
                burst_kind_e inside {axi_m_agent_pkg::FIXED,axi_m_agent_pkg::INCR,axi_m_agent_pkg::WRAP};
                
                //AWID         == seq_awid;
                //AWADDR inside {[0:1000]};
                //AWLEN inside {[0:255]}; 
                //AWSIZE       == 8'd3; 
            });
            finish_item(m_seq_item_h);

            saved_addr = m_seq_item_h.AWADDR;

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_s_agent_pkg::READ;
                
                //burst_kind_e == axi_s_agent_pkg::INCR;
                
                //ARID         == seq_arid;    
                ARADDR       == saved_addr;
                //ARLEN        == 8'd3; 
                //ARLEN        == saved_len;
                //ARSIZE       == 8'd3; 
            });
            finish_item(m_seq_item_h);
        end
      resp(50);
    endtask
    
endclass

`endif

