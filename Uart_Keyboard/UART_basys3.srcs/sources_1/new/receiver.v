`timescale 1ns / 1ps
module Receiver_RxD(
    input clk_fpga,         // 100 MHz FPGA Clock (Basys 3 Board)
    input reset,            // Reset button
    input RxD,              // Serial input line
    output [7:0] RxData     // 8-bit received data
);

// Internal Variables
reg shift;
reg state, nextstate;
reg [3:0] bit_counter;
reg [1:0] sample_counter;
reg [13:0] baudrate_counter;
reg [9:0] rxshift_reg;
reg clear_bitcounter, inc_bitcounter, inc_samplecounter, clear_samplecounter;

// Constants
parameter clk_freq      = 100_000_000;
parameter baud_rate     = 9600;
parameter div_sample    = 4;
parameter div_counter   = clk_freq / (baud_rate * div_sample);
parameter mid_sample    = div_sample / 2;
parameter div_bit       = 10;

// Assign received data from the shift register
assign RxData = rxshift_reg[8:1];

// UART Receiver Timing Logic
always @(posedge clk_fpga) begin
    if (reset) begin
        state <= 0;
        bit_counter <= 0;
        baudrate_counter <= 0;
        sample_counter <= 0;
    end else begin
        baudrate_counter <= baudrate_counter + 1;

        if (baudrate_counter >= div_counter - 1) begin
            baudrate_counter <= 0;
            state <= nextstate;

            if (shift)
                rxshift_reg <= {RxD, rxshift_reg[9:1]};

            if (clear_samplecounter)
                sample_counter <= 0;

            if (inc_samplecounter)
                sample_counter <= sample_counter + 1;

            if (clear_bitcounter)
                bit_counter <= 0;

            if (inc_bitcounter)
                bit_counter <= bit_counter + 1;
        end
    end
end

// UART Receiver State Machine
always @(posedge clk_fpga) begin
    // Default control signals
    shift <= 0;
    clear_samplecounter <= 0;
    inc_samplecounter <= 0;
    clear_bitcounter <= 0;
    inc_bitcounter <= 0;
    nextstate <= 0; // Default to idle state

    case (state)
        0: begin // Idle State
            if (RxD) begin
                nextstate <= 0; // Stay in idle
            end else begin
                nextstate <= 1; // Start bit detected
                clear_bitcounter <= 1;
                clear_samplecounter <= 1;
            end
        end

        1: begin // Receiving State
            nextstate <= 1; // Default remain in receiving

            if (sample_counter == mid_sample - 1)
                shift <= 1;

            if (sample_counter == div_sample - 1) begin
                if (bit_counter == div_bit - 1) begin
                    nextstate <= 0; // Done receiving, go to idle
                end
                inc_bitcounter <= 1;
                clear_samplecounter <= 1;
            end else begin
                inc_samplecounter <= 1;
            end
        end

        default: nextstate <= 0; // Default fallback to idle
    endcase
end

endmodule
