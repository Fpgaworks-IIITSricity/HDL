# Clock input
set_property PACKAGE_PIN N11 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# 7-segment display segment pins
set_property PACKAGE_PIN G2 [get_ports {seg[0]}]
set_property PACKAGE_PIN G1 [get_ports {seg[1]}]
set_property PACKAGE_PIN H5 [get_ports {seg[2]}]
set_property PACKAGE_PIN H4 [get_ports {seg[3]}]
set_property PACKAGE_PIN J5 [get_ports {seg[4]}]
set_property PACKAGE_PIN J4 [get_ports {seg[5]}]
set_property PACKAGE_PIN H2 [get_ports {seg[6]}]

# 7-segment anode pins
set_property PACKAGE_PIN F2 [get_ports {an[0]}]
set_property PACKAGE_PIN E1 [get_ports {an[1]}]
set_property PACKAGE_PIN G5 [get_ports {an[2]}]
set_property PACKAGE_PIN G4 [get_ports {an[3]}]

# Switch input to select between accelerator and normal multiplier
set_property PACKAGE_PIN L5 [get_ports sel]
set_property IOSTANDARD LVCMOS33 [get_ports sel]

# Apply IOSTANDARD to all 7-segment pins
set_property IOSTANDARD LVCMOS33 [get_ports seg[*]]
set_property IOSTANDARD LVCMOS33 [get_ports an[*]]
