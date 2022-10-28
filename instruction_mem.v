`timescale 1ns / 1ps

module instruction_memory(address_in, instruction_out);
    input wire[31:0] address_in;
    output wire[31:0] instruction_out;

    reg[31:0] register[1024:0];

    initial begin
        $readmemh("memory.txt", register, 0);
    end

    assign instruction_out = register[address_in];
endmodule