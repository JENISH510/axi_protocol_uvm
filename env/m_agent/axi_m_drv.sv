`ifndef AXI_M_DRV_SV
`define AXI_M_DRV_SV

class axi_m_drv #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends uvm_driver #(axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH));

    typedef axi_m_drv #(ADDR_WIDTH,DATA_WIDTH) driver_type;
    typedef axi_m_drv_cb #(ADDR_WIDTH,DATA_WIDTH) callback_type;
    `uvm_component_param_utils(axi_m_drv #(ADDR_WIDTH,DATA_WIDTH))
    `uvm_register_cb(driver_type, callback_type)

    virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH).MDRV_MP m_vif;

    axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) req;

    int cnt;
    int aw_ctr;
    bit allow_out_of_order;
    bit allow_interleaving;
    int unsigned max_outstanding = 8;
    int unsigned transfer_count;

    axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) wr_addr_q[$];
    axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) wr_data_q[$];
    axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) wr_resp_q[$];
    axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) rd_addr_q[$];

    function new(string name="axi_m_drv",uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
    fork
        begin
            forever begin
                wait (wr_addr_q.size() + rd_addr_q.size() < max_outstanding);
                seq_item_port.get(req);
                $display("AWLEN IN M DRV:%0d",req.AWLEN);
                cnt++;
                $display("cnt : %0d", cnt);

                case(req.kind_e)
                    WRITE: begin
                        wr_addr_q.push_back(req);
                        wr_data_q.push_back(req);
                        wr_resp_q.push_back(req);
                    end
                    READ: begin
                        rd_addr_q.push_back(req);
                    end
                endcase
            end
        end
        begin
            send_to_dut();
            $display("Data in driver");
            $display("aw_cnt : %0d", aw_ctr);
        end
    join_none
    endtask

    task send_to_dut();
        fork
            write_addr_channel();
            write_data_channel();
            write_resp_channel();
            read_addr_channel();
            read_data_channel();
        join
    endtask

    task write_addr_channel;
        axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) aw_ch;
        $display("Before AW CHANNEL");
        @(m_vif.m_drv_cb);
        forever begin
            wait(wr_addr_q.size() > 0);
            wait(m_vif.ARESETn);
            `uvm_do_callbacks(driver_type, callback_type,
                             before_transfer(m_vif, "AW", transfer_count))
            aw_ctr++;
            aw_ch = wr_addr_q.pop_front();

            m_vif.m_drv_cb.AWID    <= aw_ch.AWID;
            m_vif.m_drv_cb.AWADDR  <= aw_ch.AWADDR;
            m_vif.m_drv_cb.AWLEN   <= aw_ch.AWLEN;
            m_vif.m_drv_cb.AWSIZE  <= aw_ch.AWSIZE;
            m_vif.m_drv_cb.AWBURST <= aw_ch.AWBURST;
            `uvm_do_callbacks(driver_type, callback_type,
                             before_valid(m_vif, "AW"))
            m_vif.m_drv_cb.AWVALID <= 1'b1;

            @(m_vif.m_drv_cb iff (m_vif.m_drv_cb.AWREADY));
            `uvm_do_callbacks(driver_type, callback_type,
                             after_handshake(m_vif, "AW"))

            if (wr_addr_q.size() == 0)
                m_vif.m_drv_cb.AWVALID <= 0;
        end
        $display("AFFTER AW CHANNEL");
    endtask

    task write_data_channel;
        axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) w_trans;
       
        $display("Before W CHANNEL");
        @(m_vif.m_drv_cb);
        forever begin
            wait (wr_data_q.size() != 0);
            wait(m_vif.ARESETn);
            `uvm_do_callbacks(driver_type, callback_type,
                             before_transfer(m_vif, "W", transfer_count))
            if (allow_interleaving) begin
                int idx = $urandom_range(0, wr_data_q.size() - 1);
                w_trans = wr_data_q[idx];
                wr_data_q.delete(idx);
                m_vif.m_drv_cb.WID    <= w_trans.AWID;
                m_vif.m_drv_cb.WDATA  <= w_trans.WDATA[0];
                m_vif.m_drv_cb.WSTRB  <= w_trans.WSTRB[0];
                m_vif.m_drv_cb.WLAST  <= (w_trans.WDATA.size() == 1);
                `uvm_do_callbacks(driver_type, callback_type,
                                 before_valid(m_vif, "W"))
                m_vif.m_drv_cb.WVALID <= 1'b1;
                @(m_vif.m_drv_cb iff m_vif.m_drv_cb.WREADY);
                `uvm_do_callbacks(driver_type, callback_type,
                                 after_handshake(m_vif, "W"))
                if (w_trans.WDATA.size() > 1) begin
                    w_trans.WDATA.pop_front();
                    w_trans.WSTRB.pop_front();
                    wr_data_q.push_back(w_trans);
                end
            end else begin
                w_trans = wr_data_q.pop_front();
                for (int i = 0; i <= w_trans.AWLEN; i++) begin
                    m_vif.m_drv_cb.WID    <= w_trans.AWID;
                    m_vif.m_drv_cb.WDATA  <= w_trans.WDATA[i];
                    m_vif.m_drv_cb.WSTRB  <= w_trans.WSTRB[i];
                    m_vif.m_drv_cb.WLAST  <= (i == w_trans.AWLEN);
                    `uvm_do_callbacks(driver_type, callback_type,
                                     before_valid(m_vif, "W"))
                    m_vif.m_drv_cb.WVALID <= 1'b1;
                    @(m_vif.m_drv_cb iff m_vif.m_drv_cb.WREADY);
                    `uvm_do_callbacks(driver_type, callback_type,
                                     after_handshake(m_vif, "W"))
                end
            end
            if (wr_data_q.size() == 0) begin
                m_vif.m_drv_cb.WVALID <= 1'b0;
                m_vif.m_drv_cb.WLAST <= 1'b0;
            end
        end
    endtask

    task write_resp_channel;
        axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) req_b, rsp;
        int idx;
        forever begin
            wait(wr_resp_q.size() > 0);
            wait(m_vif.ARESETn);
            `uvm_do_callbacks(driver_type, callback_type,
                             before_transfer(m_vif, "B", transfer_count))
            m_vif.m_drv_cb.BREADY <= 1;
            @(m_vif.m_drv_cb iff (m_vif.m_drv_cb.BVALID));

            idx = 0;
            if (allow_out_of_order) begin
                foreach (wr_resp_q[i])
                    if (wr_resp_q[i].AWID == m_vif.m_drv_cb.BID)
                        idx = i;
            end
            req_b = wr_resp_q[idx];
            wr_resp_q.delete(idx);
            $cast(rsp, req_b.clone());
            rsp.BID = m_vif.m_drv_cb.BID;
            rsp.BRESP = m_vif.m_drv_cb.BRESP;
            rsp.set_id_info(req_b);
            seq_item_port.put_response(rsp);
            
            `uvm_info("DRIVER", "Write response sent to sequence", UVM_HIGH)
        end
    endtask

    task read_addr_channel;
        axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) req_ar;
        $display("Before AR CHANNEL");
        @(m_vif.m_drv_cb);
        @(m_vif.m_drv_cb);
        forever begin
            wait(rd_addr_q.size() > 0);
            wait(m_vif.ARESETn);
            `uvm_do_callbacks(driver_type, callback_type,
                             before_transfer(m_vif, "AR", transfer_count))
            req_ar = rd_addr_q.pop_front();

            m_vif.m_drv_cb.ARID      <= req_ar.ARID;
            m_vif.m_drv_cb.ARADDR    <= req_ar.ARADDR;
            m_vif.m_drv_cb.ARLEN     <= req_ar.ARLEN;
            m_vif.m_drv_cb.ARSIZE    <= req_ar.ARSIZE;
            m_vif.m_drv_cb.ARBURST   <= req_ar.ARBURST;
            `uvm_do_callbacks(driver_type, callback_type,
                             before_valid(m_vif, "AR"))
            m_vif.m_drv_cb.ARVALID   <= 1'b1;

            @(m_vif.m_drv_cb iff (m_vif.m_drv_cb.ARREADY));
            `uvm_do_callbacks(driver_type, callback_type,
                             after_handshake(m_vif, "AR"))

            if (rd_addr_q.size() == 0)
                m_vif.m_drv_cb.ARVALID  <= 1'b0;
        end
        $display("AFFTER AR CHANNEL");
    endtask

    task read_data_channel;
        $display("Before R CHANNEL");
        forever begin
            @(m_vif.m_drv_cb);
            m_vif.m_drv_cb.RREADY <= m_vif.ARESETn;
        end
        $display("AFFTER R CHANNEL");
    endtask

endclass

`endif
