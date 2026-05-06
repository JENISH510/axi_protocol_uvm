`ifndef AXI_SEQ_ITEM_SV
`define AXI_SEQ_ITEM_SV

typedef enum bit[1:0]{FIXED, INCR, WRAP} burst_kind;
typedef enum bit[1:0]{IDLE, WRITE, READ} trans_kind;

class axi_m_seq_item #(int ADDR_WIDTH=32, DATA_WIDTH=32) extends uvm_sequence_item;

    //========================================================
    // WRITE ADDRESS CHANNEL (AW)
    //========================================================
    randc bit [(`ID-1)        :0] AWID;
    rand  bit [(`ADDR_WIDTH-1):0] AWADDR;
    rand  bit [(`LEN-1)       :0] AWLEN;
    rand  bit [(`SIZE-1)      :0] AWSIZE;
    rand  bit [(`BURST-1)     :0] AWBURST;

    //========================================================
    // WRITE DATA CHANNEL (W)
    //========================================================
    rand  bit [(`ID-1)        :0] WID;
    rand  bit [(`DATA_WIDTH-1):0] WDATA[$];
    rand  bit [(`STRB_WIDTH-1):0] WSTRB[$];
    rand  bit                     WLAST;

    //========================================================
    // WRITE RESPONSE CHANNEL (B)
    //========================================================
    bit [(`ID-1)  :0] BID;
    bit [(`RESP-1):0] BRESP;

    //========================================================
    // READ ADDRESS CHANNEL (AR)
    //========================================================
    randc bit [(`ID-1)        :0] ARID;
    rand  bit [(`ADDR_WIDTH-1):0] ARADDR;
    rand  bit [(`LEN-1)       :0] ARLEN;
    rand  bit [(`SIZE-1)      :0] ARSIZE;
    rand  bit [(`BURST-1)     :0] ARBURST;

    //========================================================
    // READ DATA CHANNEL (R)
    //========================================================
    bit [(`ID-1)        :0] RID;
    bit [(`DATA_WIDTH-1):0] RDATA[$];
    bit [(`RESP-1)      :0] RRESP;
    bit                     RLAST;

    //========================================================
    // TRANSACTION TYPE
    //========================================================
    rand burst_kind burst_kind_e;
    rand trans_kind kind_e;

    //========================================================
    // HELPER VARIABLES
    //========================================================
    rand int beat_size;
    rand int num_beats_w;
    rand int num_beats_r;

    //========================================================
    // FIELD AUTOMATION
    //========================================================
    `uvm_object_param_utils_begin(axi_m_seq_item #(ADDR_WIDTH, DATA_WIDTH))

        // AW
        `uvm_field_int(AWID,    UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(AWADDR,  UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(AWLEN,   UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(AWSIZE,  UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(AWBURST, UVM_ALL_ON | UVM_DEC)

        // W
        `uvm_field_int      (WID,   UVM_ALL_ON | UVM_HEX)
        `uvm_field_queue_int(WDATA, UVM_ALL_ON | UVM_HEX)
        `uvm_field_queue_int(WSTRB, UVM_ALL_ON | UVM_BIN)
        `uvm_field_int      (WLAST, UVM_ALL_ON | UVM_DEC)

        // B
        `uvm_field_int(BID,   UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(BRESP, UVM_ALL_ON | UVM_DEC)

        // AR
        `uvm_field_int(ARID,    UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(ARADDR,  UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(ARLEN,   UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(ARSIZE,  UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(ARBURST, UVM_ALL_ON | UVM_DEC)

        // R
        `uvm_field_int      (RID,   UVM_ALL_ON | UVM_HEX)
        `uvm_field_queue_int(RDATA, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int      (RRESP, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int      (RLAST, UVM_ALL_ON | UVM_DEC)

        // ENUM
        `uvm_field_enum(burst_kind, burst_kind_e, UVM_ALL_ON)
        `uvm_field_enum(trans_kind, kind_e,       UVM_ALL_ON)

    `uvm_object_utils_end

    // beat_size fixed to DATA_WIDTH/8
    constraint beat_size_c {
        beat_size == DATA_WIDTH / 8;
    }

    // AWSIZE/ARSIZE max = 2 (4 bytes) for 32-bit bus
    constraint size_c {
        AWSIZE inside {[0:3]};
        ARSIZE inside {[0:3]};
    }

    // AWLEN/ARLEN per burst type + num_beats helpers
    constraint len_c {
        solve burst_kind_e before AWLEN, ARLEN;
        if (burst_kind_e == FIXED) {
            AWLEN inside {[0:15]};
            ARLEN inside {[0:15]};
        }
        if (burst_kind_e == INCR) {
            AWLEN inside {[0:255]};
            ARLEN inside {[0:255]};
        }
        if (burst_kind_e == WRAP) {
            AWLEN inside {1, 3, 7, 15};
            ARLEN inside {1, 3, 7, 15};
            AWADDR % (1 << AWSIZE) == 0;
          	AWADDR % ((AWLEN + 1)*(1 << AWSIZE)) == 0;
            //ARLEN == AWLEN;
        }
        num_beats_w == AWLEN + 1;
        num_beats_r == ARLEN + 1;
    }

    constraint burst_c {
        (burst_kind_e == FIXED) -> (AWBURST == 2'b00) && (ARBURST == 2'b00);
        (burst_kind_e == INCR)  -> (AWBURST == 2'b01) && (ARBURST == 2'b01);
        (burst_kind_e == WRAP)  -> (AWBURST == 2'b10) && (ARBURST == 2'b10);
    }

    constraint wdata_wstrb_size_c {
        solve AWLEN before WDATA, WSTRB;
        WDATA.size() == num_beats_w;
        WSTRB.size() == num_beats_w;
    }

    /*constraint rdata_size_c {
        solve ARLEN before RDATA;
        RDATA.size() == num_beats_r; // num_beats_r is ARLEN + 1
        //RRESP.size() == num_beats_r; // If RRESP is also an array in your implementation
    }*/

    constraint wstrb_c {
        solve AWADDR, beat_size before WSTRB;
        foreach (WSTRB[i]) {
            if (i == 0)
                WSTRB[i] == (4'hf << (AWADDR % beat_size));
            else
                WSTRB[i] == 4'hf;
        }
    }
            
    function new(string name="axi_m_seq_item");
        super.new(name);
    endfunction

endclass

`endif
