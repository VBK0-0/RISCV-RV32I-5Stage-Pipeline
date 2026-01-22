`timescale 1ns / 1ps

module Main_Decoder(Op,ResultSrc,ALUSrc,ImmSrc,RegWrite,MemWrite,Branch,Jump,ALU_Op);
input [6:0] Op;
output ALUSrc,RegWrite,MemWrite,Branch,Jump;
output [1:0] ResultSrc;
output [1:0] ImmSrc,ALU_Op;

assign RegWrite  = ((Op == 7'b0000011) |(Op == 7'b0110011) | (Op == 7'b0010011) | (Op == 7'b1101111)) ? 1'b1 : 1'b0; // load | R - type | I - type | JAL

assign ImmSrc    = ((Op == 7'b0000011) | (Op == 7'b0010011)) ? 2'b00 :  // LW | I - Type
                     (Op == 7'b0100011) ? 2'b01 :                         // SW
                     (Op == 7'b1100011) ? 2'b10 :                         //B - Type
                     (Op == 7'b1101111) ? 2'b11 : 2'bxx;                  // J - Type
                
assign ALUSrc    = ((Op == 7'b0000011) |(Op == 7'b0100011) | (Op == 7'b0010011))? 1'b1 : // Load | Store | I - Type
                     ((Op == 7'b0110011) |(Op == 7'b1100011)) ? 1'b0 : 1'bx;  // R - Type | B - Type

assign MemWrite  = (Op == 7'b0100011) ? 1'b1 : 1'b0;       // S - Type

assign ResultSrc = (Op == 7'b0000011) ? 2'b01 :                 // ALU Result
                    ((Op == 7'b0110011) |(Op == 7'b0010011) |(Op == 7'b1100011)) ? 2'b00 :  // Data Memory
                     (Op == 7'b1101111) ? 2'b10 : 2'bxx;                        // PC + 4 

assign Branch    = (Op == 7'b1100011) ? 1'b1 : 1'b0;        // B - Type

assign Jump      = (Op == 7'b1101111) ? 1'b1 : 1'b0;         // J - Type

  assign ALU_Op    = ((Op == 7'b0000011) |(Op == 7'b0100011)) ? 2'b00 :      // Load / I - Type | Store ( S - Type)  - Load, Store, Immediate ADD
                      (Op == 7'b1100011) ? 2'b01 :                    // B -Type  - Branch Comnparisions
                     ((Op == 7'b0110011) |(Op == 7'b0010011)) ? 2'b10 :  2'b00;    // R - Type | I - Type - Decode using funct fields
         

endmodule
