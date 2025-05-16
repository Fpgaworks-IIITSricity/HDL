module vga_controller(
    input clk,       // Clock input (around 85.5 MHz for 1366x768@60Hz)
    input rst,
    output reg [9:0] x,
    output reg [9:0] y,
    output reg hsync,
    output reg vsync,
    output reg active_video
);

    // VGA 1366x768 @60Hz timing parameters
    parameter H_VISIBLE   = 1366;
    parameter H_FRONT     = 70;
    parameter H_SYNC      = 143;
    parameter H_BACK      = 213;
    parameter H_TOTAL     = H_VISIBLE + H_FRONT + H_SYNC + H_BACK; // 1792

    parameter V_VISIBLE   = 768;
    parameter V_FRONT     = 3;
    parameter V_SYNC      = 3;
    parameter V_BACK      = 24;
    parameter V_TOTAL     = V_VISIBLE + V_FRONT + V_SYNC + V_BACK; // 798

    reg [10:0] h_count = 0; // Adjusted for 11-bit counter
    reg [10:0] v_count = 0; // Adjusted for 11-bit counter

    // Horizontal and vertical counters
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    // X and Y pixel coordinates
    always @(posedge clk) begin
        x <= h_count[9:0]; // Use lower 10 bits for x
        y <= v_count[9:0]; // Use lower 10 bits for y
        active_video <= (h_count < H_VISIBLE) && (v_count < V_VISIBLE);
    end

    // Horizontal and vertical sync (active low)
    always @(*) begin
        hsync = ~( (h_count >= (H_VISIBLE + H_FRONT)) && 
                   (h_count < (H_VISIBLE + H_FRONT + H_SYNC)) );
        
        vsync = ~( (v_count >= (V_VISIBLE + V_FRONT)) && 
                   (v_count < (V_VISIBLE + V_FRONT + V_SYNC)) );
    end
endmodule
