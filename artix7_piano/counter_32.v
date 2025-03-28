`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 11:32:11
// Design Name: 
// Module Name: counter_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter_32(
    input clk,en,rst,
    output  reg [32:0] q
    );
    reg clkd;
    reg [31:0] div;
    always @(posedge clk)
    begin
    div<=div+1;
    clkd<=div[25];
    end
    always @(posedge clkd) begin
    if(rst) 
      q<=32'b0;
    else if (en)
       q<=q+1;
    else 
       q<=q-1;
       end
    
endmodule
