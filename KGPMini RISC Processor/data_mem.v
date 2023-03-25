`timescale 1ns / 1ps
// regfile worlking fine

module data_memory(address_in, data_out, write_data, MemWrite, MemRead, clk);
    input wire[9:0] address_in;
	 input wire MemWrite, MemRead, clk;
	 output wire[31:0] data_out;
	 input wire[31:0] write_data;
    
<<<<<<< HEAD:KGPMini RISC Processor/data_mem.v
    input wire[9:0] address_in;
    input wire[31:0] write_data;
    output wire[31:0] data_out;
    input wire MemWrite, MemRead, clk;
    reg[31:0] buffer;
    reg[31:0] register[1024:0];
=======
bram DataMemory (
  .clka(clk), // input clka
  .ena(MemRead), // input ena
  .wea(MemWrite), // input [0 : 0] wea
  .addra(address_in), // input [9 : 0] addra
  .dina(write_data), // input [31 : 0] dina
  .douta(data_out) // output [31 : 0] douta
);
>>>>>>> 6d10a3e41f2c3288dac31e8393b84b6678c682d2:data_mem.v


endmodule
