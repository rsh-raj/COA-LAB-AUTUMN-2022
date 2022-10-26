`timescale 1ns / 1ps
`include "program_counter.v"

// Not complete, need external and internal halt signal and clock wrapper
module program_counter_unit(
    input wire[31:0] next_address,
    input wire clk, reset,
    output wire[31:0] PCin
);

    program_counter pc(next_address, PCin, clk, reset);

endmodule