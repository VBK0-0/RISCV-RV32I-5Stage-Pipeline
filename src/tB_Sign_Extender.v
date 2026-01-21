`timescale 1ns / 1ps

module tB_Sign_Extender();
reg [31:0] Imm_In;
reg [1:0] Imm_En;
wire [31:0] Imm_Ext;

// Instantiate DUT
Sign_Extender dut(
    .Imm_In(Imm_In),
    .Imm_En(Imm_En),
    .Imm_Ext(Imm_Ext)
    );
    
initial begin
    $display("----- SIGN EXTENDER TEST START -----");
    $monitor("Time=%0t Imm_En=%b Imm_In=%h => Imm_Ext=%h",
              $time, Imm_En, Imm_In, Imm_Ext);
              
    // Test I-Type
    Imm_In = 32'hFFF00093;  // addi x1, x0, -1 example encoding
    Imm_En = 2'b00;
    #10;
    
    // Test S - Type
    Imm_In = 32'h00F12023;  // sw x15, 0(x2)
    Imm_En = 2'b01;
    #10;
    
    // Test B - Type
    Imm_In = 32'hFEF51AE3;  // bne x10, x15, -20
    Imm_En = 2'b10;
    #10;
    
    // Test J - Type
    Imm_In = 32'h004000EF; // jal x1, 4
    Imm_En = 2'b11;        // <-- J-Type
    #10;

    
    //Default/ Don't care condition
    Imm_In = 32'hAAAA_FFFF;
    Imm_En = 2'bxx;
    #10;
    
    $display("----- SIGN EXTENDER TEST END -----");
    $stop;
end  

endmodule

/*
----- SIGN EXTENDER TEST START -----
Time=0 Imm_En=00 Imm_In=fff00093 => Imm_Ext=ffffffff
Time=10000 Imm_En=01 Imm_In=00f12023 => Imm_Ext=00000000
Time=20000 Imm_En=10 Imm_In=fef51ae3 => Imm_Ext=ffffffea
Time=30000 Imm_En=11 Imm_In=004000ef => Imm_Ext=00000800
Time=40000 Imm_En=xx Imm_In=aaaaffff => Imm_Ext=xxxxxxxx
----- SIGN EXTENDER TEST END -----
*/
