`timescale 1ns / 1ps

module Program_counter(
    input              clk,
    input              rst,
    input      [31:0]   PCNext,
    output reg [31:0]   PC
);

always @(posedge clk) begin
    if (rst) begin
        PC <= 32'h00000000;   // Reset PC
    end
    else begin
        PC <= PCNext;         // Always update PC
    end
end

endmodule
