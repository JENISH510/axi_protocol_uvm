`ifndef AXI_S_INF_SV
`define AXI_S_INF_SV

interface axi_s_inf #(int ADDR_WIDTH=32,DATA_WIDTH=32) (input bit ACLK);

    logic ARESETn;

    //write address channel signals
    logic [(`ID-1):0]          AWID;
    logic [(`ADDR_WIDTH-1):0]  AWADDR;
    logic [(`LEN-1):0]         AWLEN;
    logic [(`SIZE-1):0]        AWSIZE;
    logic [(`BURST-1):0]       AWBURST;
    logic                      AWVALID;
    logic                      AWREADY=1;

    //write data channel signals
    logic [(`DATA_WIDTH-1):0]  WDATA;
    logic [(`STRB_WIDTH-1):0]  WSTRB;
    logic [(`ID-1):0]          WID;
    logic                      WLAST;
    logic                      WVALID;
    logic                      WREADY=1;

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
    logic                      ARREADY=1;

    //Read data channel signal
    logic [(`ID-1):0]          RID;
    logic [(`DATA_WIDTH-1):0]  RDATA;
    logic [(`RESP-1):0]        RRESP;
    logic                      RLAST;
    logic                      RVALID;
    logic                      RREADY;

    //Driver clocking block

    clocking s_drv_cb @(posedge ACLK);
        default input #1 output #0;
        input AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID,        
              WID,WDATA,WSTRB,WLAST,WVALID,                    
              BREADY,                                          
              ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID,        
              RREADY; 
    
        output ARESETn,
               AWREADY,
               WREADY,                                           
               BID,BRESP,BVALID,                                 
               ARREADY,                                          
               RID,RDATA,RRESP,RLAST,RVALID;                     

    endclocking

    //Monitor clocking block
    
    clocking s_mon_cb @(posedge ACLK);
        default input #0 output #1;
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

    modport SDRV_MP (clocking s_drv_cb);
    modport SMON_MP (clocking s_mon_cb);

endinterface

`endif

