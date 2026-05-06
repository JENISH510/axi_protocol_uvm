`ifndef AXI_COVERAGE_SV
`define AXI_COVERAGE_SV

class axi_coverage;

    axi_m_seq_item m_trans;
    axi_s_seq_item s_trans;

    covergroup write_cov;

        cp_awburst : coverpoint m_trans.burst_kind_e {
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

        cp_awid : coverpoint m_trans.AWID {
            bins id[] = {[0 : 15]};
        }

        cp_trans_kind_m : coverpoint m_trans.kind_e {
            //bins idle  = {axi_m_agent_pkg::IDLE};
            bins write = {axi_m_agent_pkg::WRITE};
            bins read  = {axi_m_agent_pkg::READ};
        }

        cp_wid : coverpoint m_trans.WID {
            bins id[] = {[0:15]};
        }

        cp_bid : coverpoint s_trans.BID {
            bins id[] = {[0:15]};
        }

        ID_CP : cross cp_awid, cp_wid, cp_bid;

        BURST_CP : cross cp_awburst, cp_awlen;
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

        cp_arid : coverpoint m_trans.ARID {
            bins id[] = {[0 : 15]};
        }

        cp_wrap_len : coverpoint m_trans.AWLEN {
            bins wrap_1  = {8'd1};
            bins wrap_3  = {8'd3};
            bins wrap_7  = {8'd7};
            bins wrap_15 = {8'd15};
        }

        cp_trans_kind_s : coverpoint m_trans.kind_e {
            bins idle  = {axi_m_agent_pkg::IDLE};
            bins write = {axi_m_agent_pkg::WRITE};
            bins read  = {axi_m_agent_pkg::READ};
        }

        cp_rid : coverpoint m_trans.RID {
            bins id[] = {[0:15]};
        }

        IC_CP : cross cp_arid, cp_rid;

        BURST_S_CP : cross cp_arburst, cp_arlen;

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


