// File: uart_rx.v
// Generated by MyHDL 0.11
// Date: Sun Feb  2 19:53:59 2020


`timescale 1ns/10ps

module uart_rx (
    clk,
    reset,
    serial_in,
    byte_out,
    valid
);
// A simple UART rx module with a fixed baud rate, one start bit, one stop bit, and no parity bit.
// clk -- The input clock
// reset -- The reset signal
// serial_in -- The serial data signal, it is high when inactive
// byte_out -- The 8 bit deserialized signal
// valid -- Goes high for one clock pulse when byte_out is valid
// baud -- A Baud object, which represents the incoming baud rate of the interface

input clk;
input reset;
input serial_in;
output [7:0] byte_out;
wire [7:0] byte_out;
output valid;
reg valid;

reg [0:0] half_bit_done;
wire [0:0] half_bit_tstart;
reg [8:0] shift_reg;
reg [1:0] state;
wire [0:0] valid_next_cycle;
reg [3:0] bit_count;
reg [0:0] full_bit_done;
wire [0:0] full_bit_tstart;
reg [5:0] timer0_0_timer;
reg [0:0] timer0_0_state;
reg [6:0] timer1_0_timer;
reg [0:0] timer1_0_state;



always @(timer0_0_timer) begin: UART_RX_TIMER0_0_COMB_LOGIC
    if ((timer0_0_timer == 0)) begin
        half_bit_done = 1;
    end
    else begin
        half_bit_done = 0;
    end
end


always @(posedge clk, negedge reset) begin: UART_RX_TIMER0_0_SEQ_LOGIC
    if (reset == 0) begin
        timer0_0_timer <= 49;
        timer0_0_state <= 1'b0;
    end
    else begin
        case (timer0_0_state)
            1'b0: begin
                timer0_0_state <= 1'b0;
                if ((half_bit_tstart == 1)) begin
                    timer0_0_state <= 1'b1;
                end
            end
            1'b1: begin
                timer0_0_state <= 1'b1;
                if ((timer0_0_timer == 0)) begin
                    timer0_0_timer <= (50 - 1);
                    if ((half_bit_tstart == 0)) begin
                        timer0_0_state <= 1'b0;
                    end
                    else begin
                        timer0_0_state <= 1'b1;
                    end
                end
                else begin
                    timer0_0_timer <= (timer0_0_timer - 1);
                end
            end
            default: begin
                $finish;
            end
        endcase
    end
end


always @(timer1_0_timer) begin: UART_RX_TIMER1_0_COMB_LOGIC
    if ((timer1_0_timer == 0)) begin
        full_bit_done = 1;
    end
    else begin
        full_bit_done = 0;
    end
end


always @(posedge clk, negedge reset) begin: UART_RX_TIMER1_0_SEQ_LOGIC
    if (reset == 0) begin
        timer1_0_timer <= 99;
        timer1_0_state <= 1'b0;
    end
    else begin
        case (timer1_0_state)
            1'b0: begin
                timer1_0_state <= 1'b0;
                if ((full_bit_tstart == 1)) begin
                    timer1_0_state <= 1'b1;
                end
            end
            1'b1: begin
                timer1_0_state <= 1'b1;
                if ((timer1_0_timer == 0)) begin
                    timer1_0_timer <= (100 - 1);
                    if ((full_bit_tstart == 0)) begin
                        timer1_0_state <= 1'b0;
                    end
                    else begin
                        timer1_0_state <= 1'b1;
                    end
                end
                else begin
                    timer1_0_timer <= (timer1_0_timer - 1);
                end
            end
            default: begin
                $finish;
            end
        endcase
    end
end


always @(posedge clk, negedge reset) begin: UART_RX_INCREMENTER0_0_SEQ_LOGC
    if (reset == 0) begin
        bit_count <= 0;
    end
    else begin
        if ((valid_next_cycle == 1)) begin
            bit_count <= 0;
        end
        else if (($signed({1'b0, bit_count}) == (9 - 1))) begin
            bit_count <= bit_count;
        end
        else if ((full_bit_done == 1)) begin
            bit_count <= (bit_count + 1);
        end
        else begin
            bit_count <= bit_count;
        end
    end
end



assign valid_next_cycle = (($signed({1'b0, bit_count}) == (9 - 1)) && (full_bit_done == 1));
assign byte_out = shift_reg[8-1:0];
assign half_bit_tstart = ((state == 2'b00) && (serial_in == 0));
assign full_bit_tstart = ((half_bit_done == 1) || ((full_bit_done == 1) && (!($signed({1'b0, bit_count}) == (9 - 1)))));


always @(posedge clk, negedge reset) begin: UART_RX_FSM_SEQ_LOGIC
    if (reset == 0) begin
        state <= 2'b00;
    end
    else begin
        state <= state;
        case (state)
            2'b00: begin
                if ((serial_in == 0)) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if ((half_bit_done == 1)) begin
                    state <= 2'b10;
                end
            end
            2'b10: begin
                if ((valid_next_cycle == 1)) begin
                    state <= 2'b00;
                end
            end
            default: begin
                $finish;
            end
        endcase
    end
end


always @(posedge clk, negedge reset) begin: UART_RX_VALID_LOGIC
    if (reset == 0) begin
        valid <= 0;
    end
    else begin
        valid <= valid_next_cycle;
    end
end


always @(posedge clk, negedge reset) begin: UART_RX_SHIFT_REG_LOGIC
    if (reset == 0) begin
        shift_reg <= 0;
    end
    else begin
        if ((full_bit_done == 1)) begin
            shift_reg <= {serial_in, shift_reg[9-1:1]};
        end
        else begin
            shift_reg <= shift_reg;
        end
    end
end

endmodule