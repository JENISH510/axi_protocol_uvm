`ifndef AXI_B2B_M_WSEQS_SV
`define AXI_B2B_M_WSEQS_SV

class axi_b2b_m_wseqs #(int ADDR_WIDTH = 32, DATA_WIDTH = 32) extends axi_base_m_seqs #(ADDR_WIDTH, DATA_WIDTH);

    `uvm_object_param_utils(axi_b2b_m_wseqs #(ADDR_WIDTH, DATA_WIDTH))
    
    function new(string name = "axi_b2b_m_wseqs");
        super.new(name);
    endfunction

    task body();
        repeat (no_of_trans) begin
            axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) wr_item;
            axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) rd_item;
            bit [ADDR_WIDTH-1:0] shared_addr;

            void'(this.randomize());
            shared_addr = $urandom_range(0, 1000);

            fork
                begin
                    wr_item = axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("wr_item");
                    start_item(wr_item);
                    assert(wr_item.randomize() with {
                        kind_e         == axi_m_agent_pkg::WRITE;
                        burst_kind_e   == axi_m_agent_pkg::INCR;
                        AWADDR         == shared_addr;
                        AWLEN inside   {[0:100]};
                        AWSIZE         == 8'd3;
                    });
                    finish_item(wr_item);
                end

                begin
                    rd_item = axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("rd_item");
                    start_item(rd_item);
                    assert(rd_item.randomize() with {
                        kind_e         == axi_m_agent_pkg::READ;
                        burst_kind_e   == axi_m_agent_pkg::INCR;
                        ARADDR         == shared_addr;
                        ARLEN inside   {[0:10]};
                        ARSIZE         == 8'd3;
                    });
                    finish_item(rd_item);
                end
            join
        end

        resp(100);
    endtask

endclass

`endif
