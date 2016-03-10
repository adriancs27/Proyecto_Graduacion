`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2016 13:33:09
// Design Name: 
// Module Name: SHIFT_REG_32Bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SHIFT_REG_32Bits(
input RST,
input CLK,
input SL,
input SR,
input [1:0] S,
input [31:0] D,
output [31:0] Q
);
// S{11=carga , 10=despla iz , 01= despla der , 00= hold}
reg [31:0] Q;
always @(posedge CLK)
if (RST == 1) Q <= 0;
else 
    begin
    if (S== 2'b11) Q<=D;
    else if (S== 2'b10) Q<={Q[30:0],SL};
    else if (S== 2'b01) Q<={SR,Q[31:1]};
    end
endmodule
