`timescale 1ns / 1ps

module Instruction_Mem(rst,A,RD);
input rst;
input [31:0] A;
output [31:0] RD;

reg [31:0] Instr_Mem [1023:0];

assign RD = (rst == 1'b1) ? {32{1'b0}} : Instr_Mem[A[31:2]];

initial begin
    $readmemh("../IntrucMem.hex", Instr_Mem);  // The path should be complete, which I have not added here.
end

endmodule
