`ifndef AXI_COVERAGE_SV
`define AXI_COVERAGE_SV

class axi_coverage;

    axi_m_seq_item m_trans;
    axi_s_seq_item s_trans;

    covergroup write_cov;

        cp_awburst : coverpoint m_trans.AWBURST {
            bins fixed = {2'b00};
            bins incr  = {2'b01};
            bins wrap  = {2'b10};
        }

        cp_awlen : coverpoint m_trans.AWLEN {
            bins single       = {8'd0};
            bins short_burst  = {[8'd1   : 8'd15]};
            bins medium_burst = {[8'd16  : 8'd63]};
            bins long_burst   = {[8'd64  : 8'd127]};
            bins max_burst    = {[8'd128 : 8'd255]};
        }

        cp_awsize : coverpoint m_trans.AWSIZE {
            bins size_2 = {3'd2};
            bins size_3 = {3'd3};
        }

        cp_awid : coverpoint m_trans.AWID {
            bins min_id      = {16'h0000};
            bins max_id      = {16'hFFFF};
            bins mid_ids[14] = {[16'h0001 : 16'hFFFE]};
        }

        cp_awaddr : coverpoint m_trans.AWADDR {
            bins min_addr   = {32'h0000_0000};
            bins max_addr   = {32'hFFFF_FFFF};
            bins low_range  = {[32'h0000_0001 : 32'h0000_FFFF]};
            bins mid_range  = {[32'h0001_0000 : 32'hEFFF_FFFF]};
            bins high_range = {[32'hF000_0000 : 32'hFFFE_FFFF]};
        }

        cp_wdata : coverpoint m_trans.WDATA {
            bins all_zeros   = {32'h0000_0000};
            bins all_ones    = {32'hFFFF_FFFF};
            bins toggle_01   = {32'h5555_5555, 32'hAAAA_AAAA};
            bins other_data[4] = {[32'h0000_0001 : 32'hFFFE_FFFF]};
        }

        cp_trans_kind_m : coverpoint m_trans.kind_e {
            bins write = {axi_m_agent_pkg::WRITE};
        }

        cp_wid : coverpoint m_trans.WID {
            bins min_id      = {16'h0000};
            bins max_id      = {16'hFFFF};
            bins mid_ids[14] = {[16'h0001 : 16'hFFFE]};
        }

        cp_bid : coverpoint m_trans.BID {
            bins min_id      = {16'h0000};
            bins max_id      = {16'hFFFF};
            bins mid_ids[14] = {[16'h0001 : 16'hFFFE]};
        }

        cp_wstrb : coverpoint m_trans.WSTRB {
            bins no_byte     = {4'h0};
            bins single_byte = {4'h8,4'hc,4'he};
            bins all_bytes   = {4'hF};
            bins default_bin = default; 
        }

        //ID_CP : cross cp_awid, cp_wid;
        //ID_CP1 : cross cp_wid, cp_bid;

        ADDR_DATA_CP  : cross cp_awaddr, cp_wdata;
        
        ADDR_BURST_CP : cross cp_awaddr, cp_awburst;
        
        DATA_BURST_CP : cross cp_wdata, cp_awburst;

        BURST_LEN_SIZE_CP : cross cp_awburst, cp_awlen {
            ignore_bins invalid_wrap = binsof(cp_awburst.wrap) && 
                                       (binsof(cp_awlen.medium_burst) || binsof(cp_awlen.long_burst) || binsof(cp_awlen.max_burst)) || binsof(cp_awlen.single);

            ignore_bins invalid_fixed = binsof(cp_awburst.fixed) &&
                                        (binsof(cp_awlen.medium_burst) || binsof(cp_awlen.long_burst) || binsof(cp_awlen.max_burst));
        }

        STRB_CP : cross cp_awburst, cp_wstrb {
            ignore_bins invalid_wrap = binsof(cp_awburst.wrap) &&
                                       (binsof(cp_wstrb.no_byte) || binsof(cp_wstrb.single_byte));

            ignore_bins invalid_incr = binsof(cp_awburst.wrap) &&
                                       binsof(cp_wstrb.no_byte);
        }

    endgroup

    covergroup read_cov;

        cp_arburst : coverpoint m_trans.ARBURST {
            bins fixed = {2'b00};
            bins incr  = {2'b01};
            bins wrap  = {2'b10};
        }

        cp_arlen : coverpoint m_trans.ARLEN {
            bins single       = {8'd0};
            bins short_burst  = {[8'd1   : 8'd15]};
            bins medium_burst = {[8'd16  : 8'd63]};
            bins long_burst   = {[8'd64  : 8'd127]};
            bins max_burst    = {[8'd128 : 8'd255]};
        }

        cp_arsize : coverpoint m_trans.ARSIZE {
            bins size_2 = {3'd2};
            bins size_3 = {3'd3};
        }

        cp_arid : coverpoint m_trans.ARID {
            bins min_id      = {16'h0000};
            bins max_id      = {16'hFFFF};
            bins mid_ids[14] = {[16'h0001 : 16'hFFFE]};
        }

        cp_araddr : coverpoint m_trans.ARADDR {
            bins min_addr   = {32'h0000_0000};
            bins max_addr   = {32'hFFFF_FFFF};
            bins low_range  = {[32'h0000_0001 : 32'h0000_FFFF]};
            bins mid_range  = {[32'h0001_0000 : 32'hEFFF_FFFF]};
            bins high_range = {[32'hF000_0000 : 32'hFFFE_FFFF]};
        }

        cp_rdata : coverpoint m_trans.RDATA {
            bins all_zeros   = {32'h0000_0000};
            bins all_ones    = {32'hFFFF_FFFF};
            bins toggle_01   = {32'h5555_5555, 32'hAAAA_AAAA};
            bins other_data[4] = {[32'h0000_0001 : 32'hFFFE_FFFF]};
        }

        cp_rid : coverpoint s_trans.RID {
            bins min_id      = {16'h0000};
            bins max_id      = {16'hFFFF};
            bins mid_ids[14] = {[16'h0001 : 16'hFFFE]};
        }

        cp_wrap_len : coverpoint m_trans.AWLEN {
            bins wrap_1  = {8'd1};
            bins wrap_3  = {8'd3};
            bins wrap_7  = {8'd7};
            bins wrap_15 = {8'd15};
        }

        cp_trans_kind_s : coverpoint m_trans.kind_e {
            bins read  = {axi_m_agent_pkg::READ};
        }

        //IC_CP : cross cp_arid, cp_rid;

        ADDR_DATA_CP  : cross cp_araddr, cp_rdata;
        
        ADDR_BURST_CP : cross cp_araddr, cp_arburst;
        
        DATA_BURST_CP : cross cp_rdata, cp_arburst;

        BURST_LEN_SIZE_CP : cross cp_arburst, cp_arlen{
            ignore_bins invalid_wrap = binsof(cp_arburst.wrap) && 
                                       (binsof(cp_arlen.medium_burst) || binsof(cp_arlen.long_burst) || binsof(cp_arlen.max_burst));

            ignore_bins invalid_fixed = binsof(cp_arburst.fixed) &&
                                        (binsof(cp_arlen.medium_burst) || binsof(cp_arlen.long_burst) || binsof(cp_arlen.max_burst));
        }

    endgroup

    function new();
        m_trans = new("m_trans");
        s_trans = new("s_trans");
        write_cov = new();
        read_cov = new();
    endfunction

    function void write_func(axi_m_seq_item req);
        this.m_trans = req;
        write_cov.sample();
    endfunction

    function void read_func(axi_s_seq_item req);
        this.s_trans = req;
        read_cov.sample();
    endfunction

endclass

`endif
