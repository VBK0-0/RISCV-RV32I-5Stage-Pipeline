`timescale 1ns / 1ps

module PC_Mux(I0,I1,Sel,Out);
input [31:0] I0,I1;
input  Sel;
output [31:0] Out;

assign Out = Sel  ? I1 : I0 ;

endmodule
