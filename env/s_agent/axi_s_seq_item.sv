`ifndef AXI_S_SEQ_ITEM_SV
`define AXI_S_SEQ_ITEM_SV

typedef enum bit[1:0]{FIXED, INCR, WRAP} burst_kind;
typedef enum bit[1:0]{IDLE, WRITE, READ} trans_kind;

class axi_s_seq_item#(int ADDR_WIDTH=32,DATA_WIDTH=32) extends uvm_sequence_item;

//----------------- WRITE ADDRESS -------------------//
    
    bit[(`ID-1):0]                     AWID;
    bit[(`ADDR_WIDTH-1):0]           AWADDR;
    bit[(`LEN-1):0]                   AWLEN;
    bit[(`SIZE-1):0]                 AWSIZE;
    bit[(`BURST-1):0]               AWBURST;

//----------------- WRITE DATA ----------------------//
    
    bit[(`ID-1):0]                      WID;
    bit[(`DATA_WIDTH-1):0]         WDATA[$];
    bit[(`STRB_WIDTH-1):0]         WSTRB[$];
    bit                               WLAST;

//----------------- WRITE RESPONSE ------------------//
    
    bit [(`ID-1):0]                     BID;
    bit [(`RESP-1):0]                 BRESP;

//----------------- READ ADDRESS --------------------//
    
    bit[(`ID-1):0]                     ARID;
    bit[(`ADDR_WIDTH-1):0]           ARADDR;
    bit[(`LEN-1):0]                   ARLEN;
    bit[(`SIZE-1):0]                 ARSIZE;
    bit[(`BURST-1):0]               ARBURST;

//----------------- READ DATA -----------------------//
    
    bit [(`ID-1):0]                     RID;
    bit [(`DATA_WIDTH-1):0]        RDATA[$];
    bit [(`RESP-1):0]                 RRESP;
    bit                               RLAST;

//----------------- ENUM HANDLE ---------------------//

     burst_kind burst_kind_e;
     trans_kind kind_e;

//---------------------------------------------------//    
//----------------- Factory Registration-------------//
//---------------------------------------------------//    

    `uvm_object_param_utils_begin(axi_s_seq_item #(ADDR_WIDTH,DATA_WIDTH))

//----------------- WRITE ADDRESS -------------------//
    `uvm_field_int(AWID,    UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(AWADDR,  UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(AWLEN,   UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(AWSIZE,  UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(AWBURST, UVM_ALL_ON | UVM_DEC)

//----------------- WRITE DATA ----------------------//
    
    `uvm_field_int      (WID,   UVM_ALL_ON | UVM_HEX)
    `uvm_field_queue_int(WDATA, UVM_ALL_ON | UVM_HEX)
    `uvm_field_queue_int(WSTRB, UVM_ALL_ON | UVM_BIN)
    `uvm_field_int      (WLAST, UVM_ALL_ON | UVM_DEC)

//----------------- WRITE RESPONSE ------------------//
    
    `uvm_field_int(BID,   UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(BRESP, UVM_ALL_ON | UVM_DEC)

//----------------- READ ADDRESS --------------------//
    
    `uvm_field_int(ARID,    UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(ARADDR,  UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(ARLEN,   UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(ARSIZE,  UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(ARBURST, UVM_ALL_ON | UVM_DEC)

//----------------- READ DATA -----------------------//
    
    `uvm_field_int      (RID,   UVM_ALL_ON | UVM_HEX)
    `uvm_field_queue_int(RDATA, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int      (RRESP, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int      (RLAST, UVM_ALL_ON | UVM_DEC)

//----------------- ENUM ----------------------------//

    `uvm_field_enum     (burst_kind, burst_kind_e, UVM_ALL_ON)
    `uvm_field_enum     (trans_kind, kind_e,       UVM_ALL_ON)
    
    `uvm_object_utils_end 

    function new(string name="axi_s_seq_item");
        super.new(name);
    endfunction

endclass

`endif

