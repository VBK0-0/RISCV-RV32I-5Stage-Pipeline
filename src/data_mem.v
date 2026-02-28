module data_mem (
    input clk,
    input mem_read,
    input mem_write,
    input [2:0] funct3,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    reg [7:0] memory [0:4095];

    always @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b000: memory[addr] <= write_data[7:0]; // SB
                3'b001: begin                             // SH
                    memory[addr]   <= write_data[7:0];
                    memory[addr+1] <= write_data[15:8];
                end
                3'b010: begin                             // SW
                    memory[addr]   <= write_data[7:0];
                    memory[addr+1] <= write_data[15:8];
                    memory[addr+2] <= write_data[23:16];
                    memory[addr+3] <= write_data[31:24];
                end
            endcase
        end
    end

    always @(*) begin
        if (mem_read) begin
            case (funct3)
                3'b000: read_data = {{24{memory[addr][7]}}, memory[addr]}; // LB
                3'b001: read_data = {{16{memory[addr+1][7]}},
                                      memory[addr+1], memory[addr]};       // LH
                3'b010: read_data = {memory[addr+3], memory[addr+2],
                                     memory[addr+1], memory[addr]};        // LW
                3'b100: read_data = {24'b0, memory[addr]};                 // LBU
                3'b101: read_data = {16'b0, memory[addr+1], memory[addr]}; // LHU
                default: read_data = 32'b0;
            endcase
        end
        else read_data = 32'b0;
    end
endmodule
