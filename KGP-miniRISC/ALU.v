`timescale 1ns / 1ps
`include "adder.v"

module MUX_2X1(A,B,OUT,sel);
	input wire[31:0] A,B;
	output wire[31:0] OUT;
	input wire sel;

	assign OUT = sel ? B : A;
endmodule

module MUX_2_input(A,B,OUT,sel);
	input wire[1:0] A,B;
	output wire[1:0] OUT;
	input wire sel;

	assign OUT = sel ? B : A;
endmodule

module MUX_4X1(IN,OUT,sel);
	input wire[3:0][31:0] IN;
	output wire[31:0] OUT;
	input wire[1:0] sel;

	assign OUT = IN[sel];
endmodule

module adder_module(A,B,sum,carry);
	input wire[31:0] A,B;
	output wire[31:0] sum;
	output wire carry;

	rippleAdder_32bit r(A,B,1'b0,sum,carry);

endmodule

module AND_module(A,B,out);
	input wire[31:0] A,B;
	output wire[31:0] out;
	assign out = A & B;
endmodule

module XOR_module(A,B,out);
	input wire[31:0] A,B;
	output wire[31:0] out;
	assign out = A ^ B;
endmodule

module shift_module(A,B,controls,out);
	input wire[31:0] A,B;
	output wire[31:0] out;
	input wire[1:0] controls;

	// output the 4 possible shift operation answers to the shift_ans bus
	// 00 left logical shift
	// 01 right logical shift
	// 10 left arithmetic shift
	// 11 right arithmetic shift

	wire[3:0][31:0] shift_ans;
	assign shift_ans[0] = A<<B;
	assign shift_ans[1] = A>>B;
	assign shift_ans[2] = A<<<B;
	assign shift_ans[3] = A>>>B;

	MUX_4X1 m1(shift_ans,out,controls);
endmodule

module priority_encoder_32bit(
    input wire [31:0] in,
    output reg [4:0] out
  );
  	integer i;
  	always @* begin
    	out = 0; // default value if 'in' is all 0's
    	for (i=31; i>=0; i=i-1)
        	if (in[i]) out = i;
  	end
endmodule

module diff(A,B,result);
	// here A is rs^rt
	// the decoded output will be equal to A^(A & A-1)
	// out = encoded answer of the decoded output
	input wire[31:0] A,B;
	output wire[31:0] result;
	wire[4:0] out;
	wire[31:0] w;
	assign w = A^B;

	priority_encoder_32bit p(w,out);
	sign_extension_5_to_32 s1(out,result);

endmodule

module sign_extension_5_to_32(A,result);
	input wire[4:0] A;
	output wire[31:0] result;

	assign result = {{27{1'b0}}, A}; 
endmodule

module ALU(A,B,controls,flags,result_final);
	input wire[31:0] A,B;
	output wire[31:0] result_final;
	input wire[4:0] controls;
	output wire[2:0] flags;

	wire[1:0][31:0] out;
	wire[1:0] sel;
	wire[31:0] negb;
	assign negb = ~B;

	wire[1:0] sel_line;
	wire xt;
	assign xt = controls[0] & controls[1];
	MUX_2_input mux_2(controls[3:2],2'b0,sel_line,xt);

	// select lines control signal will change
	assign sel[0] = sel_line[0];
	assign sel[1] = sel_line[1];


	MUX_2X1 in_mux1(A, 32'b1, out[0], sel[0]);
	MUX_2X1 in_mux2(B, negb, out[1], sel[1]);

	// out[0] is rs and out[1] is rt
	// IN shift we have to do rs left or right shifted by rt

	wire[3:0][31:0] result;
	wire[1:0][31:0] val;

	adder_module a1(out[0],out[1],result[0],carry);
	AND_module a(out[0],out[1],result[1]);
	XOR_module x(out[0],out[1],result[2]);
	shift_module s(out[0],out[1],controls[3:2],result[3]);
	diff d(out[0],out[1],val[1]);

	MUX_4X1 mux1(result,val[0],controls[1:0]);

	MUX_2X1 mux2(val[0],val[1],result_final,controls[4]);
	assign flags[2] = carry;   // carry flag
	assign flags[1] = result_final == 0 ? 1 : 0;        // zero flag
	assign flags[0] = result_final[31];        // sign flag

endmodule