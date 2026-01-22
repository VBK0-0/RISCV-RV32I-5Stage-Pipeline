`timescale 1ns / 1ps

module tB_Instruction_Mem();

    reg rst;
    reg [31:0] A;
    wire [31:0] RD;

    // Instantiate the Instruction Memory
    Instruction_Mem IM (
        .rst(rst),
        .A(A),
        .RD(RD)
    );

    integer i;

    initial begin
        // Initialize
        rst = 1;
        A = 0;

        #10;        // Wait 10 ns
        rst = 0;    // Release reset

        // Read first 10 instructions
        for(i=0; i<10; i=i+1) begin
            A = i*4;           // word-aligned address
            #10;               // wait for read
            $display("Addr = %0d, Instruction = %h", A, RD);
        end

        $finish;
    end

endmodule

/*
Addr = 0, Instruction = 00000013
Addr = 4, Instruction = 00100093
Addr = 8, Instruction = 00200113
Addr = 12, Instruction = 002081b3
Addr = 16, Instruction = 00310233
Addr = 20, Instruction = 00412023
Addr = 24, Instruction = 00010103
Addr = 28, Instruction = 00418663
Addr = 32, Instruction = 0000006f
Addr = 36, Instruction = 00000000
*/
