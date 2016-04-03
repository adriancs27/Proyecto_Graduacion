`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2016 11:44:04
// Design Name: 
// Module Name: FF_D_N
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


module FF_D_N(
input wire CLK, //RELOJ DEL SISTEMA
input wire RST, //RESET
input wire EN, //ENABLE
input wire D, //ENTRADA
output reg Q //SALIDA
);

always @(negedge CLK)
begin
    if(RST)
        Q <= 0;
    else if(EN)
        Q <= D;
    else
        Q <= Q;
end

endmodule