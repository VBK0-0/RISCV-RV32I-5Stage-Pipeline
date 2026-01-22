`timescale 1ns / 1ps

module Register_File(
    input              clk,
    input              rst,
    input              WE_reg,
    input      [4:0]   A1, A2, A3,
    input      [31:0]  WD_reg,
    output     [31:0]  RD1, RD2
);

integer i;
reg [31:0] Register [31:0];

// ASYNCHRONOUS READ
// x0 must always read as zero
assign RD1 = (A1 == 5'd0) ? 32'b0 : Register[A1];
assign RD2 = (A2 == 5'd0) ? 32'b0 : Register[A2];

// SYNCHRONOUS WRITE + RESET
always @(posedge clk) begin
    if (rst) begin
        // Clear all registers on reset
        for (i = 0; i < 32; i = i + 1)
            Register[i] <= 32'b0;
    end
    else if (WE_reg && (A3 != 5'd0)) begin
        // Prevent write to x0
        Register[A3] <= WD_reg;
    end
end

endmodule
