`timescale 1ns / 1ps

module Data_Cycle(
    input              clk,
    input              rst,

    // From EX/MEM
    input              RegWriteM,
    input              MemWriteM,
    input      [1:0]   ResultSrcM,
    input      [31:0]  ALUResultM,
    input      [31:0]  WriteDataM,
    input      [31:0]  PCPlus4M,
    input      [4:0]   RdM,

    // To WB stage
    output reg         RegWriteW,
    output reg  [1:0]  ResultSrcW,
    output reg  [31:0] ALUResultW,
    output reg  [31:0] ReadDataW,
    output reg  [31:0] PCPlus4W,
    output reg  [4:0]  RdW
);

    // Internal wires
    wire [31:0] RD_dm_wire;

    // Data Memory
    DataMem DataMem (
        .clk   (clk),
        .A     (ALUResultM),
        .WE_dm (MemWriteM),
        .WD_dm (WriteDataM),
        .RD_dm (RD_dm_wire)
    );

    // MEM/WB Pipeline Register
    always @(posedge clk) begin
        if (rst) begin
            RegWriteW   <= 1'b0;
            ResultSrcW  <= 2'b00;
            ALUResultW  <= 32'h00000000;
            ReadDataW   <= 32'h00000000;
            PCPlus4W    <= 32'h00000000;
            RdW         <= 5'b0;
        end
        else begin
            RegWriteW   <= RegWriteM;
            ResultSrcW  <= ResultSrcM;
            ALUResultW  <= ALUResultM;
            ReadDataW   <= RD_dm_wire;
            PCPlus4W    <= PCPlus4M;
            RdW         <= RdM;
        end
    end

endmodule
