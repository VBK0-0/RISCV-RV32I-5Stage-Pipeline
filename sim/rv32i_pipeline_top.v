`timescale 1ns/1ps

module rv32i_pipeline_top(
    input clk,
    input reset
);

//////////////////// GLOBAL CONTROL ////////////////////

wire pc_stall;
wire if_id_stall;
wire id_ex_flush;
wire if_flush;

//////////////////// IF STAGE ////////////////////

wire [31:0] pc;
wire [31:0] pc_next;
wire [31:0] instr;

//////////////////// IF/ID ////////////////////

wire [31:0] if_id_pc;
wire [31:0] if_id_instr;

//////////////////// ID STAGE ////////////////////

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;

wire [31:0] rd1;
wire [31:0] rd2;
wire [31:0] imm;

wire reg_write;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire alu_src;
wire branch;
wire jump;

wire [3:0] alu_ctrl;

//////////////////// ID/EX ////////////////////

wire [31:0] id_ex_pc;
wire [31:0] id_ex_rd1;
wire [31:0] id_ex_rd2;
wire [31:0] id_ex_imm;

wire [4:0] id_ex_rs1;
wire [4:0] id_ex_rs2;
wire [4:0] id_ex_rd;

wire [2:0] id_ex_funct3;

wire id_ex_reg_write;
wire id_ex_mem_read;
wire id_ex_mem_write;
wire id_ex_mem_to_reg;
wire id_ex_alu_src;
wire id_ex_branch;
wire id_ex_jump;

wire [3:0] id_ex_alu_ctrl;

//////////////////// EX ////////////////////

wire [1:0] forwardA;
wire [1:0] forwardB;

wire [31:0] alu_in1;
wire [31:0] alu_in2_raw;
wire [31:0] alu_in2;

wire [31:0] alu_result;

wire branch_taken;
wire [31:0] branch_target;

//////////////////// EX/MEM ////////////////////

wire branch_taken_final;

wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_write_data;
wire [31:0] ex_mem_branch_target;

wire ex_mem_branch_taken;

wire [4:0] ex_mem_rd;
wire [2:0] ex_mem_funct3;

wire ex_mem_reg_write;
wire ex_mem_mem_read;
wire ex_mem_mem_write;
wire ex_mem_mem_to_reg;
wire ex_mem_branch;
wire ex_mem_jump;

//////////////////// MEM ////////////////////

wire [31:0] mem_data;

//////////////////// MEM/WB ////////////////////

wire [31:0] mem_wb_mem_data;
wire [31:0] mem_wb_alu_result;

wire [4:0] mem_wb_rd;

wire mem_wb_reg_write;
wire mem_wb_mem_to_reg;

//////////////////// WB ////////////////////

wire [31:0] wb_data;

////////////////////////////////////////////////////////////
//////////////////////// IF STAGE //////////////////////////
////////////////////////////////////////////////////////////

pc PC(
    .clk(clk),
    .reset(reset),
    .enable(~pc_stall),
    .pc_next(pc_next),
    .pc(pc)
);

instr_mem IM(
    .addr(pc),
    .instr(instr)
);

////////////////////////////////////////////////////////////
/////////////////////// IF/ID REG //////////////////////////
////////////////////////////////////////////////////////////

if_id_reg IF_ID(
    .clk(clk),
    .reset(reset),
    .stall(if_id_stall),
    .flush(if_flush),
    .pc_in(pc),
    .instr_in(instr),
    .pc_out(if_id_pc),
    .instr_out(if_id_instr)
);

////////////////////////////////////////////////////////////
//////////////////////// ID STAGE //////////////////////////
////////////////////////////////////////////////////////////

assign rs1 = if_id_instr[19:15];
assign rs2 = if_id_instr[24:20];
assign rd  = if_id_instr[11:7];

reg_file RF(
    .clk(clk),
    .we(mem_wb_reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(mem_wb_rd),
    .wd(wb_data),
    .rd1(rd1),
    .rd2(rd2)
);

imm_gen IG(
    .instr(if_id_instr),
    .imm(imm)
);

control_unit CU(
    .opcode(if_id_instr[6:0]),
    .funct3(if_id_instr[14:12]),
    .funct7(if_id_instr[31:25]),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .branch(branch),
    .jump(jump),
    .alu_src(alu_src),
    .mem_to_reg(mem_to_reg),
    .alu_ctrl(alu_ctrl)
);

////////////////////////////////////////////////////////////
//////////////////// HAZARD DETECTION //////////////////////
////////////////////////////////////////////////////////////

hazard_detection_unit HDU(
    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_rd(id_ex_rd),
    .if_id_rs1(rs1),
    .if_id_rs2(rs2),
    .pc_stall(pc_stall),
    .if_id_stall(if_id_stall),
    .id_ex_flush(id_ex_flush)
);

////////////////////////////////////////////////////////////
//////////////////////// ID/EX REG /////////////////////////
////////////////////////////////////////////////////////////

id_ex_reg ID_EX(
    .clk(clk),
    .reset(reset),
    .flush(id_ex_flush| if_flush),

    .pc_in(if_id_pc),
    .rd1_in(rd1),
    .rd2_in(rd2),
    .imm_in(imm),

    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(rd),

    .funct3_in(if_id_instr[14:12]),

    .reg_write_in(reg_write),
    .mem_read_in(mem_read),
    .mem_write_in(mem_write),
    .mem_to_reg_in(mem_to_reg),
    .alu_src_in(alu_src),
    .branch_in(branch),
    .jump_in(jump),
    .alu_ctrl_in(alu_ctrl),

    .pc_out(id_ex_pc),
    .rd1_out(id_ex_rd1),
    .rd2_out(id_ex_rd2),
    .imm_out(id_ex_imm),

    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),
    .rd_out(id_ex_rd),

    .funct3_out(id_ex_funct3),

    .reg_write_out(id_ex_reg_write),
    .mem_read_out(id_ex_mem_read),
    .mem_write_out(id_ex_mem_write),
    .mem_to_reg_out(id_ex_mem_to_reg),
    .alu_src_out(id_ex_alu_src),
    .branch_out(id_ex_branch),
    .jump_out(id_ex_jump),
    .alu_ctrl_out(id_ex_alu_ctrl)
);

////////////////////////////////////////////////////////////
//////////////////// FORWARDING UNIT ///////////////////////
////////////////////////////////////////////////////////////

forwarding_unit FU(
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

////////////////////////////////////////////////////////////
//////////////////////// EX STAGE //////////////////////////
////////////////////////////////////////////////////////////

assign alu_in1 =
        (forwardA==2'b10) ? ex_mem_alu_result :
        (forwardA==2'b01) ? wb_data :
                            id_ex_rd1;

assign alu_in2_raw =
        (forwardB==2'b10) ? ex_mem_alu_result :
        (forwardB==2'b01) ? wb_data :
                            id_ex_rd2;

assign alu_in2 = id_ex_alu_src ? id_ex_imm : alu_in2_raw;

alu ALU(
    .a(alu_in1),
    .b(alu_in2),
    .alu_ctrl(id_ex_alu_ctrl),
    .result(alu_result)
);

branch_unit BU(
    .a(alu_in1),
    .b(alu_in2_raw),
    .funct3(id_ex_funct3),
    .take_branch(branch_taken)
);

// Determine if we are doing a JALR (alu_src=1) or JAL (alu_src=0)
// JALR uses the ALU result (rs1 + imm), but forces the LSB to 0.
assign branch_target = (id_ex_jump && id_ex_alu_src) ? {alu_result[31:1], 1'b0} : (id_ex_pc + id_ex_imm);

// Calculate the return address (PC + 4) to save in 'rd'
wire [31:0] return_addr = id_ex_pc + 4;

// If it's a jump, send the return address down the pipeline instead of the math result
wire [31:0] final_ex_val = id_ex_jump ? return_addr : alu_result;

////////////////////////////////////////////////////////////
//////////////////////// EX/MEM REG ////////////////////////
////////////////////////////////////////////////////////////

ex_mem_reg EX_MEM(
    .clk(clk),
    .reset(reset),
    .flush(1'b0),
    
    .alu_result_in(final_ex_val),
    .write_data_in(alu_in2_raw),

    .branch_target_in(branch_target),
    .zero_in(branch_taken),

    .rd_in(id_ex_rd),
    .funct3_in(id_ex_funct3),

    .reg_write_in(id_ex_reg_write),
    .mem_read_in(id_ex_mem_read),
    .mem_write_in(id_ex_mem_write),
    .mem_to_reg_in(id_ex_mem_to_reg),
    .branch_in(id_ex_branch),
    .jump_in(id_ex_jump),

    .alu_result_out(ex_mem_alu_result),
    .write_data_out(ex_mem_write_data),

    .branch_target_out(ex_mem_branch_target),
    .zero_out(ex_mem_branch_taken),

    .rd_out(ex_mem_rd),
    .funct3_out(ex_mem_funct3),

    .reg_write_out(ex_mem_reg_write),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write),
    .mem_to_reg_out(ex_mem_mem_to_reg),
    .branch_out(ex_mem_branch),
    .jump_out(ex_mem_jump)
);

////////////////////////////////////////////////////////////
//////////////////////// MEM ///////////////////////////////
////////////////////////////////////////////////////////////

data_mem DM(
    .clk(clk),
    .mem_read(ex_mem_mem_read),
    .mem_write(ex_mem_mem_write),
    .funct3(ex_mem_funct3),
    .addr(ex_mem_alu_result),
    .write_data(ex_mem_write_data),
    .read_data(mem_data)
);

////////////////////////////////////////////////////////////
//////////////////////// MEM/WB ////////////////////////////
////////////////////////////////////////////////////////////

mem_wb_reg MEM_WB(
    .clk(clk),
    .reset(reset),

    .mem_data_in(mem_data),
    .alu_result_in(ex_mem_alu_result),

    .rd_in(ex_mem_rd),

    .reg_write_in(ex_mem_reg_write),
    .mem_to_reg_in(ex_mem_mem_to_reg),

    .mem_data_out(mem_wb_mem_data),
    .alu_result_out(mem_wb_alu_result),

    .rd_out(mem_wb_rd),

    .reg_write_out(mem_wb_reg_write),
    .mem_to_reg_out(mem_wb_mem_to_reg)
);

////////////////////////////////////////////////////////////
//////////////////////// WRITEBACK /////////////////////////
////////////////////////////////////////////////////////////

assign wb_data =
        mem_wb_mem_to_reg ?
        mem_wb_mem_data :
        mem_wb_alu_result;

////////////////////////////////////////////////////////////
//////////////////////// PC UPDATE /////////////////////////
////////////////////////////////////////////////////////////

// PC UPDATE LOGIC
// Trigger a branch if a conditional branch is taken, OR if it's an unconditional jump
assign branch_taken_final = (id_ex_branch && branch_taken) || id_ex_jump;

assign pc_next = branch_taken_final ? branch_target : pc + 4;
assign if_flush = branch_taken_final;

endmodule
