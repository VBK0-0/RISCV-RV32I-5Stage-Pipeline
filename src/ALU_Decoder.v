`timescale 1ns / 1ps

module ALU_Decoder(ALU_Op,funct7,funct3,Op,ALU_Ctrl);

input [1:0] ALU_Op;
input [6:0] funct7,Op;
input [2:0] funct3;
output [2:0] ALU_Ctrl;

assign ALU_Ctrl = (ALU_Op == 2'b00) ? 3'b000 :
                  (ALU_Op == 2'b01) ? 3'b001 :
                  (ALU_Op == 2'b10) & (funct3 == 3'b010) ? 3'b101 : 
                  (ALU_Op == 2'b10) & (funct3 == 3'b110) ? 3'b011 :
                  (ALU_Op == 2'b10) & (funct3 == 3'b111) ? 3'b010 :
                  (ALU_Op == 2'b10) & (funct3 == 3'b000) & ({Op[5],funct7[5]} == 2'b11) ? 3'b001 : 3'b000;
                  
endmodule
