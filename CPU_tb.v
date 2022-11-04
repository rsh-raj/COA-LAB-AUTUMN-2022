`timescale 1ns / 1ps
// `include "CPU.v"

module test();
    reg clk = 0, reset = 0, haltext = 0;
    wire[31:0] out;

    CPU c(clk,reset,haltext,out);

    initial begin
        // reset = 0;#100;
        #100;
        reset = 1;#1;
        reset = 0;

        #500;
        $finish;  
    end

    always@(posedge clk)
    begin
        $display("out = %d", out);
    end

    always begin
        #20;
        clk = ~clk;
    end
endmodule
