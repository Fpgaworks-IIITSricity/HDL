## Clock: try pin W5 (common for Artix-7 boards)
set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports { clk}];
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports {txd}];

## UART TX: fallback pin A18
set_property PACKAGE_PIN A18 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]

## Reset: fallback pin U18
set_property PACKAGE_PIN U18 [get_ports reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports reset_n]
