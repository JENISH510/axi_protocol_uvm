`ifndef AXI_CORNER_M_WSEQS_SV
`define AXI_CORNER_M_WSEQS_SV

class axi_corner_m_wseqs #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends axi_base_m_seqs#(ADDR_WIDTH,DATA_WIDTH);

    `uvm_object_param_utils(axi_corner_m_wseqs#(ADDR_WIDTH,DATA_WIDTH))

    axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) m_seq_item_h;

    bit [ADDR_WIDTH-1:0] saved_addr;
    bit [7:0] saved_len;

    function new(string name="axi_corner_m_wseqs");
        super.new(name);
    endfunction

    task body();

        repeat(no_of_trans) begin

            void'(this.randomize());

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");

            start_item(m_seq_item_h);

            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_m_agent_pkg::WRITE;
                burst_kind_e == axi_m_agent_pkg::INCR;

                AWID inside {
                    16'h0000,
                    16'hFFFF,
                    [16'h0001 : 16'hFFFE]
                };

                AWADDR inside {
                    32'h0000_0000,
                    32'hFFFF_FFFF,
                    [32'h0000_0001 : 32'hFFFE_FFFF]
                };

                AWLEN inside {[0:255]};
                AWSIZE == 3'd3;

                /*WDATA[0] inside {
                    32'hFFFF_FFFF,
                    32'h5555_5555,
                    32'hAAAA_AAAA
                };*/
            });

            finish_item(m_seq_item_h);

            saved_addr = m_seq_item_h.AWADDR;
            saved_len  = m_seq_item_h.AWLEN;

            m_seq_item_h = axi_m_seq_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("m_seq_item_h");

            start_item(m_seq_item_h);

            assert(m_seq_item_h.randomize() with {
                kind_e       == axi_s_agent_pkg::READ;
                burst_kind_e == axi_s_agent_pkg::INCR;

                ARID inside {
                    16'h0000,
                    16'hFFFF,
                    [16'h0001 : 16'hFFFE]
                };

                ARADDR == saved_addr;
                ARLEN  == saved_len;
                ARSIZE == 3'd3;
            });

            finish_item(m_seq_item_h);

        end

        resp(200);

    endtask

endclass

`endif
