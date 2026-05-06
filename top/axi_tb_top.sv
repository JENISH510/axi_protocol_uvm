module axi_tb_top;
  // your original content
  import uvm_pkg::*;
    `include "uvm_macros.svh"
    import axi_test_pkg::*;
    //import axi_m_agent_pkg::*;
 
      //import axi_s_agent_pkg::*; 
      //import axi_env_pkg::*;
       //import axi_test_pkg::*;

    bit ACLK;

    //------------------------------------------------------------------
    //Take master and slave interface
    //------------------------------------------------------------------

 
    axi_m_inf m_inf(ACLK);
    axi_s_inf s_inf(ACLK);

    //------------------------------------------------------------------
    //Clock Generation
    //------------------------------------------------------------------
    
    initial begin
        ACLK = 0;
        forever
        #5 ACLK=~ACLK;
    end

    /*initial begin
        m_inf.ARESETn = 0;
        s_inf.ARESETn = 0;         // if s_inf also has ARESETn
        repeat(5) @(posedge ACLK); // hold reset for 5 cycles
        m_inf.ARESETn = 1;
        s_inf.ARESETn = 1;
    end*/
  
   //-------------------------------------------------------------------
   //assign master and slave interface
   //-------------------------------------------------------------------

   //Write address channel

    assign s_inf.AWID       = m_inf.AWID;
    assign s_inf.AWADDR     = m_inf.AWADDR;
    assign s_inf.AWLEN      = m_inf.AWLEN;
    assign s_inf.AWSIZE     = m_inf.AWSIZE;
    assign s_inf.AWBURST    = m_inf.AWBURST;
    assign s_inf.AWVALID    = m_inf.AWVALID;
    
    assign m_inf.AWREADY    = s_inf.AWREADY;

    //Write data channel

    assign s_inf.WID        = m_inf.WID;
    assign s_inf.WDATA      = m_inf.WDATA;
    assign s_inf.WSTRB      = m_inf.WSTRB;
    assign s_inf.WLAST      = m_inf.WLAST;
    assign s_inf.WVALID     = m_inf.WVALID;

    assign m_inf.WREADY     = s_inf.WREADY;

    //Write response channel

    assign m_inf.BID        = s_inf.BID;
    assign m_inf.BRESP      = s_inf.BRESP;
    assign m_inf.BVALID     = s_inf.BVALID;
    assign s_inf.BREADY     = m_inf.BREADY;

    //Read address channel

    assign s_inf.ARID       = m_inf.ARID;
    assign s_inf.ARADDR     = m_inf.ARADDR;
    assign s_inf.ARLEN      = m_inf.ARLEN;
    assign s_inf.ARSIZE     = m_inf.ARSIZE;
    assign s_inf.ARBURST    = m_inf.ARBURST;
    assign s_inf.ARVALID    = m_inf.ARVALID;
    
    assign m_inf.ARREADY    = s_inf.ARREADY;

    //Read data channel

    assign m_inf.RID        = s_inf.RID;
    assign m_inf.RDATA      = s_inf.RDATA;
    //assign m_inf.RSTRB      = s_inf.RSTRB;
    assign m_inf.RLAST      = s_inf.RLAST;
    assign m_inf.RVALID     = s_inf.RVALID;

    assign s_inf.RREADY     = m_inf.RREADY;

    //------------------------------------------------------------------
    //Set interface in config db
    //------------------------------------------------------------------

    initial begin
      uvm_config_db #(virtual axi_m_inf)::set(null,"*","m_vif",m_inf);
        uvm_config_db #(virtual axi_s_inf)::set(null,"*","s_vif",s_inf);

      run_test("");
    end
  
endmodule

