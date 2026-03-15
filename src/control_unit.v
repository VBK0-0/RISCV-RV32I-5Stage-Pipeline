`timescale 1ns/1ps

module control_unit (

    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg jump,
    output reg alu_src,
    output reg mem_to_reg,
    output reg [3:0] alu_ctrl
);

always @(*) begin

    // defaults
    reg_write  = 0;
    mem_read   = 0;
    mem_write  = 0;
    branch     = 0;
    jump       = 0;
    alu_src    = 0;
    mem_to_reg = 0;
    alu_ctrl   = 4'b0000;

    case (opcode)

    // ---------------- R TYPE ----------------
    7'b0110011: begin
        reg_write = 1;

        case ({funct7,funct3})

        10'b0000000000: alu_ctrl = 4'b0000; // ADD
        10'b0100000000: alu_ctrl = 4'b0001; // SUB
        10'b0000000111: alu_ctrl = 4'b0010; // AND
        10'b0000000110: alu_ctrl = 4'b0011; // OR
        10'b0000000100: alu_ctrl = 4'b0100; // XOR
        10'b0000000001: alu_ctrl = 4'b0101; // SLL
        10'b0000000101: alu_ctrl = 4'b0110; // SRL
        10'b0100000101: alu_ctrl = 4'b0111; // SRA
        10'b0000000010: alu_ctrl = 4'b1000; // SLT
        10'b0000000011: alu_ctrl = 4'b1001; // SLTU

        endcase
    end

    // ---------------- I TYPE ----------------
    7'b0010011: begin

        reg_write = 1;
        alu_src   = 1;

        case (funct3)

        3'b000: alu_ctrl = 4'b0000; // ADDI
        3'b010: alu_ctrl = 4'b1000; // SLTI
        3'b011: alu_ctrl = 4'b1001; // SLTIU
        3'b100: alu_ctrl = 4'b0100; // XORI
        3'b110: alu_ctrl = 4'b0011; // ORI
        3'b111: alu_ctrl = 4'b0010; // ANDI
        3'b001: alu_ctrl = 4'b0101; // SLLI
        3'b101: alu_ctrl = funct7[5] ? 4'b0111 : 4'b0110; // SRAI/SRLI

        endcase
    end

    // ---------------- LOAD ----------------
    7'b0000011: begin
        reg_write  = 1;
        mem_read   = 1;
        alu_src    = 1;
        mem_to_reg = 1;
        alu_ctrl   = 4'b0000;
    end

    // ---------------- STORE ----------------
    7'b0100011: begin
        mem_write = 1;
        alu_src   = 1;
        alu_ctrl  = 4'b0000;
    end

    // ---------------- BRANCH ----------------
    7'b1100011: begin
        branch   = 1;
        alu_ctrl = 4'b0001;
    end

    // ---------------- JAL ----------------
    7'b1101111: begin
        reg_write = 1;
        jump      = 1;
    end

    // ---------------- JALR ----------------
    7'b1100111: begin
        reg_write = 1;
        jump      = 1;
        alu_src   = 1;
    end

    // ---------------- LUI ----------------
    7'b0110111: begin
        reg_write = 1;
    end

    // ---------------- AUIPC ----------------
    7'b0010111: begin
        reg_write = 1;
    end

    endcase

end

endmodule
