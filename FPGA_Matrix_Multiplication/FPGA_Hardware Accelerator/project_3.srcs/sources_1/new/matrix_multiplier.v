module matrix_multiplier(
    input wire clk,
    output reg [7:0] result00,
    output reg [7:0] result01,
    output reg [7:0] result10,
    output reg [7:0] result11
);

    // Define 2x2 matrices (hardcoded values )
    reg [3:0] A00 = 4'd2, A01 = 4'd3;
    reg [3:0] A10 = 4'd1, A11 = 4'd4;

    reg [3:0] B00 = 4'd5, B01 = 4'd6;
    reg [3:0] B10 = 4'd7, B11 = 4'd8;

    always @(posedge clk) begin
        result00 <= (A00 * B00) + (A01 * B10);
        result01 <= (A00 * B01) + (A01 * B11);
        result10 <= (A10 * B00) + (A11 * B10);
        result11 <= (A10 * B01) + (A11 * B11);
    end

endmodule
