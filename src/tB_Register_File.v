`timescale 1ns / 1ps

module tB_Register_File();
    reg clk;
    reg rst;
    reg WE_reg;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD_reg;

    wire [31:0] RD1, RD2;

    // Instantiate DUT
    Register_File dut (
        .clk    (clk),
        .rst    (rst),
        .WE_reg (WE_reg),
        .A1     (A1),
        .A2     (A2),
        .A3     (A3),
        .WD_reg (WD_reg),
        .RD1    (RD1),
        .RD2    (RD2)
    );

    // Clock Generation (10 ns)
    always #5 clk = ~clk;
    // Test Sequence
    initial begin
        clk    = 0;    // INITIAL CONDITIONS
        rst    = 1;
        WE_reg = 0;
        A1     = 0;
        A2     = 0;
        A3     = 0;
        WD_reg = 0;

        $display("\n===== REGISTER FILE TEST START =====\n");
        #12; // Wait for reset to take effect on posedge
      
        // TEST 1: RESET FUNCTIONALITY
        A1 = 5'd6;
        A2 = 5'd19;
        #1;

        $display("TEST 1: RESET ACTIVE");
        $display("RD1 = %h, RD2 = %h (Expected: 00000000, 00000000)",
                  RD1, RD2);

        rst = 0;        // Deassert reset
        #10;

        $display("\nTEST 2: AFTER RESET RELEASE");
        $display("RD1 = %h, RD2 = %h (Expected: 00000000, 00000000)",
                  RD1, RD2);

        // ----------------------------
        // TEST 3: NORMAL WRITE
        // ----------------------------
        WE_reg = 1;
        A3     = 5'd10;
        WD_reg = 32'hABCDEFAB;

        #10;  // wait for posedge

        WE_reg = 0;
        A1     = 5'd10;
        #1;

        $display("\nTEST 3: WRITE / READ REGISTER 10");

        // TEST 4: WRITE TO x0 (BLOCKED)
        WE_reg = 1;
        A3     = 5'd0;
        WD_reg = 32'hFFFFFFFF;

        #10;  // posedge

        WE_reg = 0;
        A1     = 5'd0;
        #1;

        $display("\nTEST 4: WRITE TO x0");
        $display("R0 = %h (Expected: 00000000)", RD1);

        // TEST 5: ASYNCHRONOUS READ
        A1 = 5'd10;   // written register
        A2 = 5'd20;   // never written
        #1;

        $display("\nTEST 5: ASYNCHRONOUS READ");
        $display("R10 = %h (Expected: abcdefab)", RD1);
        $display("R20 = %h (Expected: 00000000)", RD2);

        // TEST 6: MULTIPLE WRITES
        WE_reg = 1;

        A3 = 5'd5;   WD_reg = 32'h11111111; #10;
        A3 = 5'd6;   WD_reg = 32'h22222222; #10;
        A3 = 5'd7;   WD_reg = 32'h33333333; #10;

        WE_reg = 0;

        A1 = 5'd5;
        A2 = 5'd7;
        #1;

        $display("\nTEST 6: MULTIPLE WRITES");
        $display("R5 = %h (Expected: 11111111)", RD1);
        $display("R7 = %h (Expected: 33333333)", RD2);

        // END SIMULATION
        $display("\n===== REGISTER FILE TEST END =====\n");
        #20;
        $finish;
    end

endmodule

/*
===== REGISTER FILE TEST START =====

TEST 1: RESET ACTIVE
RD1 = 00000000, RD2 = 00000000 (Expected: 00000000, 00000000)

TEST 2: AFTER RESET RELEASE
RD1 = 00000000, RD2 = 00000000 (Expected: 00000000, 00000000)

TEST 3: WRITE / READ REGISTER 10

TEST 4: WRITE TO x0
R0 = 00000000 (Expected: 00000000)

TEST 5: ASYNCHRONOUS READ
R10 = abcdefab (Expected: abcdefab)
R20 = 00000000 (Expected: 00000000)

TEST 6: MULTIPLE WRITES
R5 = 11111111 (Expected: 11111111)
R7 = 33333333 (Expected: 33333333)

===== REGISTER FILE TEST END =====
*/
