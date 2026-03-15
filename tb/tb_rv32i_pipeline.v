`timescale 1ns/1ps

module tb_rv32i_pipeline;

reg clk;
reg reset;

integer i;
integer errors = 0;

// Expected register values
reg [31:0] expected [0:10];

rv32i_pipeline_top DUT (
    .clk(clk),
    .reset(reset)
);

////////////////////////////////////////////////////////////
// CLOCK
////////////////////////////////////////////////////////////

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

////////////////////////////////////////////////////////////
// RESET
////////////////////////////////////////////////////////////

initial begin
    reset = 1;
    #20;
    reset = 0;
end

////////////////////////////////////////////////////////////
// WAVEFORM
////////////////////////////////////////////////////////////

initial begin
    $dumpfile("rv32i.vcd");
    $dumpvars(0, tb_rv32i_pipeline);
end

////////////////////////////////////////////////////////////
// EXPECTED RESULTS
////////////////////////////////////////////////////////////

initial begin
    expected[1]  = 10;   // Set by addi
    expected[2]  = 20;   // Set by addi
    expected[3]  = 30;   // add x3, x1, x2 (Tests Forwarding)
    expected[4]  = 30;   // lw x4, 0(x0)
    expected[5]  = 40;   // add x5, x4, x1 (Tests Load-Use Stall)
    expected[6]  = 5;    // addi x6, x0, 5 (x6 = 99 should be flushed)
    expected[7]  = 15;   // add x7, x6, x1 (Target of taken branch)
    expected[8]  = 48;   // jal x8, 8 (Saves return address: hex 2C + 4 = 30 hex = 48 dec)
    expected[9]  = 0;    // Should remain 0 (instruction flushed by JAL)
    expected[10] = 48;   // addi x10, x8, 0 (Target of JAL)
end

////////////////////////////////////////////////////////////
// SELF CHECK
////////////////////////////////////////////////////////////

initial begin
    // Wait for the pipeline to drain (50 cycles is plenty)
    #500;

    $display("\n===== REGISTER CHECK =====");

    for(i=1; i<=10; i=i+1) begin
        if(DUT.RF.regs[i] !== expected[i]) begin
            $display("ERROR: x%0d = %0d (expected %0d)",
                     i, DUT.RF.regs[i], expected[i]);
            errors = errors + 1;
        end
        else begin
            $display("PASS : x%0d = %0d", i, DUT.RF.regs[i]);
        end
    end

    if(errors == 0)
        $display("\n***** TEST PASSED: All hazards resolved properly *****");
    else
        $display("\n***** TEST FAILED : %0d errors *****", errors);

    $finish;
end

endmodule