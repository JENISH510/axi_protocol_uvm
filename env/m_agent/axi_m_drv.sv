`ifndef AXI_M_DRV_SV
`define AXI_M_DRV_SV

class axi_m_drv #(int ADDR_WIDTH=32,DATA_WIDTH=32) extends uvm_driver #(axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH));

    `uvm_component_param_utils(axi_m_drv #(ADDR_WIDTH,DATA_WIDTH))

    virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH).MDRV_MP m_vif;

    axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) req;

    int cnt;
    int aw_ctr;

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
                seq_item_port.get(req);
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
            aw_ctr++;
            aw_ch = wr_addr_q.pop_front();

            m_vif.m_drv_cb.AWVALID <= 1'b1;
            m_vif.m_drv_cb.AWID    <= aw_ch.AWID;
            m_vif.m_drv_cb.AWADDR  <= aw_ch.AWADDR;
            m_vif.m_drv_cb.AWLEN   <= aw_ch.AWLEN;
            m_vif.m_drv_cb.AWSIZE  <= aw_ch.AWSIZE;
            m_vif.m_drv_cb.AWBURST <= aw_ch.AWBURST;

            @(m_vif.m_drv_cb iff (m_vif.m_drv_cb.AWREADY));

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
            w_trans = wr_data_q.pop_front();

            for (int i = 0; i <= w_trans.AWLEN; i++) begin
                m_vif.m_drv_cb.WID    <= w_trans.AWID;
                $display("WID: %0d , AWID : %0d", m_vif.m_drv_cb.WID, w_trans.AWID);
                m_vif.m_drv_cb.WDATA  <= w_trans.WDATA[i];
                m_vif.m_drv_cb.WSTRB  <= w_trans.WSTRB[i];
                m_vif.m_drv_cb.WVALID <= 1'b1;
                m_vif.m_drv_cb.WLAST  <= (i == w_trans.AWLEN);

                @(m_vif.m_drv_cb iff m_vif.m_drv_cb.WREADY);
                $display($time,"wlast : %0d",m_vif.m_drv_cb.WLAST);
            end
          if(wr_data_q.size() == 0)begin
            $display($time,"later wlast : %0d",m_vif.m_drv_cb.WLAST);
            m_vif.m_drv_cb.WVALID <= 1'b0;
            m_vif.m_drv_cb.WLAST <= 1'b0;
          end
            //m_vif.m_drv_cb.WDATA  <= 0;
            $display("AFFTER W CHANNEL");
        end
    endtask

    task write_resp_channel;
        axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH) req_b, rsp;
        forever begin
            wait(wr_resp_q.size() > 0);
            req_b = wr_resp_q.pop_front();

            m_vif.m_drv_cb.BREADY <= 1;
            @(m_vif.m_drv_cb iff (m_vif.m_drv_cb.BVALID));
            m_vif.m_drv_cb.BREADY <= 0;

            $cast(rsp, req_b.clone());
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
            req_ar = rd_addr_q.pop_front();

            m_vif.m_drv_cb.ARVALID   <= 1'b1;
            m_vif.m_drv_cb.ARID      <= req_ar.ARID;
            m_vif.m_drv_cb.ARADDR    <= req_ar.ARADDR;
            m_vif.m_drv_cb.ARLEN     <= req_ar.ARLEN;
            m_vif.m_drv_cb.ARSIZE    <= req_ar.ARSIZE;
            m_vif.m_drv_cb.ARBURST   <= req_ar.ARBURST;

            @(m_vif.m_drv_cb iff (m_vif.m_drv_cb.ARREADY));

            m_vif.m_drv_cb.ARVALID  <= 1'b0;
        end
        $display("AFFTER AR CHANNEL");
    endtask

    task read_data_channel;
        $display("Before R CHANNEL");
        forever begin
            @(m_vif.m_drv_cb);
            m_vif.m_drv_cb.RREADY <= 1'b1;
        end
        $display("AFFTER R CHANNEL");
    endtask

endclass

`endif
