module testbench();
    reg clk = 0;
    reg sel = 0;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the top-level comparison module
    top_compare uut (
        .clk(clk),
        .sel(sel),
        .seg(seg),
        .an(an)
    );

    // Clock: 100 MHz (10 ns period)
    always #5 clk = ~clk;

    // Separate wires to monitor internals
    wire [7:0] acc00 = uut.acc.result00;
    wire [7:0] acc01 = uut.acc.result01;
    wire [7:0] acc10 = uut.acc.result10;
    wire [7:0] acc11 = uut.acc.result11;

    wire [7:0] norm00 = uut.norm.result00;
    wire [7:0] norm01 = uut.norm.result01;
    wire [7:0] norm10 = uut.norm.result10;
    wire [7:0] norm11 = uut.norm.result11;

    initial begin
        $dumpfile("matrix_compare.vcd");
        $dumpvars(0, testbench);

        // Phase 1: Accelerator mode
        sel = 0;
        #100;  // 100ns = 10 clock cycles

        // Phase 2: Normal multiplier mode
        sel = 1;
        #100;  // Observe normal multiplier progress over next 100ns

        $finish;
    end
endmodule

