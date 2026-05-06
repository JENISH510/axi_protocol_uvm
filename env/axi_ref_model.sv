`ifndef AXI_REF_MODEL_SV
`define AXI_REF_MODEL_SV

class axi_ref_model extends uvm_component;
    `uvm_component_utils(axi_ref_model)

    axi_s_seq_item read_q[$];
    axi_s_seq_item read, req;

    uvm_analysis_imp #(axi_s_seq_item, axi_ref_model) mon_imp;
    uvm_analysis_port#(axi_s_seq_item)                 sb_imp;

    function new(string name="axi_ref_model", uvm_component parent);
        super.new(name, parent);
        mon_imp = new("mon_imp", this);
        sb_imp  = new("sb_imp",  this);
    endfunction

    bit [31:0] mem [int unsigned];

    function void write(axi_s_seq_item req);
        int unsigned addr;
        int unsigned base_addr;
        int unsigned wrap_lower_limit;
        int unsigned wrap_upper_limit;
        int abc, xyz;

        if(req.kind_e == axi_s_agent_pkg::WRITE) begin
            base_addr        = req.AWADDR;
            addr             = base_addr;
            //wrap_lower_limit = (int'(base_addr / ((1 << req.AWSIZE) * (req.AWLEN + 1))))
            //                   * ((1 << req.AWSIZE) * (req.AWLEN + 1));
            //wrap_upper_limit = wrap_lower_limit + ((1 << req.AWSIZE) * (req.AWLEN + 1));

            for(int i = 0; i < req.WDATA.size(); i++) begin
                case(req.AWBURST)
                    2'b00: begin
                        mem[addr] = req.WDATA[i];
                        addr += 1;
                    end
                    2'b01: begin
                        mem[addr] = req.WDATA[i];
                        addr += (1 << req.AWSIZE);
                    end
                    2'b10: begin
                        addr = base_addr + i * (1 << req.AWSIZE);
                        //if(addr >= wrap_upper_limit)
                        //    addr = wrap_lower_limit + (addr - wrap_upper_limit);
                        mem[addr] = req.WDATA[i];
                    end
                    default: addr = base_addr;
                endcase
                abc++;
                $display("abc : %0d", abc);
            $display("ref model mem : %p",addr);
            end
        end
        else if(req.kind_e == axi_s_agent_pkg::READ) begin
            read_q.push_back(req);
        end

        begin
            int i;
            i = 0;
            while(i < read_q.size()) begin
                if(mem.exists(read_q[i].ARADDR)) begin
                    read      = read_q[i];
                    base_addr = read.ARADDR;
                    addr      = base_addr;
                    read.RDATA.delete();

                    wrap_lower_limit = (int'(base_addr / ((1 << read.ARSIZE) * (read.ARLEN + 1))))
                                       * ((1 << read.ARSIZE) * (read.ARLEN + 1));
                    wrap_upper_limit = wrap_lower_limit + ((1 << read.ARSIZE) * (read.ARLEN + 1));

                    for(int j = 0; j <= read.ARLEN; j++) begin
                        case(read.ARBURST)
                            2'b00: begin
                                read.RDATA.push_back(mem[addr]);
                                addr += 1;
                            end
                            2'b01: begin
                                read.RDATA.push_back(mem[addr]);
                                addr += (1 << read.ARSIZE);
                            end
                            2'b10: begin
                                addr = base_addr + j * (1 << read.ARSIZE);
                                if(addr >= wrap_upper_limit)
                                    addr = wrap_lower_limit + (addr - wrap_upper_limit);
                                read.RDATA.push_back(mem[addr]);
                            end
                            default: addr = base_addr;
                        endcase
                        read.RID = read.ARID;
                        xyz++;
                        $display("xyz : %0d", xyz);
                    //$display("ref model r mem:%0p ",addr);
                    end

                    read_q.delete(i);
                    sb_imp.write(read);
                end
                else begin
                    i++;
                end
            end
        end

    endfunction

endclass

`endif
