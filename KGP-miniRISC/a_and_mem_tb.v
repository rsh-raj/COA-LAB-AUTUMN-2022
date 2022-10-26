`timescale 1ns / 1ps
`include "arithmetic_and_memory_unit.v"
`include "program_counter_unit.v"

module test();
    reg[31:0] next_address = 32'b1;
    reg clk = 0,reset=0;
    reg RegWrite=0,MemRead=0,MemWrite=0,MemtoReg=1,DataPCSel=0,RegSelect=0;
    reg[2:0] ALUop = 3'b0;
    reg[1:0] ALUinSel = 2'b0;
    wire[31:0] ALUresult, address,data_to_mem,PCin;
    wire[2:0] flags;
    wire[5:0] opcode;

    arithmetic_and_memory_unit au(
    PCin,
    clk,reset,
    RegWrite,MemRead,MemWrite,MemtoReg,DataPCSel,RegSelect,
    ALUop,
    ALUinSel,
    ALUresult, address,data_to_mem,
    flags,
    opcode);

    program_counter_unit pc(next_address,clk, reset,PCin);

    initial begin
        reset = 1;#5;
        reset = 0;

        $display("op = %d ALU = %d address = %d",opcode,ALUresult, address);
        #20;
        $display("op = %d ALU = %d address = %d",opcode,ALUresult, address);

        RegWrite = 1;
        ALUinSel = 2'b10;
        #5;
        $display("op = %d ALU = %d address = %d final = %d",opcode,ALUresult, address, data_to_mem);
        next_address = 32'd2;
        #21;
        RegWrite = 0;
        ALUinSel = 2'b11;
        #5;
        $display("op = %d ALU = %d address = %d final = %d",opcode,ALUresult, address, data_to_mem);

        $finish;
    end

    always begin
        #20;
        clk = ~clk;
    end
endmodule