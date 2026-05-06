`ifndef AXI_BASE_S_SEQS_SV
`define AXI_BASE_S_SEQS_SV

class axi_base_s_seqs #(int ADDR_WIDTH = 32, DATA_WIDTH = 32)
    extends uvm_sequence #(axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH));

    rand int no_of_trans;

    constraint ITR_c { soft no_of_trans == 20; }

    int ctr;

    `uvm_declare_p_sequencer(axi_s_seqr #(ADDR_WIDTH, DATA_WIDTH))

    `uvm_object_param_utils_begin(axi_base_s_seqs #(ADDR_WIDTH, DATA_WIDTH))
        `uvm_field_int(no_of_trans, UVM_ALL_ON)
    `uvm_object_utils_end

    axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH) s_seq_item_h, read;
    axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH) read_q[$];

    function new(string name = "axi_base_s_seqs");
        super.new(name);
    endfunction

    reg [DATA_WIDTH-1:0] mem [int unsigned];

    int r_cnt, cnt_r, cnt_r_d;

    task body();
        int unsigned addr;
        int unsigned base_addr;
        int unsigned wrap_lower_limit;
        int unsigned wrap_upper_limit;
        automatic int unsigned captured_arid;

        forever begin
            p_sequencer.item_req_fifo.get(req);

            if (req.kind_e == WRITE) begin
                base_addr = req.AWADDR;
                addr      = base_addr;

                //wrap_lower_limit = (int'(base_addr / ((1 << req.AWSIZE) * (req.AWLEN + 1))))
                //                   * ((1 << req.AWSIZE) * (req.AWLEN + 1));
                //wrap_upper_limit = wrap_lower_limit + ((1 << req.AWSIZE) * (req.AWLEN + 1));

                for (int beat = 0; beat < req.WDATA.size(); beat++) begin
                    case (req.AWBURST)
                        2'b00: begin
                            mem[addr] = req.WDATA[beat];
                            addr += 1;
                        end

                        2'b01: begin
                            mem[addr] = req.WDATA[beat];
                            addr += (1 << req.AWSIZE);
                        end

                        2'b10: begin
                            addr = base_addr + beat * (1 << req.AWSIZE);
                            //if (addr >= wrap_upper_limit) begin
                            //    addr = wrap_lower_limit + (addr - wrap_upper_limit);
                            //end
                            mem[addr] = req.WDATA[beat];
                        end

                        default: addr = base_addr;
                    endcase
                end

                `uvm_send(req)
            end

            else if (req.kind_e == READ) begin
                read_q.push_back(req);
                r_cnt++;
                // $display("r cnt in s seqs before: %0d", r_cnt);
            end

            foreach (read_q[i]) begin
                read = axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("read");

                if (mem.exists(read_q[i].ARADDR)) begin
                    read          = read_q[i];
                    captured_arid = read_q[i].ARID;

                    base_addr = read.ARADDR;
                    addr      = base_addr;

                    read.RDATA.delete();

                    cnt_r_d++;
                    // $display("cnt_R_d: %0d", cnt_r_d);

                    wrap_lower_limit = (int'(base_addr / ((1 << read.ARSIZE) * (read.ARLEN + 1))))
                                       * ((1 << read.ARSIZE) * (read.ARLEN + 1));
                    wrap_upper_limit = wrap_lower_limit + ((1 << read.ARSIZE) * (read.ARLEN + 1));

                    for (int beat = 0; beat <= read.ARLEN; beat++) begin
                        case (read.ARBURST)
                            2'b00: begin
                                read.RDATA.push_back(mem[addr]);
                                addr += 1;
                            end

                            2'b01: begin
                                read.RDATA.push_back(mem[addr]);
                                addr += (1 << read.ARSIZE);
                            end

                            2'b10: begin
                                addr = base_addr + beat * (1 << read.ARSIZE);
                                if (addr >= wrap_upper_limit) begin
                                    addr = wrap_lower_limit + (addr - wrap_upper_limit);
                                end
                                read.RDATA.push_back(mem[addr]);
                            end

                            default: addr = base_addr;
                        endcase
                    end

                    cnt_r++;
                    // $display("r cnt in s seqs after : %0d", cnt_r);

                    read_q.delete(i);

                    // $display("data check in s seqs : %p", read);

                    read.RID = captured_arid;

                    $display("s seqs arid : %0d", captured_arid);

                    ctr++;
                    $display("INIDE_SLAVE_SEQ_CTR=%0d", ctr);

                    // read.print();

                    `uvm_send(read)

                    read = null;
                end
            end
        end
    endtask

endclass

`endif
