`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:49 08/20/2015 
// Design Name: 
// Module Name:    Decoder_4_1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Decoder_4_1(
	input wire [1:0] round_mode,
	input wire [1:0] lsbs_sgf_n,
	input wire Sgn_M, //It's necessary to know if you are rounding a negative or positive number
	output reg ctrl //control signal mux --- control of the rounded significand
    );

always @*
  case ({Sgn_M,round_mode,lsbs_sgf_n})
 // Round to infinity - (Round down)
//1'b0: Let pass the significand without rounding
//1'b1: Let pass the rounded significand

//Round towards - infinity
//0: positive number ; 01: Round towards - inifnity ; XX rounding bits

	//Positive Number
	5'b00100: ctrl <= 1'b0;
	5'b00101: ctrl <= 1'b0;
	5'b00110: ctrl <= 1'b0;
	5'b00111: ctrl <= 1'b0;

	//Negative Number
	
	5'b10100: ctrl <= 1'b0;
	5'b10101: ctrl <= 1'b1;
	5'b10110: ctrl <= 1'b1;
	5'b10111: ctrl <= 1'b1;
	
//Round towards + infinity 

	//Positive Number
	
	5'b01000: ctrl <= 1'b0;
	5'b01001: ctrl <= 1'b1;
	5'b01010: ctrl <= 1'b1;
	5'b01011: ctrl <= 1'b1;
	
	//Negative Number
	
	5'b11000: ctrl <= 1'b0;
	5'b11001: ctrl <= 1'b0;
	5'b11010: ctrl <= 1'b0;
	5'b11011: ctrl <= 1'b0;
	
   default: ctrl <= 1'b0; //Truncation
   endcase
			
endmodule
