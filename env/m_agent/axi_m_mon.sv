`ifndef AXI_M_MON_SV
`define AXI_M_MON_SV

class axi_m_mon#(int ADDR_WIDTH=32, DATA_WIDTH=32) extends uvm_monitor;
    
    `uvm_component_utils(axi_m_mon#(ADDR_WIDTH, DATA_WIDTH))

    virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH).MMON_MP m_vif;

    uvm_analysis_port#(axi_m_seq_item#(ADDR_WIDTH,DATA_WIDTH)) m_port;

    axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH) get_id[int unsigned];
    bit[ADDR_WIDTH-1:0] awid_q[$];

    axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH) get_arid[int unsigned];

    function new(string name="axi_m_mon",uvm_component parent);
        super.new(name,parent);
        m_port=new("s_port",this); 
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("M MON RUN PHASE before","Inside master mon run phase", UVM_MEDIUM)
        fork
            write_addr_channel();
            write_data_channel();
            write_resp_channel(); 
            read_addr_channel();
            read_data_channel();
        join_none
        `uvm_info("M MON run PHASE after","Inside master mon", UVM_MEDIUM)
    endtask

    task write_addr_channel();
        axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) aw_trans;
        `uvm_info("M MON write addr PHASE before","Inside master mon", UVM_MEDIUM)
        forever begin
            @(m_vif.m_mon_cb iff (m_vif.m_mon_cb.AWVALID && m_vif.m_mon_cb.AWREADY));
            aw_trans = new();
            aw_trans.kind_e  = WRITE;
            aw_trans.AWID    = m_vif.m_mon_cb.AWID;
            aw_trans.AWADDR  = m_vif.m_mon_cb.AWADDR;
            aw_trans.AWLEN   = m_vif.m_mon_cb.AWLEN;
            aw_trans.AWSIZE  = m_vif.m_mon_cb.AWSIZE;
            aw_trans.AWBURST = m_vif.m_mon_cb.AWBURST;

            get_id[aw_trans.AWID] = aw_trans;
            awid_q.push_back(aw_trans.AWID);
        end
    endtask

    task write_data_channel();
        axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) w_trans;
        int unsigned wid;
        `uvm_info("M MON write data PHASE before","Inside master mon", UVM_MEDIUM)
        forever begin
            @(m_vif.m_mon_cb iff (m_vif.m_mon_cb.WVALID && m_vif.m_mon_cb.WREADY));

            wait (awid_q.size() != 0);
            wid = awid_q[0];

            if(get_id.exists(wid))begin
                w_trans = get_id[wid];
                w_trans.WID = wid; 
                w_trans.WDATA.push_back(m_vif.m_mon_cb.WDATA);
                w_trans.WSTRB.push_back(m_vif.m_mon_cb.WSTRB);

                if (m_vif.m_mon_cb.WLAST) begin
                    void'(awid_q.pop_front());
                end
            end
        end
    endtask

    task write_resp_channel();
        axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) b_trans;
        int unsigned bid;
        forever begin
            @(m_vif.m_mon_cb iff (m_vif.m_mon_cb.BVALID && m_vif.m_mon_cb.BREADY));
            
            bid = m_vif.m_mon_cb.BID;
            
            if(get_id.exists(bid)) begin
                b_trans = get_id[bid];
                b_trans.BID = bid;
                m_port.write(b_trans); 
                get_id.delete(bid);
            end
        end
    endtask

    task read_addr_channel();
        axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) ar_trans;
        `uvm_info("M MON read addr PHASE before","Inside master mon", UVM_MEDIUM)
        forever begin
            @(m_vif.m_mon_cb iff (m_vif.m_mon_cb.ARVALID && m_vif.m_mon_cb.ARREADY));
            ar_trans = new();
            ar_trans.kind_e  = READ;
            ar_trans.ARID    = m_vif.m_mon_cb.ARID;
            ar_trans.ARADDR  = m_vif.m_mon_cb.ARADDR;
            ar_trans.ARLEN   = m_vif.m_mon_cb.ARLEN;
            ar_trans.ARSIZE  = m_vif.m_mon_cb.ARSIZE;
            ar_trans.ARBURST = m_vif.m_mon_cb.ARBURST;

            get_arid[ar_trans.ARID] = ar_trans;
            $display("m mon ar id : %0h", ar_trans.ARID);
        end
    endtask

    task read_data_channel();
        axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH) r_trans;
        int unsigned rid;
        `uvm_info("M MON read data PHASE before","Inside master mon", UVM_MEDIUM)
        forever begin
            @(m_vif.m_mon_cb iff (m_vif.m_mon_cb.RVALID && m_vif.m_mon_cb.RREADY));
        
            rid = m_vif.m_mon_cb.RID;
        
            if(get_arid.exists(rid)) begin
                r_trans = get_arid[rid];
                r_trans.RID = rid;
                r_trans.RDATA.push_back(m_vif.m_mon_cb.RDATA);
                r_trans.RRESP = m_vif.m_mon_cb.RRESP;
                if (m_vif.m_mon_cb.RLAST) begin
                    m_port.write(r_trans);
                    get_arid.delete(rid);
                end
            end
            $display("m mon rid : %0h",r_trans.RID); 
        end
    endtask

endclass

`endif
