`ifndef AXI_M_DRV_CB_SV
`define AXI_M_DRV_CB_SV

class axi_m_drv_cb #(int ADDR_WIDTH=32, int DATA_WIDTH=32) extends uvm_callback;
    `uvm_object_param_utils(axi_m_drv_cb #(ADDR_WIDTH, DATA_WIDTH))

    function new(string name="axi_m_drv_cb");
        super.new(name);
    endfunction

    virtual task before_transfer(
        virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH).MDRV_MP vif,
        string channel,
        inout int unsigned transfer_count
    );
        transfer_count++;
        wait(vif.m_drv_cb.ARESETn);
    endtask

    virtual task before_valid(
        virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH).MDRV_MP vif,
        string channel
    );
    endtask

    virtual task after_handshake(
        virtual axi_m_inf#(ADDR_WIDTH,DATA_WIDTH).MDRV_MP vif,
        string channel
    );
    endtask
endclass

`endif
