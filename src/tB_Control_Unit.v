`timescale 1ns / 1ps

module tB_Control_Unit();
    // Inputs
    reg [6:0] Op;
    reg [6:0] funct7;
    reg [2:0] funct3;

    // Outputs
    wire RegWrite;
    wire MemWrite;
    wire ALUSrc;
    wire [1:0] ImmSrc;
    wire [1:0] ResultSrc;
    wire [2:0] ALU_Ctrl;
    wire Branch;
    wire Jump;

    // DUT instantiation
    Control_Unit DUT (
        .Op(Op),
        .funct7(funct7),
        .funct3(funct3),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALU_Ctrl(ALU_Ctrl),
        .Branch(Branch),
        .Jump(Jump)
    );

    // Display task
    task display_outputs;
        begin
            $display(
                "Time=%0t | Op=%b funct3=%b funct7=%b | RegW=%b MemW=%b ALUSrc=%b ImmSrc=%b ResultSrc=%b ALU_Ctrl=%b Branch=%b Jump=%b",
                $time, Op, funct3, funct7,
                RegWrite, MemWrite, ALUSrc, ImmSrc,
                ResultSrc, ALU_Ctrl, Branch, Jump
            );
        end
    endtask

    initial begin
        $display("----- CONTROL UNIT TEST START -----");

        // ================================
        // R-Type: ADD
        // ================================
        Op      = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10 display_outputs();

        // R-Type: SUB
        funct7 = 7'b0100000;
        #10 display_outputs();

        // ================================
        // I-Type: ADDI
        // ================================
        Op      = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10 display_outputs();

        // ================================
        // Load: LW
        // ================================
        Op      = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10 display_outputs();

        // ================================
        // Store: SW
        // ================================
        Op      = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10 display_outputs();

        // ================================
        // Branch: BEQ
        // ================================
        Op      = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10 display_outputs();

        // ================================
        // Jump: JAL
        // ================================
        Op      = 7'b1101111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10 display_outputs();

        $display("----- CONTROL UNIT TEST END -----");
        $finish;
    end

endmodule

/*
----- CONTROL UNIT TEST START -----
Time=10000 | Op=0110011 funct3=000 funct7=0000000 | RegW=1 MemW=0 ALUSrc=0 ImmSrc=xx ResultSrc=00 ALU_Ctrl=000 Branch=0 Jump=0  // ADD
Time=20000 | Op=0110011 funct3=000 funct7=0100000 | RegW=1 MemW=0 ALUSrc=0 ImmSrc=xx ResultSrc=00 ALU_Ctrl=001 Branch=0 Jump=0  // SUB
Time=30000 | Op=0010011 funct3=000 funct7=0000000 | RegW=1 MemW=0 ALUSrc=1 ImmSrc=00 ResultSrc=00 ALU_Ctrl=000 Branch=0 Jump=0  // ADDI
Time=40000 | Op=0000011 funct3=010 funct7=0000000 | RegW=1 MemW=0 ALUSrc=1 ImmSrc=00 ResultSrc=01 ALU_Ctrl=000 Branch=0 Jump=0  // LW
Time=50000 | Op=0100011 funct3=010 funct7=0000000 | RegW=0 MemW=1 ALUSrc=1 ImmSrc=01 ResultSrc=xx ALU_Ctrl=000 Branch=0 Jump=0  // SW
Time=60000 | Op=1100011 funct3=000 funct7=0000000 | RegW=0 MemW=0 ALUSrc=0 ImmSrc=10 ResultSrc=00 ALU_Ctrl=001 Branch=1 Jump=0  // BEQ
Time=70000 | Op=1101111 funct3=000 funct7=0000000 | RegW=1 MemW=0 ALUSrc=x ImmSrc=11 ResultSrc=10 ALU_Ctrl=000 Branch=0 Jump=1  // JAL
----- CONTROL UNIT TEST END -----
