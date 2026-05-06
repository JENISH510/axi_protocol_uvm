`ifndef AXI_S_DRV_SV
`define AXI_S_DRV_SV

class axi_s_drv #(int ADDR_WIDTH=32,DATA_WIDTH=32) 
  extends uvm_driver #(axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH));

    `uvm_component_param_utils(axi_s_drv #(ADDR_WIDTH,DATA_WIDTH))

    virtual axi_s_inf#(ADDR_WIDTH,DATA_WIDTH).SDRV_MP s_vif;
    
    axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH) r_data[$];
    axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH) b_resp[$];
    int a,b;


    function new(string name="axi_s_drv",uvm_component parent);
        super.new(name,parent);
    endfunction


    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            begin
                forever begin
                    seq_item_port.get(req);
                    a = req.ARID;
                    b = req.RID;
                    if(a == b)begin
                        $display("match arid : %0h , rid : %0h",a,b);
                        `uvm_info("ID MATCH","aaaaa",UVM_LOW)
                    end 
                    else begin
                        $display("mismatch arid : %0h , rid : %0h",a,b);
                        `uvm_info("ID MISMATCH","aaaaa",UVM_LOW)
                    end

                    case(req.kind_e)
                        WRITE: b_resp.push_back(req);
                        READ : r_data.push_back(req);
                    endcase
                end
            end

            send_to_master();

        join_none
    endtask


    task send_to_master();
        fork
            slave_write_addr_channel();
            slave_write_data_channel();
            slave_read_addr_channel();
            slave_bresp_channel();
            slave_read_channel();
        join_none
    endtask


    // ---------------- READY SIGNALS ----------------
    task slave_write_addr_channel();
        forever begin
            @(s_vif.s_drv_cb);
            s_vif.s_drv_cb.AWREADY <= 1'b1;
        end
    endtask

    task slave_write_data_channel();
        forever begin
            @(s_vif.s_drv_cb);
            s_vif.s_drv_cb.WREADY <= 1'b1;
        end
    endtask

    task slave_read_addr_channel();
        forever begin
            @(s_vif.s_drv_cb);
            s_vif.s_drv_cb.ARREADY <= 1'b1;
        end
    endtask


    // ---------------- B CHANNEL ----------------
    task slave_bresp_channel();
        axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH) trans;

        forever begin
            wait(b_resp.size() > 0);
            trans = b_resp.pop_front();

            @(s_vif.s_drv_cb);
            s_vif.s_drv_cb.BID    <= trans.AWID;
            s_vif.s_drv_cb.BRESP  <= trans.BRESP;
            s_vif.s_drv_cb.BVALID <= 1'b1;
            @(s_vif.s_drv_cb iff s_vif.s_drv_cb.BREADY);
            s_vif.s_drv_cb.BVALID <= 1'b0;
        end
    endtask


    // ---------------- R CHANNEL ----------------
    task slave_read_channel();
        axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH) r_trans_h;
        int r_data_cnt;
        @(s_vif.s_drv_cb);
        forever begin
            wait(r_data.size() != 0);
            r_trans_h = r_data.pop_front();
            for (int i = 0; i <= r_trans_h.ARLEN; i++) begin
                s_vif.s_drv_cb.RID    <= r_trans_h.RID;
                s_vif.s_drv_cb.RDATA  <= r_trans_h.RDATA[i];
                s_vif.s_drv_cb.RRESP  <= r_trans_h.RRESP;
                s_vif.s_drv_cb.RVALID <= 1'b1;
                s_vif.s_drv_cb.RLAST  <= (i == r_trans_h.ARLEN);
                @(s_vif.s_drv_cb iff s_vif.s_drv_cb.RREADY);
                r_data_cnt++;
                $display("rd data in s drv: %0h , len : %0d , last:%0d , valid : %0d",s_vif.s_drv_cb.RDATA,r_trans_h.ARLEN, s_vif.s_drv_cb.RLAST,s_vif.s_drv_cb.RVALID);
            end
            s_vif.s_drv_cb.RVALID <= 1'b0;
            s_vif.s_drv_cb.RLAST  <= 1'b0;
        end
    endtask

endclass

`endif
