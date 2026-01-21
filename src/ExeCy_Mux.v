`timescale 1ns / 1ps

module ExeCy_Mux(A,B,Sel,Y);
input [31:0] A,B;
input Sel;
output [31:0] Y;

assign Y = Sel ? B : A ;
 
endmodule
