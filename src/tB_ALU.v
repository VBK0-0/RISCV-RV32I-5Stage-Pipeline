`timescale 1ns / 1ps

module tB_ALU();

    reg  [31:0] A, B;
    reg  [2:0]  ALU_ctrl;
    wire [31:0] ALU_Result;
    wire Zero, Negative, Overflow, Carry;

    // DUT Instantiation
    ALU uut (
        .A(A),
        .B(B),
        .ALU_ctrl(ALU_ctrl),
        .ALU_Result(ALU_Result),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry)
    );

    // Task for stimulus
    task apply_vec(
        input [31:0] a,
        input [31:0] b,
        input [2:0] op
    );
    begin
        A = a;
        B = b;
        ALU_ctrl = op;
        #5; // wait for propagation
        $display("Time=%0t  A=%h  B=%h  OP=%b  Result=%h | Z=%b N=%b O=%b C=%b",
                 $time,A,B,ALU_ctrl,ALU_Result,Zero,Negative,Overflow,Carry);
    end
    endtask

    initial begin
        $display("----- ALU TEST START -----");

        // ADD (000)
        apply_vec(32'h00000005, 32'h00000003, 3'b000);
        apply_vec(32'h0000000A, 32'hFFFFFFFF, 3'b000);
        apply_vec(32'h7FFFFFFF, 32'h00000001, 3'b000); // Overflow case

        // SUB (001)
        apply_vec(32'h00000005, 32'h00000003, 3'b001);
        apply_vec(32'h00000000, 32'h00000001, 3'b001);
        apply_vec(32'h80000000, 32'h00000001, 3'b001); // Overflow case

        // AND (010)
        apply_vec(32'hF0F0F0F0, 32'h0F0F0F0F, 3'b010);

        // OR (011)
        apply_vec(32'hF0F0F0F0, 32'h0F0F0F0F, 3'b011);

        // SLT (101)
        apply_vec(32'h00000005, 32'h00000003, 3'b101);
        apply_vec(32'hFFFFFFFF, 32'h00000001, 3'b101); // negative vs positive

        $display("----- ALU TEST END -----");
        $stop;
    end

endmodule

/*
----- ALU TEST START -----
Time=5000  A=00000005  B=00000003  OP=000  Result=00000008 | Z=0 N=0 O=0 C=0
Time=10000  A=0000000a  B=ffffffff  OP=000  Result=00000009 | Z=0 N=0 O=0 C=1
Time=15000  A=7fffffff  B=00000001  OP=000  Result=80000000 | Z=0 N=1 O=1 C=0
Time=20000  A=00000005  B=00000003  OP=001  Result=00000002 | Z=0 N=0 O=0 C=0
Time=25000  A=00000000  B=00000001  OP=001  Result=ffffffff | Z=0 N=1 O=0 C=1
Time=30000  A=80000000  B=00000001  OP=001  Result=7fffffff | Z=0 N=0 O=1 C=0
Time=35000  A=f0f0f0f0  B=0f0f0f0f  OP=010  Result=00000000 | Z=1 N=0 O=0 C=0
Time=40000  A=f0f0f0f0  B=0f0f0f0f  OP=011  Result=ffffffff | Z=0 N=1 O=0 C=0
Time=45000  A=00000005  B=00000003  OP=101  Result=00000000 | Z=1 N=0 O=0 C=0
Time=50000  A=ffffffff  B=00000001  OP=101  Result=00000001 | Z=0 N=0 O=0 C=0
----- ALU TEST END -----
*/
