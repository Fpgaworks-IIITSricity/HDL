module temp_monitor (
    input  wire clk,        // 50 MHz clock
    input  wire reset_n,    // Active-low reset
    output reg  uart_tx     // UART TX output to USB
);

    // --- XADC Interface ---
    reg [6:0] daddr = 7'h17;
    reg       den = 0;
    reg       dwe = 0;
    wire [15:0] do_data;
    wire drdy;

    XADC #(
        .INIT_40(16'h0),
        .INIT_41(16'h0),
        .INIT_42(16'h0)
    ) xadc_inst (
        .DCLK(clk),
        .RESET(~reset_n),
        .DEN(den),
        .DWE(dwe),
        .DADDR(daddr),
        .DI(16'h0000),
        .VAUXP({7'b0, 1'b1}),  // VAUXP[7] = 1
        .VAUXN(8'b0),
        .DO(do_data),
        .DRDY(drdy),
        .EOC(), .EOS(), .ALM(), .CHANNEL(), .OT()
    );

    reg [11:0] raw_data;
    reg [7:0] tempC;
    reg [1:0] state = 0;

    // ASCII digits
    reg [7:0] digit_h, digit_t, digit_u;

    // FSM for temperature sampling
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 0;
            den <= 0;
        end else begin
            case (state)
                0: begin
                    den <= 1;
                    daddr <= 7'h17;
                    state <= 1;
                end
                1: begin
                    den <= 0;
                    if (drdy) begin
                        raw_data <= do_data[15:4]; // 12-bit
                        state <= 2;
                    end
                end
                2: begin
                    tempC <= (raw_data * 25) >> 10;  // Approximate Celsius
                    state <= 3;
                end
                3: begin
                    // Prepare ASCII digits
                    digit_h <= 8'd48 + (tempC / 100);
                    digit_t <= 8'd48 + ((tempC % 100) / 10);
                    digit_u <= 8'd48 + (tempC % 10);
                    send_trigger <= 1;
                    state <= 0; // Restart cycle
                end
            endcase
        end
    end

    // --- UART Transmitter (115200 baud, 50 MHz clock) ---
    localparam CLKS_PER_BIT = 434;
    reg [31:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] shift_reg = 10'b1111111111;

    reg [2:0] send_state = 0;
    reg sending = 0;
    reg send_trigger = 0;
    reg [7:0] current_char;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            uart_tx <= 1'b1;
            baud_counter <= 0;
            bit_index <= 0;
            sending <= 0;
            send_state <= 0;
            send_trigger <= 0;
        end else begin
            // Begin new send if ready
            if (send_trigger && !sending) begin
                sending <= 1;
                send_state <= 0;
                bit_index <= 0;
                baud_counter <= 0;
                send_trigger <= 0;
                current_char <= digit_h;
                shift_reg <= {1'b1, digit_h, 1'b0};
            end

            if (sending) begin
                if (baud_counter < CLKS_PER_BIT - 1)
                    baud_counter <= baud_counter + 1;
                else begin
                    baud_counter <= 0;
                    uart_tx <= shift_reg[0];
                    shift_reg <= {1'b1, shift_reg[9:1]}; // shift right
                    bit_index <= bit_index + 1;

                    if (bit_index == 9) begin
                        bit_index <= 0;
                        send_state <= send_state + 1;

                        case (send_state)
                            0: begin current_char <= digit_t; shift_reg <= {1'b1, digit_t, 1'b0}; end
                            1: begin current_char <= digit_u; shift_reg <= {1'b1, digit_u, 1'b0}; end
                            2: begin current_char <= 8'd10;   shift_reg <= {1'b1, 8'd10, 1'b0}; end // \n
                            3: begin sending <= 0; end
                        endcase
                    end
                end
            end
        end
    end

endmodule
