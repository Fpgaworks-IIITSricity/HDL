`timescale 1ns / 1ps

module vga_syncIndex (
    input clock,                    // 100 MHz clock on Basys 3
    input reset,
    input [7:0] val,               // Input to adjust brightness and filters
    input [3:0] sel_module,        // Select one of 16 functions
    output reg hsync,
    output reg vsync,
    output reg [3:0] red,          // 4-bit VGA outputs for Basys 3
    output reg [3:0] green,
    output reg [3:0] blue
);

    reg [7:0] gray, left, right, up, down, leftup, leftdown, rightup, rightdown; // Matrix values
    reg [7:0] red_o, blue_o, green_o;     // Calculation intermediates
    reg [15:0] r, b, g;                   // Calculation intermediates
    reg [7:0] tred, tgreen, tblue;        // Temporary RGB values

    reg clk;                              // Divided clock (~50 MHz)
    initial begin
        clk = 0;
    end
    always @(posedge clock) begin
        clk <= ~clk;
    end

    reg wea = 0;                          // Write enable (0 for ROM mode)
    reg [14:0] addra = 0;                 // 15-bit address (supports 18,400 depth)
    reg [95:0] in1 = 0;                   // Memory input data (unused for ROM)
    wire [95:0] out2;                     // 96-bit memory output

    // Block memory (ROM, 96-bit width, 18,400 depth)
    image inst1 (
        .clka(clk),                       // Input clock (~50 MHz)
        .wea(wea),                        // Write enable (0 for read-only)
        .addra(addra),                    // Address input (15 bits)
        .dina(in1),                       // Data input (unused)
        .douta(out2)                      // Data output (96 bits)
    );

    wire pixel_clk;                       // ~25 MHz for 640x480 @ 60 Hz
    reg pcount = 0;
    wire ec = (pcount == 0);
    always @(posedge clk) pcount <= ~pcount;
    assign pixel_clk = ec;

    reg hblank = 0, vblank = 0;
    initial begin
        hsync = 0;
        vsync = 0;
    end
    reg [9:0] hc = 0;                     // Horizontal counter
    reg [9:0] vc = 0;                     // Vertical counter

    // VGA timing signals for 640x480 @ 60 Hz
    wire hsyncon, hsyncoff, hreset, hblankon;
    assign hblankon = ec & (hc == 639);
    assign hsyncon = ec & (hc == 655);
    assign hsyncoff = ec & (hc == 751);
    assign hreset = ec & (hc == 799);

    wire blank = (vblank | (hblank & ~hreset));

    wire vsyncon, vsyncoff, vreset, vblankon;
    assign vblankon = hreset & (vc == 479);
    assign vsyncon = hreset & (vc == 490);
    assign vsyncoff = hreset & (vc == 492);
    assign vreset = hreset & (vc == 523);

    always @(posedge clk) begin
        hc <= ec ? (hreset ? 0 : hc + 1) : hc;
        hblank <= hreset ? 0 : hblankon ? 1 : hblank;
        hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync;

        vc <= hreset ? (vreset ? 0 : vc + 1) : vc;
        vblank <= vreset ? 0 : vblankon ? 1 : vblank;
        vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;
    end

    always @(posedge pixel_clk) begin
        if (blank == 0 && hc >= 100 && hc < 260 && vc >= 100 && vc < 215) begin
            // Extract pixel data from 96-bit memory output
            gray = {out2[95], out2[94], out2[93], out2[92], out2[91], out2[90], out2[89], out2[88]};
            left = {out2[87], out2[86], out2[85], out2[84], out2[83], out2[82], out2[81], out2[80]};
            right = {out2[79], out2[78], out2[77], out2[76], out2[75], out2[74], out2[73], out2[72]};
            up = {out2[71], out2[70], out2[69], out2[68], out2[67], out2[66], out2[65], out2[64]};
            down = {out2[63], out2[62], out2[61], out2[60], out2[59], out2[58], out2[57], out2[56]};
            leftup = {out2[55], out2[54], out2[53], out2[52], out2[51], out2[50], out2[49], out2[48]};
            leftdown = {out2[47], out2[46], out2[45], out2[44], out2[43], out2[42], out2[41], out2[40]};
            rightup = {out2[39], out2[38], out2[37], out2[36], out2[35], out2[34], out2[33], out2[32]};
            rightdown = {out2[31], out2[30], out2[29], out2[28], out2[27], out2[26], out2[25], out2[24]};
            tblue = {out2[23], out2[22], out2[21], out2[20], out2[19], out2[18], out2[17], out2[16]};
            tgreen = {out2[15], out2[14], out2[13], out2[12], out2[11], out2[10], out2[9], out2[8]};
            tred = {out2[7], out2[6], out2[5], out2[4], out2[3], out2[2], out2[1], out2[0]};

            // RGB to grayscale
            if (sel_module == 4'b0000) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    red_o = (tred >> 2) + (tred >> 5) + (tgreen >> 1) + (tgreen >> 4) + (tblue >> 4) + (tblue >> 5);
                    green_o = (tred >> 2) + (tred >> 5) + (tgreen >> 1) + (tgreen >> 4) + (tblue >> 4) + (tblue >> 5);
                    blue_o = (tred >> 2) + (tred >> 5) + (tgreen >> 1) + (tgreen >> 4) + (tblue >> 4) + (tblue >> 5);

                    red_o = red_o >> 4; // Divide by 16
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Increase brightness
            end else if (sel_module == 4'b0001) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = tred + val;
                    g = tgreen + val;
                    b = tblue + val;

                    red_o = (r > 255) ? 255 : r[7:0];
                    green_o = (g > 255) ? 255 : g[7:0];
                    blue_o = (b > 255) ? 255 : b[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Decrease brightness
            end else if (sel_module == 4'b0010) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = tred - val;
                    g = tgreen - val;
                    b = tblue - val;

                    red_o = (r[15] || r > 255) ? 0 : r[7:0];
                    green_o = (g[15] || g > 255) ? 0 : g[7:0];
                    blue_o = (b[15] || b > 255) ? 0 : b[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Color inversion
            end else if (sel_module == 4'b0011) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    red_o = 255 - tred;
                    green_o = 255 - tgreen;
                    blue_o = 255 - tblue;

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Red filter
            end else if (sel_module == 4'b0100) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = tred - val;
                    red_o = (r[15] || r > 255) ? 0 : r[7:0];
                    green_o = tgreen;
                    blue_o = tblue;

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Blue filter
            end else if (sel_module == 4'b0101) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    b = tblue - val;
                    red_o = tred;
                    green_o = tgreen;
                    blue_o = (b[15] || b > 255) ? 0 : b[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Green filter
            end else if (sel_module == 4'b0110) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    g = tgreen - val;
                    red_o = tred;
                    green_o = (g[15] || g > 255) ? 0 : g[7:0];
                    blue_o = tblue;

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Original image
            end else if (sel_module == 4'b0111) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    red_o = tred;
                    green_o = tgreen;
                    blue_o = tblue;

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Average blurring
            end else if (sel_module == 4'b1000) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (gray + left + right + up + down + leftup + leftdown + rightup + rightdown);
                    r = r / 9;

                    red_o = r[7:0];
                    green_o = r[7:0];
                    blue_o = r[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Sobel edge detection
            end else if (sel_module == 4'b1001) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (rightup - leftup + 2 * right - 2 * left + rightdown - leftdown);
                    g = (rightup + 2 * up + leftup - rightdown - 2 * down - leftdown);

                    if (r[15] && g[15]) begin
                        b = -(r + g) / 2;
                    end else if (r[15] && !g[15]) begin
                        b = (-r + g) / 2;
                    end else if (!r[15] && !g[15]) begin
                        b = (r + g) / 2;
                    end else begin
                        b = (r - g) / 2;
                    end

                    red_o = b[7:0];
                    green_o = b[7:0];
                    blue_o = b[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Edge detection
            end else if (sel_module == 4'b1010) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (8 * gray - left - right - up - down - leftup - leftdown - rightup - rightdown);
                    if (r[15] || r > 2048) begin
                        red_o = 0;
                        green_o = 0;
                        blue_o = 0;
                    end else if (r > 255) begin
                        red_o = 255;
                        green_o = 255;
                        blue_o = 255;
                    end else begin
                        red_o = r[7:0];
                        green_o = r[7:0];
                        blue_o = r[7:0];
                    end

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Motion blurring XY
            end else if (sel_module == 4'b1011) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (gray + leftdown + rightup);
                    r = r / 3;

                    red_o = r[7:0];
                    green_o = r[7:0];
                    blue_o = r[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Emboss
            end else if (sel_module == 4'b1100) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (gray + left - right - up + down + 2 * leftdown - 2 * rightup);
                    if (r[15] || r > 1280) begin
                        red_o = 0;
                        green_o = 0;
                        blue_o = 0;
                    end else if (r > 255) begin
                        red_o = 255;
                        green_o = 255;
                        blue_o = 255;
                    end else begin
                        red_o = r[7:0];
                        green_o = r[7:0];
                        blue_o = r[7:0];
                    end

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Sharpen
            end else if (sel_module == 4'b1101) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (5 * gray - left - right - up - down);
                    if (r[15] || r > 1280) begin
                        red_o = 0;
                        green_o = 0;
                        blue_o = 0;
                    end else if (r > 255) begin
                        red_o = 255;
                        green_o = 255;
                        blue_o = 255;
                    end else begin
                        red_o = r[7:0];
                        green_o = r[7:0];
                        blue_o = r[7:0];
                    end

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Motion blur X
            end else if (sel_module == 4'b1110) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (up + leftup + rightup);
                    r = r / 3;

                    red_o = r[7:0];
                    green_o = r[7:0];
                    blue_o = r[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            // Custom filter
            end else if (sel_module == 4'b1111) begin
                if (reset) begin
                    red = 0;
                    green = 0;
                    blue = 0;
                end else begin
                    r = (rightup + 2 * up + leftup + 2 * right + 4 * gray + 2 * left + rightdown + 2 * down + 2 * leftdown);
                    r = r / 16;

                    red_o = r[7:0];
                    green_o = r[7:0];
                    blue_o = r[7:0];

                    red_o = red_o >> 4;
                    green_o = green_o >> 4;
                    blue_o = blue_o >> 4;

                    red = red_o[3:0];
                    green = green_o[3:0];
                    blue = blue_o[3:0];
                end
            end

            // Increment address within valid range (0 to 18,399)
            if (addra < 18399)
                addra <= addra + 1;
            else
                addra <= 0;
        end else begin
            red = 0;
            green = 0;
            blue = 0;
        end
    end

endmodule