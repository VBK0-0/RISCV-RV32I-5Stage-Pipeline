`timescale 1ns / 1ps

module Instruction_Mem(rst,A,RD);
input rst;
input [31:0] A;
output [31:0] RD;

reg [31:0] Instr_Mem [1023:0];

assign RD = (rst == 1'b1) ? {32{1'b0}} : Instr_Mem[A[31:2]];

initial begin
    $readmemh("C:/Kittu/B.Tech_GITAM/Sem_32/DDFPGA/LAB/project_6/IntrucMem.hex", Instr_Mem);
end

endmodule
