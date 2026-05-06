onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_tb_top/m_inf/ACLK
add wave -noupdate /axi_tb_top/m_inf/AWID
add wave -noupdate /axi_tb_top/m_inf/AWADDR
add wave -noupdate /axi_tb_top/m_inf/AWLEN
add wave -noupdate /axi_tb_top/m_inf/AWSIZE
add wave -noupdate /axi_tb_top/m_inf/AWBURST
add wave -noupdate /axi_tb_top/m_inf/AWVALID
add wave -noupdate /axi_tb_top/m_inf/AWREADY
add wave -noupdate /axi_tb_top/m_inf/WID
add wave -noupdate /axi_tb_top/m_inf/WDATA
add wave -noupdate /axi_tb_top/m_inf/WLAST
add wave -noupdate /axi_tb_top/m_inf/WSTRB
add wave -noupdate /axi_tb_top/m_inf/WVALID
add wave -noupdate /axi_tb_top/m_inf/WREADY
add wave -noupdate /axi_tb_top/m_inf/BID
add wave -noupdate /axi_tb_top/m_inf/BRESP
add wave -noupdate /axi_tb_top/m_inf/BVALID
add wave -noupdate /axi_tb_top/m_inf/BREADY
add wave -noupdate /axi_tb_top/m_inf/ARID
add wave -noupdate /axi_tb_top/m_inf/ARADDR
add wave -noupdate /axi_tb_top/m_inf/ARLEN
add wave -noupdate /axi_tb_top/m_inf/ARSIZE
add wave -noupdate /axi_tb_top/m_inf/ARBURST
add wave -noupdate /axi_tb_top/m_inf/ARVALID
add wave -noupdate /axi_tb_top/m_inf/ARREADY
add wave -noupdate /axi_tb_top/m_inf/RID
add wave -noupdate /axi_tb_top/m_inf/RDATA
add wave -noupdate /axi_tb_top/m_inf/RLAST
add wave -noupdate /axi_tb_top/m_inf/RRESP
add wave -noupdate /axi_tb_top/m_inf/RVALID
add wave -noupdate /axi_tb_top/m_inf/RREADY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1397 ns}
