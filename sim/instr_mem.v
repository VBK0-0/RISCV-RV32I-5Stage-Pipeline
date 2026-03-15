`timescale 1ns/1ps

module instr_mem (
    input  [31:0] addr,
    output [31:0] instr
);
    reg [31:0] memory [0:1023];

    initial begin
        $readmemh("C:/Kittu/M.Tech_NITR_EIE/RISC_V/Codes_new_store/test.hex", memory);
    end 
    assign instr = memory[addr[11:2]]; // word aligned
endmodule
