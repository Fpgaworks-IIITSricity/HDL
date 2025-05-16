module font_rom (
    input [7:0] char_code,
    input [2:0] row,
    output reg [7:0] row_pixels
);
    always @(*) begin
        case (char_code)
            // G
            8'h47: case (row)
                0: row_pixels = 8'b00111100;
                1: row_pixels = 8'b01100010;
                2: row_pixels = 8'b01000000;
                3: row_pixels = 8'b01001110;
                4: row_pixels = 8'b01000010;
                5: row_pixels = 8'b01100010;
                6: row_pixels = 8'b00111100;
                7: row_pixels = 8'b00000000;
            endcase
            // A
            8'h41: case (row)
                0: row_pixels = 8'b00111000;
                1: row_pixels = 8'b01000100;
                2: row_pixels = 8'b10000010;
                3: row_pixels = 8'b11111110;
                4: row_pixels = 8'b10000010;
                5: row_pixels = 8'b10000010;
                6: row_pixels = 8'b10000010;
                7: row_pixels = 8'b00000000;
            endcase
            // M
            8'h4D: case (row)
                0: row_pixels = 8'b10000001;
                1: row_pixels = 8'b11000011;
                2: row_pixels = 8'b10100101;
                3: row_pixels = 8'b10011001;
                4: row_pixels = 8'b10000001;
                5: row_pixels = 8'b10000001;
                6: row_pixels = 8'b10000001;
                7: row_pixels = 8'b00000000;
            endcase
            // E
            8'h45: case (row)
                0: row_pixels = 8'b11111110;
                1: row_pixels = 8'b10000000;
                2: row_pixels = 8'b10000000;
                3: row_pixels = 8'b11111100;
                4: row_pixels = 8'b10000000;
                5: row_pixels = 8'b10000000;
                6: row_pixels = 8'b11111110;
                7: row_pixels = 8'b00000000;
            endcase
            // O
            8'h4F: case (row)
                0: row_pixels = 8'b00111100;
                1: row_pixels = 8'b01100110;
                2: row_pixels = 8'b11000011;
                3: row_pixels = 8'b11000011;
                4: row_pixels = 8'b11000011;
                5: row_pixels = 8'b01100110;
                6: row_pixels = 8'b00111100;
                7: row_pixels = 8'b00000000;
            endcase
            // V
            8'h56: case (row)
                0: row_pixels = 8'b10000001;
                1: row_pixels = 8'b10000001;
                2: row_pixels = 8'b10000001;
                3: row_pixels = 8'b10000001;
                4: row_pixels = 8'b01000010;
                5: row_pixels = 8'b00100100;
                6: row_pixels = 8'b00011000;
                7: row_pixels = 8'b00000000;
            endcase
            // R
            8'h52: case (row)
                0: row_pixels = 8'b11111100;
                1: row_pixels = 8'b10000010;
                2: row_pixels = 8'b10000010;
                3: row_pixels = 8'b11111100;
                4: row_pixels = 8'b10010000;
                5: row_pixels = 8'b10001000;
                6: row_pixels = 8'b10000100;
                7: row_pixels = 8'b00000000;
            endcase
            default: row_pixels = 8'b00000000;
        endcase
    end
endmodule
