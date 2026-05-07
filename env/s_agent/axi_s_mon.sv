`ifndef AXI_S_MON_SV
`define AXI_S_MON_SV

class axi_s_mon#(int ADDR_WIDTH=32, DATA_WIDTH=32) extends uvm_monitor;
  	
  	`uvm_component_utils(axi_s_mon#(ADDR_WIDTH, DATA_WIDTH))

    virtual axi_s_inf#(ADDR_WIDTH,DATA_WIDTH).SMON_MP s_vif;

	uvm_analysis_port#(axi_s_seq_item#(ADDR_WIDTH,DATA_WIDTH)) s_port;

  	axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH) get_id[int unsigned];
    bit[ADDR_WIDTH-1:0] awid_q[$];

	function new(string name="axi_s_mon",uvm_component parent);
		super.new(name,parent);
		s_port = new("s_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		fork
            monitor();
        join_none
	endtask

    task monitor();
        fork
			write_addr_channel();
			write_data_channel();
			read_addr_channel();
		join
    endtask

	task write_addr_channel();
		axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH) aw_trans;
		forever begin
			@(s_vif.s_mon_cb iff (s_vif.s_mon_cb.AWVALID && s_vif.s_mon_cb.AWREADY));
			aw_trans         = new();
			aw_trans.kind_e  = WRITE;
			aw_trans.AWID    = s_vif.s_mon_cb.AWID;
			aw_trans.AWADDR  = s_vif.s_mon_cb.AWADDR;
			aw_trans.AWLEN   = s_vif.s_mon_cb.AWLEN;
			aw_trans.AWSIZE  = s_vif.s_mon_cb.AWSIZE;
			aw_trans.AWBURST = s_vif.s_mon_cb.AWBURST;
            //$display("burst in s mon : %p",aw_trans.AWBURST);

            //$display("awid in s mon : %0h , awaddr : %0h",aw_trans.AWID,aw_trans.AWADDR);
            get_id[aw_trans.AWID] = aw_trans;
            awid_q.push_back(aw_trans.AWID);
		end
  	endtask

	task write_data_channel();
		axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH) w_trans;
		axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH) w_trans_copy;
        bit [31:0] mask, masked_data;
        int unsigned wid;

		forever begin
			@(s_vif.s_mon_cb iff (s_vif.s_mon_cb.WVALID && s_vif.s_mon_cb.WREADY));

			wait (awid_q.size() != 0);
			wid = awid_q[0];

            if(get_id.exists(wid)) begin
                w_trans = get_id[wid];

                for(int i = 0; i < (32/8); i++) begin
                    mask[i*8 +: 8] = s_vif.s_mon_cb.WSTRB[i] ? 8'hff : 8'h00;
                end

                masked_data = s_vif.s_mon_cb.WDATA & mask;
                w_trans.WDATA.push_back(masked_data);
                w_trans.WSTRB.push_back(s_vif.s_mon_cb.WSTRB);
                w_trans.WID = wid;

                if (s_vif.s_mon_cb.WLAST) begin
                    $cast(w_trans_copy, w_trans.clone());  
                    s_port.write(w_trans_copy);
                    void'(awid_q.pop_front());
                    get_id.delete(wid);
                end
            end
        end
  	endtask

	task read_addr_channel();
        int ctr;
		axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH) ar_trans;
		axi_s_seq_item #(ADDR_WIDTH, DATA_WIDTH) ar_trans_copy;
		forever begin
			@(s_vif.s_mon_cb iff (s_vif.s_mon_cb.ARVALID && s_vif.s_mon_cb.ARREADY));
			ar_trans         = new();
			ar_trans.kind_e  = READ;
			ar_trans.ARID    = s_vif.s_mon_cb.ARID;
			ar_trans.ARADDR  = s_vif.s_mon_cb.ARADDR;
			ar_trans.ARLEN   = s_vif.s_mon_cb.ARLEN;
			ar_trans.ARSIZE  = s_vif.s_mon_cb.ARSIZE;
			ar_trans.ARBURST = s_vif.s_mon_cb.ARBURST;

            $cast(ar_trans_copy, ar_trans.clone());  
            ctr++;
            $display("INIDE_SLAVE_MON_CTR=%0d", ctr);
            $display("arid in s mon : %0d", ar_trans.ARID);
			s_port.write(ar_trans_copy);
		end
  	endtask

endclass

`endif
