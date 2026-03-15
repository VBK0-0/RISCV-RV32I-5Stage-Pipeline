`timescale 1ns/1ps

module if_id_reg (
    input clk,
    input reset,
    input stall,
    input flush,

    input  [31:0] pc_in,
    input  [31:0] instr_in,

    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_out    <= 32'b0;
        instr_out <= 32'b0;
    end
    else if (flush) begin
        pc_out    <= 32'b0;
        instr_out <= 32'b0;   // Insert bubble
    end
    else if (!stall) begin
        pc_out    <= pc_in;
        instr_out <= instr_in;
    end
end

endmodule

