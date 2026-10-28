`ifndef AXI_OOO_INTERLEAVE_M_WSEQS_SV
`define AXI_OOO_INTERLEAVE_M_WSEQS_SV

class axi_ooo_interleave_m_wseqs #(int ADDR_WIDTH=32, DATA_WIDTH=32)
    extends axi_base_m_seqs #(ADDR_WIDTH, DATA_WIDTH);

    `uvm_object_param_utils(axi_ooo_interleave_m_wseqs #(ADDR_WIDTH, DATA_WIDTH))

    function new(string name = "axi_ooo_interleave_m_wseqs");
        super.new(name);
    endfunction

    task send_writes(int unsigned transfer_size);
        for (int unsigned i = 0; i < 4; i++) begin
            axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH) item;
            item = axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH)::type_id::create($sformatf("wr_%0d", i));
            start_item(item);
            assert(item.randomize() with {
                kind_e == axi_m_agent_pkg::WRITE;
                burst_kind_e == axi_m_agent_pkg::INCR;
                AWID == (i + 1);
                AWADDR == (32'h100 + i * 32);
                AWLEN == 3;
                AWSIZE == transfer_size;
            }) else `uvm_fatal("NARROW_TRANSFER", "Write randomization failed")
            finish_item(item);
        end
    endtask

    task send_reads(int unsigned transfer_size);
        for (int unsigned i = 0; i < 4; i++) begin
            axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH) item;
            item = axi_m_seq_item #(ADDR_WIDTH,DATA_WIDTH)::type_id::create($sformatf("rd_%0d", i));
            start_item(item);
            assert(item.randomize() with {
                kind_e == axi_m_agent_pkg::READ;
                burst_kind_e == axi_m_agent_pkg::INCR;
                ARID == (i + 1);
                ARADDR == (32'h100 + i * 32);
                ARLEN == 3;
                ARSIZE == transfer_size;
            }) else `uvm_fatal("NARROW_TRANSFER", "Read randomization failed")
            finish_item(item);
        end
    endtask

    task body();
        axi_env_cfg cfg;
        int unsigned transfer_size = 1;
        void'(uvm_config_db#(axi_env_cfg)::get(p_sequencer, "", "env_cfg_h", cfg));
        if (cfg != null && cfg.allow_narrow_transfer)
            transfer_size = cfg.narrow_transfer_size;

        fork
            send_writes(transfer_size);
            send_reads(transfer_size);
        join
        resp(4);
    endtask

endclass

`endif
