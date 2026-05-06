`ifndef AXI_SB_SV
`define AXI_SB_SV

`uvm_analysis_imp_decl(_m)
`uvm_analysis_imp_decl(_ref)

class axi_sb extends uvm_scoreboard;
    `uvm_component_utils(axi_sb)

    uvm_analysis_imp_m   #(axi_m_seq_item, axi_sb) anl_imp_m;
    uvm_analysis_imp_ref #(axi_s_seq_item, axi_sb) anl_imp_ref;

    axi_s_seq_item exp_q[int][$];
    axi_m_seq_item act_q[int][$];
    int rid_q[$];

    event data_get;  
    int pass, fail;

    axi_coverage cov;

    function new(string name="axi_sb", uvm_component parent);
        super.new(name, parent);
        anl_imp_m   = new("anl_imp_m", this);
        anl_imp_ref = new("anl_imp_ref", this);
        cov         = new();
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            check_data();
        join_none
    endtask

    function void write_m(axi_m_seq_item req);
        if(req.kind_e == axi_m_agent_pkg::READ) begin
            cov.write_func(req);
            act_q[req.RID].push_back(req);
            rid_q.push_back(req.RID);
            ->data_get;  
        end
    endfunction

    function void write_ref(axi_s_seq_item req);
        if(req.kind_e == axi_s_agent_pkg::READ) begin
             cov.read_func(req); 
             exp_q[req.RID].push_back(req);
             //->data_get;
        end
    endfunction

    task check_data();
        axi_m_seq_item act;
        axi_s_seq_item exp;
        int rid;
		
        forever begin
            `uvm_info("before event in sb","aaaa",UVM_MEDIUM)
            @(data_get); 
            `uvm_info("after event in sb","aaaa",UVM_MEDIUM)
            
            if (rid_q.size() > 0) begin
                rid = rid_q.pop_front();

                if(act_q.exists(rid) && act_q[rid].size() > 0 && 
                   exp_q.exists(rid) && exp_q[rid].size() > 0) begin
                   
                    act = act_q[rid].pop_front();
                    exp = exp_q[rid].pop_front();
                    
                    if (act.RDATA == exp.RDATA) begin
  pass++;
  `uvm_info("SB MATCH",
            $sformatf("ARID=%0d RID=%0d MATCH! RDATA=%0p (Passes: %0d)",
                      act.ARID, rid, act.RDATA, pass),
            UVM_LOW)
end
else begin
  fail++;
  `uvm_error("SB MISMATCH",
             $sformatf("ARID=%0d RID=%0d Mismatch! ACT=%0p EXP=%0p (Fails: %0d)",
                       act.ARID, rid, act.RDATA, exp.RDATA, fail))
end
                    if(act_q[rid].size() == 0) act_q.delete(rid);
                    if(exp_q[rid].size() == 0) exp_q.delete(rid);
                end
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        if (pass > 0 && fail == 0) begin
            $display("");
            $display("##############################################################");
            $display("#                                                            #");
            $display("#   PPPPPPPP    AAA     SSSSSS    SSSSSS                     #");
            $display("#   PP     PP  A   A   SS        SS                          #");
            $display("#   PPPPPPPP   AAAAA    SSSSS     SSSSS                      #");
            $display("#   PP         A   A        SS         SS                    #");
            $display("#   PP         A   A   SSSSSS    SSSSSS                      #");
            $display("#                                                            #");
            $display("##############################################################");
            $display("");
            `uvm_info("\nSCOREBOARD_SUMMARY", $sformatf("\n=== FINAL RESULTS ===\nTotal Pass = %0d\nTotal Fail = %0d", pass, fail), UVM_MEDIUM)
        end
        else begin
            $display("");
            $display("##############################################################");
            $display("#                                                            #");
            $display("#   FFFFFFFFF   AAAAAAA   IIIIIII   L         !!!  !!!  !!!  #");
            $display("#   FF         AA     AA     I      L         !!!  !!!  !!!  #");
            $display("#   FFFFFFFF   AAAAAAAAA     I      L         !!!  !!!  !!!  #");
            $display("#   FF         AA     AA     I      L                        #");
            $display("#   FF         AA     AA  IIIIIII   LLLLLLL   !!!  !!!  !!!  #");
            $display("#                                                            #");
            $display("##############################################################");
            $display("");
            `uvm_info("SCOREBOARD_SUMMARY", $sformatf("=== FINAL RESULTS ===\nTotal Pass = %0d\nTotal Fail = %0d", pass, fail), UVM_MEDIUM) 
        end
    endfunction
endclass
`endif
