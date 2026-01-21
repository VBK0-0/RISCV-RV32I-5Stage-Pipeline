`timescale 1ns / 1ps

module Sign_Extender(Imm_In, Imm_En, Imm_Ext);
input [31:0] Imm_In;
input [1:0] Imm_En;
output [31:0] Imm_Ext;

assign Imm_Ext = (Imm_En == 2'b00) ? {{20{Imm_In[31]}}, Imm_In[31:20]} :  // I Type
                 (Imm_En == 2'b01) ? {{20{Imm_In[31]}}, Imm_In[31:25], Imm_In[11:7]} : // S Type
                 (Imm_En == 2'b10) ? {{19{Imm_In[31]}}, Imm_In[31], Imm_In[30:25], Imm_In[11:8],Imm_In[7], 1'b0} : // B Type
                 (Imm_En == 2'b11) ? {{11{Imm_In[31]}}, Imm_In[31], Imm_In[30:21],Imm_In[20], Imm_In[19:12], 1'b0} : // J Type
                 32'h00000000;

endmodule
