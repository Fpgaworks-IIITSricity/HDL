module top_compare(
    input wire clk,
    input wire sel, // 0 = accelerator, 1 = normal multiplier
    output wire [6:0] seg,
    output wire [3:0] an
);

    wire [7:0] acc00, acc01, acc10, acc11;
    wire [7:0] norm00, norm01, norm10, norm11;

    matrix_multiplier acc(
        .clk(clk),
        .result00(acc00),
        .result01(acc01),
        .result10(acc10),
        .result11(acc11)
    );

    normal_matrix_multiplier norm(
        .clk(clk),
        .result00(norm00),
        .result01(norm01),
        .result10(norm10),
        .result11(norm11)
    );

    seven_seg_display display(
        .clk(clk),
        .val0(sel ? norm00 : acc00),
        .val1(sel ? norm01 : acc01),
        .val2(sel ? norm10 : acc10),
        .val3(sel ? norm11 : acc11),
        .seg(seg),
        .an(an)
    );

endmodule

