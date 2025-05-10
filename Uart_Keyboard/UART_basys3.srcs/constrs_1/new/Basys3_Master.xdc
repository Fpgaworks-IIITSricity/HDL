## Basys3 Rev B - Top-Level Constraints (.xdc)
##
## To use: uncomment lines for the ports you actually use in your design,
##         and rename the get_ports identifiers to match your top-level port names.

# ------------------------------------------------------------------------------
# Clock input
# ------------------------------------------------------------------------------
set_property PACKAGE_PIN W5 [get_ports clk_fpga]
set_property IOSTANDARD LVCMOS33 [get_ports clk_fpga]
create_clock -period 10.00 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk_fpga]

# ------------------------------------------------------------------------------
# Switches (uncomment as needed)
# ------------------------------------------------------------------------------
## set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
## set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
## ... up to sw[15]

# ------------------------------------------------------------------------------
# LEDs (example: RxData[7:0])
# ------------------------------------------------------------------------------
set_property PACKAGE_PIN U16 [get_ports {RxData[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[0]}]
set_property PACKAGE_PIN E19 [get_ports {RxData[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[1]}]
set_property PACKAGE_PIN U19 [get_ports {RxData[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[2]}]
set_property PACKAGE_PIN V19 [get_ports {RxData[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[3]}]
set_property PACKAGE_PIN W18 [get_ports {RxData[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[4]}]
set_property PACKAGE_PIN U15 [get_ports {RxData[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[5]}]
set_property PACKAGE_PIN U14 [get_ports {RxData[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[6]}]
set_property PACKAGE_PIN V14 [get_ports {RxData[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[7]}]

# ------------------------------------------------------------------------------
# 7-Segment Display (uncomment if used)
# ------------------------------------------------------------------------------
## set_property PACKAGE_PIN W7  [get_ports {seg[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
## ... through seg[6], dp, and an[0]-an[3]

# ------------------------------------------------------------------------------
# Push-Buttons
# ------------------------------------------------------------------------------
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
## set_property PACKAGE_PIN T18 [get_ports btnU]
## set_property IOSTANDARD LVCMOS33 [get_ports btnU]
## ... btnL, btnR, btnD

# ------------------------------------------------------------------------------
# UART - USB-Serial Adapter
# ------------------------------------------------------------------------------
# FPGA RxD pin (board RX input) - must be constrained
set_property PACKAGE_PIN B18 [get_ports RxD]
set_property IOSTANDARD LVCMOS33 [get_ports RxD]
# FPGA TxD pin (board TX output - uncomment if driving TX)
## set_property PACKAGE_PIN A18 [get_ports RsTx]
## set_property IOSTANDARD LVCMOS33 [get_ports RsTx]

# ------------------------------------------------------------------------------
# Pmod Headers (uncomment per port used)
# ------------------------------------------------------------------------------
## JA[0] - PIN J1
## set_property PACKAGE_PIN J1 [get_ports {JA[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {JA[0]}]
## ... through JC, JB, and JXADC as needed

# ------------------------------------------------------------------------------
# VGA Connector (uncomment if using)
# ------------------------------------------------------------------------------
## set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[0]}]
## ... vgaRed[1-3], vgaGreen[0-3], vgaBlue[0-3], Hsync, Vsync

# ------------------------------------------------------------------------------
# Quad-SPI Flash (uncomment if using)
# ------------------------------------------------------------------------------
## set_property PACKAGE_PIN D18 [get_ports {QspiDB[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[0]}]
## ... QspiDB[1-3], QspiCSn

# ------------------------------------------------------------------------------
# Miscellaneous (PS2, XADC, etc.-uncomment if needed)
# ------------------------------------------------------------------------------
## set_property PACKAGE_PIN C17 [get_ports PS2Clk]
## set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
## set_property PULLUP true     [get_ports PS2Clk]
## set_property PACKAGE_PIN B17 [get_ports PS2Data]
## set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]
## set_property PULLUP true     [get_ports PS2Data]
