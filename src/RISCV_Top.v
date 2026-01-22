`timescale 1ns / 1ps

module RISCV_Top(
    input  clk,
    input  rst
);

    // -------------------------
    // Fetch ? Decode
    // -------------------------
    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;

    // -------------------------
    // Decode ? Execute
    // -------------------------
    wire [31:0] RD1_E, RD2_E;
    wire [31:0] PCE, Imm_ExtE, PCPlus4E;
    wire [4:0]  RdE;
    wire        RegWriteE, MemWriteE, ALUSrcE, Jump, Branch;
    wire [1:0]  ResultSrcE;
    wire [2:0]  ALU_CtrlE;

    // -------------------------
    // Execute ? Memory
    // -------------------------
    wire        RegWriteM, MemWriteM;
    wire [1:0]  ResultSrcM;
    wire [31:0] ALUResultM, WriteDataM, PCPlus4M;
    wire [4:0]  RdM;

    // -------------------------
    // Memory ? Writeback
    // -------------------------
    wire        RegWriteW;
    wire [1:0]  ResultSrcW;
    wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
    wire [4:0]  RdW;
    wire [31:0] ResultW;

    // -------------------------
    // FETCH STAGE
    // -------------------------
    Fetch_Cycle Fetch (
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // -------------------------
    // DECODE STAGE
    // -------------------------
    Decode_Cycle Decode (
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW),
        .ResultW(ResultW),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(Jump),
        .BranchE(Branch),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALU_CtrlE(ALU_CtrlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .PCE(PCE),
        .Imm_ExtE(Imm_ExtE),
        .PCPlus4E(PCPlus4E),
        .RdE(RdE)
    );

    // -------------------------
    // EXECUTION STAGE
    // -------------------------
    Execution_Cycle Execute (
        .clk(clk),
        .rst(rst),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .PCE(PCE),
        .Imm_ExtE(Imm_ExtE),
        .PCPlus4E(PCPlus4E),
        .RdE(RdE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(Jump),
        .BranchE(Branch),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALU_CtrlE(ALU_CtrlE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .RdM(RdM)
    );

    // -------------------------
    // MEMORY STAGE
    // -------------------------
    Data_Cycle DataMemStage (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .RdM(RdM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W),
        .RdW(RdW)
    );

    // -------------------------
    // WRITEBACK STAGE
    // -------------------------
    WriteBack_Cycle WriteBack (
        .ResultSrcW(ResultSrcW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W),
        .ResultW(ResultW)
    );

endmodule
