// Brick Breaker Game with GAME OVER text rendering
module brick_breaker_game (
    input clk,
    input rst,
    input left_btn,
    input right_btn,
    input [9:0] x,
    input [9:0] y,
    input active_video,
    output reg [3:0] r, g, b
);

    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter PADDLE_WIDTH = 100;
    parameter PADDLE_HEIGHT = 10;
    parameter BALL_SIZE = 8;
    parameter BRICK_WIDTH = 64;
    parameter BRICK_HEIGHT = 20;
    parameter BRICK_ROWS = 5;
    parameter BRICK_COLS = 10;
    parameter BALL_SPEED_DIV = 400000;
    parameter PADDLE_SPEED_DIV = 200000;

    reg [9:0] paddle_x = (SCREEN_WIDTH - PADDLE_WIDTH) / 2;
    reg [9:0] ball_x = SCREEN_WIDTH / 2, ball_y = SCREEN_HEIGHT / 2;
    reg ball_dx = 1, ball_dy = 1;

    reg [20:0] ball_clk_counter = 0;
    reg ball_clk = 0;
    always @(posedge clk) begin
        ball_clk_counter <= ball_clk_counter + 1;
        if (ball_clk_counter >= BALL_SPEED_DIV) begin
            ball_clk_counter <= 0;
            ball_clk <= ~ball_clk;
        end
    end

    reg [20:0] paddle_clk_counter = 0;
    reg paddle_clk = 0;
    always @(posedge clk) begin
        paddle_clk_counter <= paddle_clk_counter + 1;
        if (paddle_clk_counter >= PADDLE_SPEED_DIV) begin
            paddle_clk_counter <= 0;
            paddle_clk <= ~paddle_clk;
        end
    end

    reg brick[0:BRICK_ROWS-1][0:BRICK_COLS-1];
    integer row, col, i;
    initial begin
        for (row = 0; row < BRICK_ROWS; row = row + 1)
            for (col = 0; col < BRICK_COLS; col = col + 1)
                brick[row][col] = 1;
    end

    reg game_over = 0;

    always @(posedge paddle_clk) begin
        if (!game_over) begin
            if (left_btn && paddle_x > 0)
                paddle_x <= paddle_x - 1;
            else if (right_btn && paddle_x < (SCREEN_WIDTH - PADDLE_WIDTH))
                paddle_x <= paddle_x + 1;
        end
    end

    always @(posedge ball_clk) begin
        if (rst) begin
            ball_x <= SCREEN_WIDTH / 2;
            ball_y <= SCREEN_HEIGHT / 2;
            ball_dx <= 1;
            ball_dy <= 1;
            game_over <= 0;
            for (row = 0; row < BRICK_ROWS; row = row + 1)
                for (col = 0; col < BRICK_COLS; col = col + 1)
                    brick[row][col] <= 1;
        end else if (!game_over) begin
            ball_x <= ball_x + (ball_dx ? 1 : -1);
            ball_y <= ball_y + (ball_dy ? 1 : -1);

            if (ball_x <= 0)
                ball_dx <= 1;
            else if (ball_x >= (SCREEN_WIDTH - BALL_SIZE))
                ball_dx <= 0;
            if (ball_y <= 0)
                ball_dy <= 1;

            if (ball_dy &&
                (ball_y + BALL_SIZE >= SCREEN_HEIGHT - 20) &&
                (ball_y + BALL_SIZE <= SCREEN_HEIGHT - 20 + BALL_SIZE) &&
                (ball_x + BALL_SIZE >= paddle_x) &&
                (ball_x <= paddle_x + PADDLE_WIDTH)) begin
                ball_dy <= 0;
                ball_dx <= (ball_x < paddle_x + PADDLE_WIDTH / 2) ? 0 : 1;
            end

            for (row = 0; row < BRICK_ROWS; row = row + 1)
                for (col = 0; col < BRICK_COLS; col = col + 1)
                    if (brick[row][col] &&
                        ball_y <= (row + 1) * BRICK_HEIGHT &&
                        ball_y + BALL_SIZE >= row * BRICK_HEIGHT &&
                        ball_x + BALL_SIZE >= col * BRICK_WIDTH &&
                        ball_x <= (col + 1) * BRICK_WIDTH) begin
                        brick[row][col] <= 0;
                        ball_dy <= ~ball_dy;
                    end

            if (ball_y > SCREEN_HEIGHT) begin
                game_over <= 1;
            end
        end
    end

    reg [7:0] game_over_text [0:8];
    initial begin
        game_over_text[0] = 8'h47; // G
        game_over_text[1] = 8'h41; // A
        game_over_text[2] = 8'h4D; // M
        game_over_text[3] = 8'h45; // E
        game_over_text[4] = 8'h20; // space
        game_over_text[5] = 8'h4F; // O
        game_over_text[6] = 8'h56; // V
        game_over_text[7] = 8'h45; // E
        game_over_text[8] = 8'h52; // R
    end

    reg [2:0] font_row;
    reg [3:0] font_col;
    reg [7:0] current_char;
    wire [7:0] font_row_pixels;

    font_rom font_inst (
        .char_code(current_char),
        .row(font_row),
        .row_pixels(font_row_pixels)
    );

    always @(*) begin
        r = 0; g = 0; b = 0;
        if (!active_video) begin
            r = 0; g = 0; b = 0;
        end else if (game_over) begin
            for (i = 0; i < 9; i = i + 1) begin
                if (x >= 200 + i * 10 && x < 200 + i * 10 + 8 &&
                    y >= 100 && y < 100 + 8) begin
                    font_row = y - 100;
                    font_col = x - (200 + i * 10);
                    current_char = game_over_text[i];
                    if (font_row_pixels[7 - font_col])
                        {r, g, b} = {4'd15, 4'd15, 4'd15};
                end
            end
        end else begin
            if (x >= paddle_x && x < paddle_x + PADDLE_WIDTH &&
                y >= SCREEN_HEIGHT - 20 && y < SCREEN_HEIGHT - 20 + PADDLE_HEIGHT)
                {r, g, b} = {4'd0, 4'd15, 4'd0};
            else if (x >= ball_x && x < ball_x + BALL_SIZE &&
                     y >= ball_y && y < ball_y + BALL_SIZE)
                {r, g, b} = {4'd15, 4'd15, 4'd0};
            else begin
                for (row = 0; row < BRICK_ROWS; row = row + 1)
                    for (col = 0; col < BRICK_COLS; col = col + 1)
                        if (brick[row][col] &&
                            x >= col * BRICK_WIDTH && x < (col + 1) * BRICK_WIDTH &&
                            y >= row * BRICK_HEIGHT && y < (row + 1) * BRICK_HEIGHT)
                            {r, g, b} = {4'd15, 4'd0, 4'd0};
            end
        end
    end

endmodule

// Font ROM for characters
module font_rom (
    input [7:0] char_code,
    input [2:0] row,
    output reg [7:0] row_pixels
);
    always @(*) begin
        case (char_code)
            8'h47: case (row) 0: row_pixels=8'b00111100;1:row_pixels=8'b01100010;2:row_pixels=8'b01000000;3:row_pixels=8'b01001110;4:row_pixels=8'b01000010;5:row_pixels=8'b01100010;6:row_pixels=8'b00111100;7:row_pixels=8'b00000000; endcase
            8'h41: case (row) 0: row_pixels=8'b00111000;1:row_pixels=8'b01000100;2:row_pixels=8'b10000010;3:row_pixels=8'b11111110;4:row_pixels=8'b10000010;5:row_pixels=8'b10000010;6:row_pixels=8'b10000010;7:row_pixels=8'b00000000; endcase
            8'h4D: case (row) 0: row_pixels=8'b10000001;1:row_pixels=8'b11000011;2:row_pixels=8'b10100101;3:row_pixels=8'b10011001;4:row_pixels=8'b10000001;5:row_pixels=8'b10000001;6:row_pixels=8'b10000001;7:row_pixels=8'b00000000; endcase
            8'h45: case (row) 0: row_pixels=8'b11111110;1:row_pixels=8'b10000000;2:row_pixels=8'b10000000;3:row_pixels=8'b11111100;4:row_pixels=8'b10000000;5:row_pixels=8'b10000000;6:row_pixels=8'b11111110;7:row_pixels=8'b00000000; endcase
            8'h4F: case (row) 0: row_pixels=8'b00111100;1:row_pixels=8'b01100110;2:row_pixels=8'b11000011;3:row_pixels=8'b11000011;4:row_pixels=8'b11000011;5:row_pixels=8'b01100110;6:row_pixels=8'b00111100;7:row_pixels=8'b00000000; endcase
            8'h56: case (row) 0: row_pixels=8'b10000001;1:row_pixels=8'b10000001;2:row_pixels=8'b10000001;3:row_pixels=8'b10000001;4:row_pixels=8'b01000010;5:row_pixels=8'b00100100;6:row_pixels=8'b00011000;7:row_pixels=8'b00000000; endcase
            8'h52: case (row) 0: row_pixels=8'b11111100;1:row_pixels=8'b10000010;2:row_pixels=8'b10000010;3:row_pixels=8'b11111100;4:row_pixels=8'b10010000;5:row_pixels=8'b10001000;6:row_pixels=8'b10000100;7:row_pixels=8'b00000000; endcase
            default: row_pixels = 8'b00000000;
        endcase
    end
endmodule
