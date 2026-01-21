`timescale 1ns / 1ps

module Wb_Mux(I0,I1,I2,Sel,Out);

input [31:0] I0,I1,I2;
input [1:0] Sel;
output [31:0] Out;

assign Out = (Sel == 2'b00) ? I0 : (Sel == 2'b01) ? I1 : (Sel == 2'b10) ? I2 : 32'h00000000; 

endmodule
