module normal_matrix_multiplier(
    input wire clk,
    output reg [7:0] result00,
    output reg [7:0] result01,
    output reg [7:0] result10,
    output reg [7:0] result11
);

    reg [3:0] A [0:1][0:1];
    reg [3:0] B [0:1][0:1];
    reg [1:0] state = 0;

    initial begin
        A[0][0] = 4'd2; A[0][1] = 4'd3;
        A[1][0] = 4'd1; A[1][1] = 4'd4;

        B[0][0] = 4'd5; B[0][1] = 4'd6;
        B[1][0] = 4'd7; B[1][1] = 4'd8;
    end

    always @(posedge clk) begin
        case (state)
            0: result00 <= (A[0][0] * B[0][0]) + (A[0][1] * B[1][0]);
            1: result01 <= (A[0][0] * B[0][1]) + (A[0][1] * B[1][1]);
            2: result10 <= (A[1][0] * B[0][0]) + (A[1][1] * B[1][0]);
            3: result11 <= (A[1][0] * B[0][1]) + (A[1][1] * B[1][1]);
        endcase
        state <= state + 1;
    end
endmodule