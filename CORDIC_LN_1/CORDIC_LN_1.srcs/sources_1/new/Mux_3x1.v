`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITCR
// Engineer: ADRIAN CERVANTES S
// 
// 
// Module Name: Mux_3x1
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


module Mux_3x1 #(parameter P=32) //MULTIPLEXOR 3X1 DE 32 BITS
(
//Input Signals
input wire [1:0] MS,
input wire [P-1:0] D_0, //DATO DE EN LA ENTRADA 0
input wire [P-1:0] D_1, //DATO DE EN LA ENTRADA 1
input wire [P-1:0] D_2, //DATO DE EN LA ENTRADA 2

//Output Signals
output reg [P-1:0] D_out //SALIDA
);

    always @*
        begin
            case(MS)
                2'b00: D_out = D_0;
                2'b01: D_out = D_1;
                2'b10: D_out = D_2;
                default : D_out = D_0;
            endcase
        end

endmodule
