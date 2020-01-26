`timescale 1ns / 1ps

module pwm(
    input clk,
    input rst_n,
    input [7:0] duty_cycle,
    output sig_out,
    output rollover
    );

    reg [7:0] count = 0;

    assign sig_out = duty_cycle > count;
    assign rollover = count == 8'hff;

    always @ (posedge(clk)) begin
        if (~rst_n)
            count <= 0;
        else if (count==255)
            count <= 0;
        else
            count <= count + 1;
    end

endmodule
