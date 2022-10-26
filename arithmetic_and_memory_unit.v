`timescale 1ns / 1ps
`include "ALU.v"
`include "instruction_mem.v"
`include "regfile.v"
`include "data_mem.v"
`include "ALU_control.v"

module MUX_2X1_reg(A,B,OUT,sel);
	input wire[4:0] A,B;
	output wire[4:0] OUT;
	input wire sel;

	assign OUT = sel ? B : A;
endmodule

module sign_extension_16_to_32(A,result);
	input wire[15:0] A;
	output wire[31:0] result;

	assign result = {{16{1'b0}}, A}; 
endmodule

module arithmetic_and_memory_unit(
    input wire[31:0] PCin,
    input wire clk,reset,
    input wire RegWrite,MemRead,MemWrite,MemtoReg,DataPCSel,RegSelect,
    input wire[2:0] ALUop,
    input wire[1:0] ALUinSel,
    output wire[31:0] ALUresult, address,data_to_mem,
    output wire[2:0] flags,
    output wire[5:0] opcode
);
    wire[31:0] instruction_out;

    wire[4:0] readReg1, readReg2, writeReg; 
    wire[31:0] writeData, data1, data2, data2_f;
    wire[15:0] immediate;

    instruction_memory im(PCin,instruction_out);

    // additional
    // assign i_out = instruction_out;

    assign readReg1 = instruction_out[20:16];
    assign readReg2 = instruction_out[25:21];
    assign opcode = instruction_out[31:26];
    assign immediate = instruction_out[15:0];

    MUX_2X1_reg reg_select(readReg2,5'b11111,writeReg,RegSelect);

    regfile rf(readReg1, readReg2, writeReg, data1, data2, clk, writeData, RegWrite, reset);

    sign_extension_16_to_32 set(immediate,address);

    wire[3:0][31:0] mux_in;
    assign mux_in = {32'b1,address,32'b0,data2};

    MUX_4X1 ALU_sel(mux_in,data2_f,ALUinSel);

    wire[4:0] ALU_control_signal;
    ALU_control ac(ALUop,instruction_out[31:26],ALU_control_signal);

    ALU alu_unit(data1,data2_f,ALU_control_signal,flags,ALUresult);

    wire[31:0] data_out;
    data_memory dmem(ALUresult, data_out, data2, MemWrite, MemRead, clk);

    MUX_2X1 memtoreg(data_out,ALUresult,data_to_mem,MemtoReg);

    // Now we will use a MUX to select between PCin +1 and the data_to_mem, and the output will be in wire writeData

    // PCin = PCin + 1
    wire[31:0] increment_PC;
    wire useless_carry;
    adder_module incPC(PCin,32'b1,increment_PC,useless_carry);

    MUX_2X1 PCVdata(data_to_mem,increment_PC,writeData,DataPCSel);
    
    // Over 
endmodule