`timescale 1ns / 1ps

/*
 * This module gradually increases and decreases the duty cycle of a PWM
 * module to create a pulsing effect.
 */
module pulser(
    input clk,
    input rst_n,
    output pulsed
    );
    // The duty cycle to start at after a reset. I should not be set to 0 or
    // 255.
    parameter START = 8'b1;
    // The number of PWM periods that we should sit at the current duty cycle
    // before switching to the next duty cycle.
    parameter DWELL_TIME = 10'd10;

    // Wires and registers that control the current and next duty cycle
    reg [7:0] duty_cycle = START;
    wire flip_duty_cycle;
    reg direction;
    wire next_direction;

    // Wires and registers for the incrementer circuit
    reg [10:0] incrementer = 0;
    wire go_to_next_duty_cycle;

    // PWM IO
    wire rollover;

    pwm pwm(
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle),
        .sig_out(pulsed),
        .rollover(rollover)
    );

    // Logic to control the dwelling time at any single duty cycle
    assign go_to_next_duty_cycle = incrementer == DWELL_TIME;
    always @(posedge(clk), negedge(rst_n)) begin
        if (!rst_n) begin
            incrementer <= 0;
        end else begin
            if (go_to_next_duty_cycle == 1)
                incrementer <= 10'b0;
            else
                incrementer <= incrementer + rollover;
        end
    end

    // Logic to control the next and current duty cycle
    assign flip_direction = duty_cycle == 8'h0 || duty_cycle == 8'hff;
    assign next_direction = go_to_next_duty_cycle ? direction ^ flip_direction : direction;
    always @(posedge(clk), negedge(rst_n)) begin
        if (!rst_n) begin
            direction  <= 1;
            duty_cycle <= START;
        end else begin
            direction <= next_direction;
            if (go_to_next_duty_cycle == 1) begin
                duty_cycle <= duty_cycle + (next_direction == 1 ? 8'h1 : 8'hff);
            end else begin
                duty_cycle <= duty_cycle;
            end
        end
    end

endmodule

