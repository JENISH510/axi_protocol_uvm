`ifndef AXI_M_INF_SV
`define AXI_M_INF_SV

interface axi_m_inf #(int ADDR_WIDTH=32,DATA_WIDTH=32) (input bit ACLK);

    logic ARESETn;

    //write address channel signals
    logic [(`ID-1):0]          AWID;
    logic [(`ADDR_WIDTH-1):0]  AWADDR;
    logic [(`LEN-1):0]         AWLEN;
    logic [(`SIZE-1):0]        AWSIZE;
    logic [(`BURST-1):0]       AWBURST;
    logic                      AWVALID;
    logic                      AWREADY;

    //write data channel signals
    logic [(`DATA_WIDTH-1):0]  WDATA;
    logic [(`STRB_WIDTH-1):0]  WSTRB;
    logic [(`ID-1):0]          WID;
    logic                      WLAST;
    logic                      WVALID;
    logic                      WREADY;

    //response channel signals
    logic [(`ID-1):0]          BID;
    logic [(`RESP-1):0]        BRESP;
    logic                      BVALID;
    logic                      BREADY;

    //Read address channel signal
    logic [(`ID-1):0]          ARID;
    logic [(`ADDR_WIDTH-1):0]  ARADDR;
    logic [(`LEN-1):0]         ARLEN;
    logic [(`SIZE-1):0]        ARSIZE;
    logic [(`BURST-1):0]       ARBURST;
    logic                      ARVALID;
    logic                      ARREADY;

    //Read data channel signal
    logic [(`ID-1):0]          RID;
    logic [(`DATA_WIDTH-1):0]  RDATA;
    logic [(`RESP-1):0]        RRESP;
    logic                      RLAST;
    logic                      RVALID;
    logic                      RREADY;

    //Driver clocking block

    clocking m_drv_cb @(posedge ACLK);
        default input #1 output #1;
        input ARESETn,
              AWREADY,
              WREADY,                                           
              BID,BRESP,BVALID,                                 
              ARREADY,                                          
              RID,RDATA,RRESP,RLAST,RVALID;                     
    
        output AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID,        
               WID,WDATA,WSTRB,WLAST,WVALID,                    
               BREADY,                                          
               ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID,        
               RREADY; 

    endclocking

    //Monitor clocking block
    
    clocking m_mon_cb @(posedge ACLK);
        default input #1 output #1;
        input ARESETn,
              AWREADY,                                       
              WREADY,                                        
              BID,BRESP,BVALID,                              
              ARREADY,                                       
              RID,RDATA,RRESP,RLAST,RVALID,                  

              AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID,      
              WID,WDATA,WSTRB,WLAST,WVALID,                  
              BREADY,                                        
              ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID,      
              RREADY;

    endclocking

    //Modports of Driver and Monitor

    modport MDRV_MP (clocking m_drv_cb);
    modport MMON_MP (clocking m_mon_cb);

    property p_stable_awvalid;
        @(posedge ACLK) disable iff (!ARESETn)
        (AWVALID && !AWREADY) |=> AWVALID;
    endproperty

    property p_stable_wvalid;
        @(posedge ACLK) disable iff (!ARESETn)
        (WVALID && !WREADY) |=> WVALID;
    endproperty

    property p_stable_bvalid;
        @(posedge ACLK) disable iff (!ARESETn)
        (BVALID && !BREADY) |=> BVALID;
    endproperty

    property p_stable_arvalid;
        @(posedge ACLK) disable iff (!ARESETn)
        (ARVALID && !ARREADY) |=> ARVALID;
    endproperty

    property p_stable_rvalid;
        @(posedge ACLK) disable iff (!ARESETn)
        (RVALID && !RREADY) |=> RVALID;
    endproperty

    ASSERT_STABLE_AWVALID : assert property(p_stable_awvalid)
        else
            $error("AWVALID NOT STABLE");

    ASSERT_STABLE_WVALID : assert property(p_stable_wvalid)
        else
            $error("AWVALID NOT STABLE");

    ASSERT_STABLE_BVALID : assert property(p_stable_bvalid)
        else
            $error("BVALID NOT STABLE");

    ASSERT_STABLE_ARVALID : assert property(p_stable_arvalid)
        else
            $error("ARVALID NOT STABLE");

    ASSERT_STABLE_RVALID : assert property(p_stable_rvalid)
        else
            $error("RVALID NOT STABLE");
endinterface

`endif

