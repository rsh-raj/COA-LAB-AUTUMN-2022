`timescale 1ns / 1ps
// `include "program_counter.v"

// Not complete, need external and internal halt signal and clock wrapper
module wrapper(clkext, clk, haltext, halt);
    input wire clkext, haltext, halt;
    output wire clk;
    wire haltf;
    or o1(haltf, halt, haltext);
    MUX_2X1 mx1(clkext,1'b0,clk,haltf);
endmodule

module program_counter_unit(
    input wire[31:0] next_address,
    input wire clkext, reset, haltext, halt,
    output wire[31:0] PCin,
    output wire clk
);
    wrapper wc(clkext, clk, haltext, halt);
    program_counter pc(next_address, PCin, clk, reset);

endmodule