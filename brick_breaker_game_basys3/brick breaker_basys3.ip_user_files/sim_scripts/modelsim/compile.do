vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85" \
"../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85/clk_wiz_85_clk_wiz.v" \
"../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85/clk_wiz_85.v" \
"../../../brick breaker_basys3.srcs/sources_1/new/brick_breaker_game.v" \
"../../../brick breaker_basys3.srcs/sources_1/new/vga_controller.v" \
"../../../brick breaker_basys3.srcs/sources_1/new/top.v" \

vlog -work xil_defaultlib \
"glbl.v"

