`timescale 1ns / 1ps

module Decode_Cycle(
    input              clk,
    input              rst,

    // From IF/ID
    input      [31:0]   InstrD,
    input      [31:0]   PCD,
    input      [31:0]   PCPlus4D,

    // From WB
    input              RegWriteW,
    input      [31:0]   ResultW,
    input      [4:0]    RdW,

    // To EX stage (ID/EX pipeline registers)
    output reg          RegWriteE,
    output reg          MemWriteE,
    output reg          JumpE,
    output reg          BranchE,
    output reg          ALUSrcE,
    output reg  [1:0]   ResultSrcE,
    output reg  [2:0]   ALU_CtrlE,

    output reg  [31:0]  RD1_E,
    output reg  [31:0]  RD2_E,
    output reg  [31:0]  PCE,
    output reg  [31:0]  Imm_ExtE,
    output reg  [31:0]  PCPlus4E,
    output reg  [4:0]   RdE
);

    // -------------------------
    // Decode-stage internal wires
    // -------------------------
    wire        RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    wire [1:0]  ResultSrcD, ImmSrcD;
    wire [2:0]  ALU_CtrlD;
    wire [31:0] RD1_D, RD2_D, Imm_ExtD;

    // -------------------------
    // Control Unit
    // -------------------------
    Control_Unit CU (
        .Op        (InstrD[6:0]),
        .funct7    (InstrD[31:25]),
        .funct3    (InstrD[14:12]),
        .ResultSrc (ResultSrcD),
        .ALUSrc    (ALUSrcD),
        .ImmSrc    (ImmSrcD),
        .RegWrite  (RegWriteD),
        .MemWrite  (MemWriteD),
        .ALU_Ctrl  (ALU_CtrlD),
        .Jump      (JumpD),
        .Branch    (BranchD)
    );

    // -------------------------
    // Register File
    // -------------------------
    Register_File RF (
        .clk     (clk),
        .rst     (rst),
        .A1      (InstrD[19:15]),
        .A2      (InstrD[24:20]),
        .A3      (RdW),
        .RD1     (RD1_D),
        .RD2     (RD2_D),
        .WE_reg  (RegWriteW),
        .WD_reg  (ResultW)
    );

    // -------------------------
    // Immediate Generator
    // -------------------------
    Sign_Extender SE (
        .Imm_In  (InstrD),
        .Imm_En  (ImmSrcD),
        .Imm_Ext (Imm_ExtD)
    );

    // -------------------------
    // ID/EX Pipeline Register
    // -------------------------
    always @(posedge clk) begin
        if (rst) begin
            RegWriteE  <= 1'b0;
            ResultSrcE <= 2'b00;
            MemWriteE  <= 1'b0;
            JumpE      <= 1'b0;
            BranchE    <= 1'b0;
            ALU_CtrlE  <= 3'b000;
            ALUSrcE    <= 1'b0;
            RD1_E      <= 32'b0;
            RD2_E      <= 32'b0;
            PCE        <= 32'b0;
            Imm_ExtE   <= 32'b0;
            PCPlus4E   <= 32'b0;
            RdE        <= 5'b0;
        end
        else begin
            RegWriteE  <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE  <= MemWriteD;
            JumpE      <= JumpD;
            BranchE    <= BranchD;
            ALU_CtrlE  <= ALU_CtrlD;
            ALUSrcE    <= ALUSrcD;
            RD1_E      <= RD1_D;
            RD2_E      <= RD2_D;
            PCE        <= PCD;
            Imm_ExtE   <= Imm_ExtD;
            PCPlus4E   <= PCPlus4D;
            RdE        <= InstrD[11:7];
        end
    end

endmodule
