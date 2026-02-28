`timescale 1ns/1ps

module tb_rv32i_pipeline;

reg clk;
reg reset;

rv32i_pipeline_top DUT (
    .clk(clk),
    .reset(reset)
);

// Clock generation (100MHz equivalent)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset sequence
initial begin
    reset = 1;
    #20;
    reset = 0;
end

// Monitor important signals
initial begin
    $dumpfile("rv32i.vcd");
    $dumpvars(0, tb_rv32i_pipeline);

    #500;

    $display("Register x1 = %d", DUT.RF.regs[1]);
    $display("Register x2 = %d", DUT.RF.regs[2]);
    $display("Register x3 = %d", DUT.RF.regs[3]);
    $display("Register x4 = %d", DUT.RF.regs[4]);
    $display("Register x6 = %d", DUT.RF.regs[6]);

    $finish;
end

endmodule
