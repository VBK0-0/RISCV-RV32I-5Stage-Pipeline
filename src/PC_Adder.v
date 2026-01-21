`timescale 1ns / 1ps

module PC_Adder(A,B,Y);
input [31:0] A;
input [31:0] B;
output [31:0] Y;

assign Y = A + B;

endmodule
