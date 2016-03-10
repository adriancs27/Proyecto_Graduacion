`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2016 11:57:49
// Design Name: 
// Module Name: REG_8Bits
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


module REG_8Bits(
input wire CLK, //RELOJ DEL SISTEMA
input wire RST, //RESET
input wire EN, //ENABLE
input wire [7:0] D, //ENTRADA
output reg [7:0] Q //SALIDA
);

always @(negedge CLK, RST)
begin
    if(RST)
        Q <= 0;
    else if(EN)
        Q <= D;
    else
        Q <= Q; 
end

endmodule