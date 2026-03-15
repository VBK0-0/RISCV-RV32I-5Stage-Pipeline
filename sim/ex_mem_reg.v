`timescale 1ns/1ps

module ex_mem_reg (
    input clk,
    input reset,
    input flush,

    input  [31:0] alu_result_in,
    input  [31:0] write_data_in,
    input  [31:0] branch_target_in,
    input         zero_in,
    input  [4:0]  rd_in,
    input  [2:0]  funct3_in,

    input  reg_write_in,
    input  mem_read_in,
    input  mem_write_in,
    input  mem_to_reg_in,
    input  branch_in,
    input  jump_in,

    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [31:0] branch_target_out,
    output reg        zero_out,
    output reg [4:0]  rd_out,
    output reg [2:0]  funct3_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg branch_out,
    output reg jump_out
);

always @(posedge clk or posedge reset) begin
    if (reset || flush) begin
        alu_result_out <= 0;
        write_data_out <= 0;
        branch_target_out <= 0;
        zero_out <= 0;
        rd_out <= 0;
        funct3_out <= 0;

        reg_write_out <= 0;
        mem_read_out <= 0;
        mem_write_out <= 0;
        mem_to_reg_out <= 0;
        branch_out <= 0;
        jump_out <= 0;
    end
    else begin
        alu_result_out <= alu_result_in;
        write_data_out <= write_data_in;
        branch_target_out <= branch_target_in;
        zero_out <= zero_in;
        rd_out <= rd_in;
        funct3_out <= funct3_in;

        reg_write_out <= reg_write_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        branch_out <= branch_in;
        jump_out <= jump_in;
    end
end

endmodule
