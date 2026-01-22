`timescale 1ns / 1ps

module Control_Unit(Op,funct7,funct3,ResultSrc,ALUSrc,ImmSrc,RegWrite,MemWrite,ALU_Ctrl,Branch,Jump);


input [6:0] Op,funct7;
input [2:0] funct3;

output RegWrite,MemWrite,ALUSrc;
output [1:0] ImmSrc,ResultSrc;
output [2:0] ALU_Ctrl;
output Branch,Jump;

wire [1:0] ALU_OP;

Main_Decoder MD1(.Op(Op),
                 .ResultSrc(ResultSrc),
                 .ALUSrc(ALUSrc),
                 .ImmSrc(ImmSrc),
                 .RegWrite(RegWrite),
                 .MemWrite(MemWrite),
                 .Branch(Branch),
                 .Jump(Jump),
                 .ALU_Op(ALU_OP));

ALU_Decoder AD1(.ALU_Op(ALU_OP),
                .funct7(funct7),
                .funct3(funct3),
                .Op(Op),
                .ALU_Ctrl(ALU_Ctrl));
                                               
endmodule

