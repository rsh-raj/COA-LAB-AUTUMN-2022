`timescale 1ns / 1ps
`include "CPU.v"

module test();
    reg clk = 0, reset = 0;
    wire[31:0] out;

    CPU c(clk,reset,out);

    initial begin
        reset = 1;#5;
        reset = 0;#5;

        #200;
        $finish;  
    end

    always@(posedge clk)
    begin
        #10;
        $display("out = %d", out);
    end

    always begin
        #20;
        clk = ~clk;
    end
endmodule
