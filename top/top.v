`timescale 1ns / 1ps

module top(
    input clk,
    input btn0,
    output [3:0] led,
    output [2:0] rgb0,
    output uart_rxd_out,
    input uart_txd_in
    );

    /*
     * Buffer asynchronous inputs to avoid metastability
     */
    reg btn0_metastable, btn0_stable;
    always @(posedge clk)
        {btn0_stable, btn0_metastable} <= {btn0_metastable, btn0};

    reg uart_txd_in_metastable, uart_txd_in_stable;
    always @(posedge clk)
        {uart_txd_in_stable, uart_txd_in_metastable} <= {uart_txd_in_metastable, uart_txd_in};

    /*
     * Reset logic
     */
    wire rst_n;
    assign rst_n = ~btn0_stable;

    /*
     * RGB LED demo. Pulses different colors.
     */
    pulser #(.START(8'd1), .DWELL_TIME(20'd500)) red_pulser(
        .clk(clk),
        .rst_n(rst_n),
        .pulsed(rgb0[0])
    );

    /*
     * UART rx demo. Echos back the last character sent
     */
    wire [7:0] rx_byte;
    wire rx_byte_valid;
    uart_rx rx(
        .clk(clk),
        .reset(rst_n),
        .serial_in(uart_txd_in_stable),
        .byte_out(rx_byte),
        .valid(rx_byte_valid)
    );

    /*
     * Register to store the last byte read. Put the lowest 4 bits on the LEDs
     */
    reg [7:0] last_byte_read = 8'h7E; // tilde ~
    assign led[3:0] = last_byte_read[3:0];
    always @(posedge(clk))
        if (rx_byte_valid)
            last_byte_read <= rx_byte;
        else
            last_byte_read <= last_byte_read;

    /*
     * UART tx demo. Sends as quickly as possible the last byte read
     */
    wire done;
    wire start;
    assign start = 1'b1;
    uart_tx tx(
        .clk(clk),
        .reset(rst_n),
        .serial_out(uart_rxd_out),
        .byte_in(last_byte_read),
        .start(start),
        .done(done)
    );

endmodule

