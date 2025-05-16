transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85" -l xpm -l xil_defaultlib \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  -incr \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85" -l xpm -l xil_defaultlib \
"../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85/clk_wiz_85_clk_wiz.v" \
"../../../brick breaker_basys3.gen/sources_1/ip/clk_wiz_85/clk_wiz_85.v" \
"../../../brick breaker_basys3.srcs/sources_1/new/brick_breaker_game.v" \
"../../../brick breaker_basys3.srcs/sources_1/new/vga_controller.v" \
"../../../brick breaker_basys3.srcs/sources_1/new/top.v" \

vlog -work xil_defaultlib \
"glbl.v"

