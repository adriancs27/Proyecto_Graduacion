`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2016 15:30:59
// Design Name: 
// Module Name: S_ADD_FLOAT
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


module S_ADD_FLOAT(
    input wire [8:0] A, //ENTRADA A
    input wire [8:0] B,  //ENTRADA B

    output wire [P-1:0] Y //SALIDA Y
);

    assign Y = A+B; //SUMA DE ENTRADAS

endmodule
