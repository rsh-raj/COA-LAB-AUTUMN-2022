
`include "CLA_16bit_LookaheadUnit.v"

module CLA_16bit_LookAheadUnit(A,B,cin,S,carry);
    input[31:0] A,B;
    output[31:0] S;
    input cin;
    output carry;
    wire[7:0] carry_out;
    CLA_16bit_LookAheadUnit cla1(A[15:0],B[15:0],cin,sum[15:0],carry_out),cla2(A[31:16],B[31:16],carry_out,sum[31:16],carry);

    
    // CLA_16bit_withLCU cla1(.in1(input1[15:0]), .in2(input2[15:0]), .c_in(1'b0), .sum(sum[15:0]), .c_out(sum_c_out), .p(p1), .g(g1));
	// CLA_16bit_withLCU cla2(.in1(input1[31:16]), .in2(input2[31:16]), .c_in(sum_c_out), .sum(sum[31:16]), .c_out(sumcarry), .p(p2), .g(g2));

endmodule


