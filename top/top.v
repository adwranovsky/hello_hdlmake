`timescale 1ns / 1ps

module top(
    input clk,
    input btn0,
    output [3:0] led,
    output [2:0] rgb0
    );

    wire rst_n;
    reg [28:0] count = 0;

    assign rst_n = ~btn0;

    /*
     * Green LED demo. Counts upwards on the four LEDs, and then wraps back to
     * zero.
     */
    assign led[3:0] = count[28:25];
    always @ (posedge(clk)) begin
        if (~rst_n)
            count <= 0;
        else
            count <= count + 1;
    end

    /*
     * RGB LED demo. Pulses different colors.
     */
    pulser #(.START(8'd1), .DWELL_TIME(20'd500)) red_pulser(
        .clk(clk),
        .rst_n(rst_n),
        .pulsed(rgb0[0])
    );

endmodule

