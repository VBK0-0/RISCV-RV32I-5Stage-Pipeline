`timescale 1ns / 1ps

module Execution_Cycle(
    input              clk,
    input              rst,

    // From ID/EX
    input      [31:0]   RD1_E,
    input      [31:0]   RD2_E,
    input      [31:0]   PCE,
    input      [31:0]   Imm_ExtE,
    input      [31:0]   PCPlus4E,
    input      [4:0]    RdE,

    input              RegWriteE,
    input              MemWriteE,
    input              JumpE,
    input              BranchE,
    input              ALUSrcE,
    input      [1:0]   ResultSrcE,
    input      [2:0]   ALU_CtrlE,

    // To MEM stage (EX/MEM)
    output reg         RegWriteM,
    output reg         MemWriteM,
    output reg  [1:0]  ResultSrcM,
    output reg  [31:0] ALUResultM,
    output reg  [31:0] WriteDataM,
    output reg  [31:0] PCPlus4M,
    output reg  [4:0]  RdM,

    // Branch control
    output             PCSrc_out,
    output     [31:0]  PCTargetE
);

    // Internal wires
    wire        Zero;
    wire [31:0] Src_B;
    wire [31:0] ALUResult;
    wire [31:0] PCTargetE_w;

    // ALU source B select
    ExeCy_Mux ALUSrc_Mux (
        .A   (RD2_E),
        .B   (Imm_ExtE),
        .Sel (ALUSrcE),
        .Y   (Src_B)
    );

    // ALU
    ALU ALU (
        .A          (RD1_E),
        .B          (Src_B),
        .ALU_Ctrl   (ALU_CtrlE),
        .ALU_Result (ALUResult),
        .Zero       (Zero),
        .Negative   (),
        .Overflow   (),
        .Carry      ()
    );

    // Branch Target Adder

    PC_Adder Branch_Adder (
        .A (PCE),
        .B (Imm_ExtE),
        .Y (PCTargetE_w)
    );

    // EX/MEM Pipeline Register
    always @(posedge clk) begin
        if (rst) begin
            RegWriteM  <= 1'b0;
            MemWriteM  <= 1'b0;
            ResultSrcM <= 2'b00;
            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            PCPlus4M   <= 32'b0;
            RdM        <= 5'b0;
        end
        else begin
            RegWriteM  <= RegWriteE;
            MemWriteM  <= MemWriteE;
            ResultSrcM <= ResultSrcE;
            ALUResultM <= ALUResult;
            WriteDataM <= RD2_E;
            PCPlus4M   <= PCPlus4E;
            RdM        <= RdE;
        end
    end

    // Branch decision
    assign PCSrc_out = JumpE | (BranchE & Zero);
    assign PCTargetE = PCTargetE_w;

endmodule

