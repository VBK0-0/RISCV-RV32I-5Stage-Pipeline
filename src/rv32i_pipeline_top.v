`timescale 1ns/1ps

module rv32i_pipeline_top (
    input clk,
    input reset
);

// =====================
// IF STAGE
// =====================

wire [31:0] pc, pc_next, instr;
wire pc_stall;

pc PC(clk, reset, pc_stall ? pc : pc_next, pc);
instr_mem IM(pc, instr);

// =====================
// IF/ID
// =====================

wire [31:0] if_id_pc, if_id_instr;
wire if_id_stall, if_flush;

if_id_reg IF_ID(
    clk, reset,
    if_id_stall,
    if_flush,
    pc, instr,
    if_id_pc, if_id_instr
);

// =====================
// ID STAGE
// =====================

wire [4:0] rs1 = if_id_instr[19:15];
wire [4:0] rs2 = if_id_instr[24:20];
wire [4:0] rd  = if_id_instr[11:7];

wire [31:0] rd1, rd2, imm;

reg_file RF(
    clk,
    mem_wb_reg_write,
    rs1, rs2,
    mem_wb_rd,
    wb_data,
    rd1, rd2
);

imm_gen IG(if_id_instr, imm);

// Control
wire reg_write, mem_read, mem_write;
wire mem_to_reg, alu_src, branch, jump;
wire [3:0] alu_ctrl;

control_unit CU(
    if_id_instr[6:0],
    if_id_instr[14:12],
    if_id_instr[31:25],
    reg_write, mem_read, mem_write,
    branch, jump,
    alu_src, mem_to_reg,
    alu_ctrl
);

// =====================
// ID/EX
// =====================

wire id_ex_flush;

wire [31:0] id_ex_pc, id_ex_rd1, id_ex_rd2, id_ex_imm;
wire [4:0]  id_ex_rs1, id_ex_rs2, id_ex_rd;
wire [2:0]  id_ex_funct3;

wire id_ex_reg_write, id_ex_mem_read, id_ex_mem_write;
wire id_ex_mem_to_reg, id_ex_alu_src, id_ex_branch, id_ex_jump;
wire [3:0] id_ex_alu_ctrl;

id_ex_reg ID_EX(
    clk, reset, id_ex_flush,
    if_id_pc, rd1, rd2, imm,
    rs1, rs2, rd,
    if_id_instr[14:12],

    reg_write, mem_read, mem_write,
    mem_to_reg, alu_src,
    branch, jump,
    alu_ctrl,

    id_ex_pc, id_ex_rd1, id_ex_rd2, id_ex_imm,
    id_ex_rs1, id_ex_rs2, id_ex_rd,
    id_ex_funct3,

    id_ex_reg_write, id_ex_mem_read, id_ex_mem_write,
    id_ex_mem_to_reg, id_ex_alu_src,
    id_ex_branch, id_ex_jump,
    id_ex_alu_ctrl
);

// =====================
// HAZARD UNIT
// =====================

hazard_detection_unit HDU(
    id_ex_mem_read,
    id_ex_rd,
    rs1,
    rs2,
    pc_stall,
    if_id_stall,
    id_ex_flush
);

// =====================
// FORWARDING
// =====================

wire [1:0] forwardA, forwardB;

forwarding_unit FU(
    id_ex_rs1,
    id_ex_rs2,
    ex_mem_rd,
    ex_mem_reg_write,
    mem_wb_rd,
    mem_wb_reg_write,
    forwardA,
    forwardB
);

// Forward muxes

wire [31:0] alu_in1 =
    (forwardA == 2'b10) ? ex_mem_alu_result :
    (forwardA == 2'b01) ? wb_data :
                          id_ex_rd1;

wire [31:0] alu_in2_raw =
    (forwardB == 2'b10) ? ex_mem_alu_result :
    (forwardB == 2'b01) ? wb_data :
                          id_ex_rd2;

wire [31:0] alu_in2 =
    id_ex_alu_src ? id_ex_imm : alu_in2_raw;

// =====================
// EX STAGE
// =====================

wire [31:0] alu_result;

alu ALU(
    alu_in1,
    alu_in2,
    id_ex_alu_ctrl,
    alu_result
);

wire branch_taken;

branch_unit BU(
    alu_in1,
    alu_in2_raw,
    id_ex_funct3,
    branch_taken
);

wire [31:0] branch_target =
    id_ex_pc + id_ex_imm;

// =====================
// EX/MEM
// =====================

wire [31:0] ex_mem_alu_result, ex_mem_write_data;
wire [4:0]  ex_mem_rd;
wire ex_mem_reg_write, ex_mem_mem_read, ex_mem_mem_write;
wire ex_mem_mem_to_reg;

ex_mem_reg EX_MEM(
    clk, reset,
    alu_result,
    alu_in2_raw,
    branch_target,
    branch_taken,
    id_ex_rd,
    id_ex_funct3,

    id_ex_reg_write,
    id_ex_mem_read,
    id_ex_mem_write,
    id_ex_mem_to_reg,
    id_ex_branch,
    id_ex_jump,

    ex_mem_alu_result,
    ex_mem_write_data,
    ,
    ,
    ex_mem_rd,
    ,
    ex_mem_reg_write,
    ex_mem_mem_read,
    ex_mem_mem_write,
    ex_mem_mem_to_reg,
    ,
    
);

// =====================
// MEM STAGE
// =====================

wire [31:0] mem_data;

data_mem DM(
    clk,
    ex_mem_mem_read,
    ex_mem_mem_write,
    3'b010,
    ex_mem_alu_result,
    ex_mem_write_data,
    mem_data
);

// =====================
// MEM/WB
// =====================

wire [31:0] mem_wb_mem_data, mem_wb_alu_result;
wire [4:0]  mem_wb_rd;
wire mem_wb_reg_write, mem_wb_mem_to_reg;

mem_wb_reg MEM_WB(
    clk, reset,
    mem_data,
    ex_mem_alu_result,
    ex_mem_rd,
    ex_mem_reg_write,
    ex_mem_mem_to_reg,

    mem_wb_mem_data,
    mem_wb_alu_result,
    mem_wb_rd,
    mem_wb_reg_write,
    mem_wb_mem_to_reg
);

// Writeback

wire [31:0] wb_data =
    mem_wb_mem_to_reg ? mem_wb_mem_data :
                        mem_wb_alu_result;

// =====================
// PC UPDATE
// =====================

assign pc_next =
    (id_ex_branch && branch_taken) ? branch_target :
    id_ex_jump ? branch_target :
    pc + 4;

assign if_flush =
    (id_ex_branch && branch_taken) || id_ex_jump;

endmodule
