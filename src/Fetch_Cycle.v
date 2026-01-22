`timescale 1ns / 1ps

module Fetch_Cycle(
    input              clk,
    input              rst,

    output     [31:0]   InstrD,
    output     [31:0]   PCD,
    output     [31:0]   PCPlus4D
);

// Internal wires
wire [31:0] PCF;
wire [31:0] PCPlus4F;
wire [31:0] RDF;

// IF/ID pipeline registers
reg  [31:0] InstrF_reg;
reg  [31:0] PCF_reg;
reg  [31:0] PCPlus4F_reg;

// Program Counter
Program_counter PC (
    .clk    (clk),
    .rst    (rst),
    .PCNext (PCPlus4F),   // Always PC + 4
    .PC     (PCF)
);

// Instruction Memory
Instruction_Mem IMEM (
    .rst (rst),
    .A   (PCF),
    .RD  (RDF)
);

// -------------------------
// PC + 4 Adder
// -------------------------
PC_Adder PC_Adder (
    .A (PCF),
    .B (32'd4),
    .Y (PCPlus4F)
);

// IF/ID Pipeline Register
always @(posedge clk) begin
    if (rst) begin
        InstrF_reg   <= 32'h00000000;
        PCF_reg      <= 32'h00000000;
        PCPlus4F_reg <= 32'h00000000;
    end
    else begin
        InstrF_reg   <= RDF;
        PCF_reg      <= PCF;
        PCPlus4F_reg <= PCPlus4F;
    end
end

// Outputs to Decode stage
assign InstrD   = InstrF_reg;
assign PCD      = PCF_reg;
assign PCPlus4D = PCPlus4F_reg;

endmodule
