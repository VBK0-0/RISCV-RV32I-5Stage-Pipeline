`timescale 1ns / 1ps

module Main_Decoder(Op,ResultSrc,ALUSrc,ImmSrc,RegWrite,MemWrite,Branch,Jump,ALU_Op);
input [6:0] Op;
output ALUSrc,RegWrite,MemWrite,Branch,Jump;
output [1:0] ResultSrc;
output [1:0] ImmSrc,ALU_Op;

assign RegWrite  = ((Op == 7'b0000011) |(Op == 7'b0110011) | (Op == 7'b0010011) | (Op == 7'b1101111)) ? 1'b1 : 1'b0; 

assign ImmSrc    = ((Op == 7'b0000011) | (Op == 7'b0010011)) ? 2'b00 : 
                   (Op == 7'b0100011) ? 2'b01 : 
                   (Op == 7'b1100011) ? 2'b10 : 
                   (Op == 7'b1101111) ? 2'b11 : 2'bxx;
                
assign ALUSrc    = ((Op == 7'b0000011) |(Op == 7'b0100011) | (Op == 7'b0010011))? 1'b1 : 
                   ((Op == 7'b0110011) |(Op == 7'b1100011)) ? 1'b0 : 1'bx;

assign MemWrite  = (Op == 7'b0100011) ? 1'b1 : 1'b0;

assign ResultSrc = (Op == 7'b0000011) ? 2'b01 : ((Op == 7'b0110011) |(Op == 7'b0010011) |(Op == 7'b1100011)) ? 2'b00 : (Op == 7'b1101111) ? 2'b10 : 2'bxx;

assign Branch    = (Op == 7'b1100011) ? 1'b1 : 1'b0;

assign Jump      = (Op == 7'b1101111) ? 1'b1 : 1'b0;

assign ALU_Op    = ((Op == 7'b0000011) |(Op == 7'b0100011)) ? 2'b00 :
                   ((Op == 7'b0110011) |(Op == 7'b0010011)) ? 2'b10 : 
                   (Op == 7'b1100011) ? 2'b01 : 2'b00;

endmodule
