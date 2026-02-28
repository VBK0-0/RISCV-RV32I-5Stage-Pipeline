module branch_unit (
    input [31:0] a,
    input [31:0] b,
    input [2:0]  funct3,
    output reg take_branch
);

always @(*) begin
    case (funct3)
        3'b000: take_branch = (a == b);                       // BEQ
        3'b001: take_branch = (a != b);                       // BNE
        3'b100: take_branch = ($signed(a) < $signed(b));      // BLT
        3'b101: take_branch = ($signed(a) >= $signed(b));     // BGE
        3'b110: take_branch = (a < b);                        // BLTU
        3'b111: take_branch = (a >= b);                       // BGEU
        default: take_branch = 0;
    endcase
end

endmodule
