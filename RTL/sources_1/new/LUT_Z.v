`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2016 14:20:17
// Design Name: 
// Module Name: LUT_Z
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


module LUT_Z#(parameter P = 32, parameter D = 5) ( 

input wire CLK, 
input wire EN_ROM1,
input wire [D-1:0] ADRS,
output reg [P-1:0] O_D
);
   
always @(posedge CLK)
      if (EN_ROM1)
         case (ADRS)
            5'b00000: O_D <= 32'b10111111100011001001111101010100;
            5'b00001: O_D <= 32'b10111111000000101100010101111000;
            5'b00010: O_D <= 32'b10111110100000001010110001001001;
            5'b00011: O_D <= 32'b10111110000000000010101011000100;
            5'b00100: O_D <= 32'b10111110000000000010101011000100;
            5'b00101: O_D <= 32'b10111101100000000000101010101100;
            5'b00110: O_D <= 32'b10111101000000000000001010101011;
            5'b00111: O_D <= 32'b10111100100000000000000010101011;
            5'b01000: O_D <= 32'b10111100000000000000000000101011;
            5'b01001: O_D <= 32'b10111011010111100011010101000010;
            5'b01010: O_D <= 32'b10111011000000000000000000000011;
            5'b01011: O_D <= 32'b10111010100000000000000000000001;
            5'b01100: O_D <= 32'b10111010000000000000000000000000;
            5'b01101: O_D <= 32'b10111001100000000000000000000000;
            5'b01110: O_D <= 32'b10111001100000000000000000000000;
            5'b01111: O_D <= 32'b10111001000000000000000000000000;
            5'b10000: O_D <= 32'b10111000100000000000000000000000;
            5'b10001: O_D <= 32'b10111000000000000000000000000000;
            5'b10010: O_D <= 32'b10110111100000000000000000000000;
            5'b10011: O_D <= 32'b10110111000000000000000000000000;
            5'b10100: O_D <= 32'b10110110100000000000000000000000;
            5'b10101: O_D <= 32'b10110110000000000000000000000000;
            5'b10110: O_D <= 32'b10110101100000000000000000000000;
            5'b10111: O_D <= 32'b10110101000000000000000000000000;
            5'b11000: O_D <= 32'b10110100100000000000000000000000;
            5'b11001: O_D <= 32'b10110100000000000000000000000000;
            5'b11010: O_D <= 32'b10110011100000000000000000000000;
            5'b11011: O_D <= 32'b10110011000000000000000000000000;
            5'b11100: O_D <= 32'b10110010100000000000000000000000;
            5'b11101: O_D <= 32'b10110010000000000000000000000000;
            5'b11110: O_D <= 32'b10110001100000000000000000000000;
            5'b11111: O_D <= 32'b10110001000000000000000000000000;
            default:  O_D <= 32'b00000000000000000000000000000000;
         endcase	 
         
        else
            O_D <= 32'b00000000000000000000000000000000;
         
endmodule