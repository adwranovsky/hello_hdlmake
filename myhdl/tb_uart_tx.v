module tb_uart_tx;

reg clk;
reg reset;
wire serial_out;
reg [7:0] byte_in;
reg start;
wire done;

initial begin
    $from_myhdl(
        clk,
        reset,
        byte_in,
        start
    );
    $to_myhdl(
        serial_out,
        done
    );
end

uart_tx dut(
    clk,
    reset,
    serial_out,
    byte_in,
    start,
    done
);

endmodule
