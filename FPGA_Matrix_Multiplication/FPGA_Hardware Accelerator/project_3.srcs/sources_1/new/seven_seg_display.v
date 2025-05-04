`timescale 1ns / 1ps
module seven_seg_display(
    input wire clk,
    input wire [7:0] val0,
    input wire [7:0] val1,
    input wire [7:0] val2,
    input wire [7:0] val3,
    output reg [3:0] an,     // Anode signals
    output reg [6:0] seg     // Cathode signals
);

    reg [1:0] refresh_counter = 0;
    reg [3:0] current_value;

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    always @(*) begin
        case (refresh_counter)
            2'b00: begin
                an = 4'b1110;
                current_value = val0[3:0];
            end
            2'b01: begin
                an = 4'b1101;
                current_value = val1[3:0];
            end
            2'b10: begin
                an = 4'b1011;
                current_value = val2[3:0];
            end
            2'b11: begin
                an = 4'b0111;
                current_value = val3[3:0];
            end
            default: begin
                an = 4'b1111;
                current_value = 4'b0000;
            end
        endcase
    end

    always @(*) begin
        case(current_value)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end

endmodule