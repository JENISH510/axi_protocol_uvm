`ifndef AXI_WRAP_M_WSEQS_SV
`define AXI_WRAP_M_WSEQS_SV

class axi_wrap_m_wseqs #(int ADDR_WIDTH=32, DATA_WIDTH=32) extends axi_base_m_seqs#(ADDR_WIDTH, DATA_WIDTH);

    `uvm_object_param_utils(axi_wrap_m_wseqs#(ADDR_WIDTH, DATA_WIDTH))

    axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) m_seq_item_h;
    bit [ADDR_WIDTH-1:0] saved_addr;
    bit [7:0]   saved_len;

    int wr,rd;
    function new(string name="axi_wrap_m_wseqs");
        super.new(name);
    endfunction

    task body();

        repeat(no_of_trans) begin

            void'(this.randomize());

            // -------------------- WRITE TRANSACTION --------------------
            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::WRITE;
                burst_kind_e == axi_m_agent_pkg::WRAP;
                //AWADDR inside {[0:2000]};
                //AWLEN        == 8'd3;
                AWLEN inside {1,3,7,15};
                AWSIZE       == 8'd3;    
            });
            finish_item(m_seq_item_h);

            wr++;
            //$display("wr in wrap seqs: %0d , len : %0d , wr_addr : %0d , aw_id : %0d , w_id : %0d", wr, m_seq_item_h.AWLEN, m_seq_item_h.AWADDR, m_seq_item_h.AWID, m_seq_item_h.WID);
           
            //`uvm_info("SEQ", "Write transaction fully completed on bus", UVM_HIGH)

            saved_addr = m_seq_item_h.AWADDR;
            saved_len  = m_seq_item_h.AWLEN;

            // -------------------- READ TRANSACTION --------------------
            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");
            start_item(m_seq_item_h);
            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::READ; 
                burst_kind_e == axi_m_agent_pkg::WRAP; 
                ARADDR       == saved_addr;
                //ARLEN        == 8'd3;     
                ARLEN        == saved_len;
                ARSIZE       == 8'd3;        
            });
            //$display("ARID IN WRAP SEQS : %0h",m_seq_item_h.ARID);
            finish_item(m_seq_item_h);

            rd++;
            //$display("rd in wrap seqs: %0d , len : %0d , rd_addr : %0d , ar_id : %0d , r_id : %0d", rd, m_seq_item_h.ARLEN, m_seq_item_h.ARADDR, m_seq_item_h.ARID, m_seq_item_h.RID);
            //`uvm_info("SEQ", "Read transaction fully completed on bus", UVM_HIGH)

        end // repeat
      resp(100);

    endtask

endclass

`endif
