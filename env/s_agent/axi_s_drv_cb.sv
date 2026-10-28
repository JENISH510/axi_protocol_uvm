`ifndef AXI_S_DRV_CB_SV
`define AXI_S_DRV_CB_SV

class axi_s_drv_cb #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_callback;
    `uvm_object_param_utils(axi_s_drv_cb #(ADDR_WIDTH, DATA_WIDTH))

    function new(string name="axi_s_drv_cb");
        super.new(name);
    endfunction

    virtual task before_transfer(
        virtual axi_s_inf#(ADDR_WIDTH,DATA_WIDTH).SDRV_MP vif,
        string channel,
        inout int unsigned transfer_count
    );
        transfer_count++;
        wait(vif.s_drv_cb.ARESETn);
    endtask

    virtual task get_ready(
        virtual axi_s_inf#(ADDR_WIDTH,DATA_WIDTH).SDRV_MP vif,
        string channel,
        output bit ready
    );
        ready = vif.s_drv_cb.ARESETn;
    endtask

    virtual task before_response(
        virtual axi_s_inf#(ADDR_WIDTH,DATA_WIDTH).SDRV_MP vif,
        string channel
    );
        wait(vif.s_drv_cb.ARESETn);
    endtask
endclass

`endif
