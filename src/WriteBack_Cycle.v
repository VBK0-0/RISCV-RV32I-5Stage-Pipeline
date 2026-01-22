`timescale 1ns / 1ps

module WriteBack_Cycle(
    input      [1:0]  ResultSrcW,
    input      [31:0] ALUResultW,
    input      [31:0] ReadDataW,
    input      [31:0] PCPlus4W,
    output     [31:0] ResultW
);

    // -------------------------
    // Writeback MUX
    // -------------------------
    Wb_Mux WB_Mux (
        .I0  (ALUResultW),   // ALU result
        .I1  (ReadDataW),    // Data memory read
        .I2  (PCPlus4W),     // PC + 4 (for JAL/JALR)
        .Sel (ResultSrcW),
        .Out (ResultW)
    );

endmodule

