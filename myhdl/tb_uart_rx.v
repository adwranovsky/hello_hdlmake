module tb_uart_rx;

reg clk;
reg reset;
reg serial_in;
wire [7:0] byte_out;
wire valid;

initial begin
    $from_myhdl(
        clk,
        reset,
        serial_in
    );
    $to_myhdl(
        byte_out,
        valid
    );
end

uart_rx dut(
    clk,
    reset,
    serial_in,
    byte_out,
    valid
);

endmodule
