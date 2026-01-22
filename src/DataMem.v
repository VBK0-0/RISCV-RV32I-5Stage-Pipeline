`timescale 1ns / 1ps

module DataMem(clk,A,WE_dm,WD_dm,RD_dm);

//Input Declaration
input [31:0] A;
input clk,WE_dm;
input [31:0] WD_dm;
output [31:0] RD_dm;

reg [31:0] DataMemory [1023:0];

assign RD_dm = (WE_dm == 1'b0) ? DataMemory[A] : 32'h00000000;  

always @(posedge clk)begin
    if(WE_dm)begin
        DataMemory[A] <= WD_dm;
    end       
end
integer i;
initial begin
    for(i=0;i<1024;i=i+1)begin
        DataMemory[i] <= 32'h00000000;
    end
        DataMemory[40] <= 32'h00000006;

end

endmodule
