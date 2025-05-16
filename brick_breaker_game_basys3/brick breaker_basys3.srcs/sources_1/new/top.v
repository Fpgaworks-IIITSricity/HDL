module top(
    input clk,             // 100 MHz input clock from Edge Artix-7 board
    input rst,             // Reset button
    input left_btn,        // Move paddle left
    input right_btn,       // Move paddle right
    output [3:0] vga_r,    // VGA Red
    output [3:0] vga_g,    // VGA Green
    output [3:0] vga_b,    // VGA Blue
    output vga_hsync,      // VGA horizontal sync
    output vga_vsync       // VGA vertical sync
);

    // Wires for VGA timing
    wire clk_85MHz;
    wire [9:0] x;
    wire [9:0] y;
    wire active_video;

    // === Clock Wizard Instance ===
    // Make sure you generated clk_wiz_85 using Vivado's IP Catalog
    clk_wiz_85 clkgen (
        .clk_in1(clk),        // 100 MHz input
        .clk_out1(clk_85MHz)  // 85 MHz output
        // if you enabled .reset or .locked ports in the IP, add them here
    );

    // === VGA Timing Controller ===
    vga_controller vga_inst (
        .clk(clk_85MHz),
        .rst(rst),
        .x(x),
        .y(y),
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .active_video(active_video)
    );

    // === Game Logic (Brick Breaker) ===
    brick_breaker_game game_inst (
        .clk(clk_85MHz),
        .rst(rst),
        .left_btn(left_btn),
        .right_btn(right_btn),
        .x(x),
        .y(y),
        .active_video(active_video),
        .r(vga_r),
        .g(vga_g),
        .b(vga_b)
    );

endmodule
