`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:40:46 08/29/2015 
// Design Name: 
// Module Name:    Multiplier_P 
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
module Multiplier_P
	//SINGLE PRECISION PARAMETER
	# (parameter W_Sgf = 23)
	//DOUBLE PRECISION PARAMETER
/* # (parameter W_Sgf = 52) */
	(
		input wire [W_Sgf:0] Data_A,
		input wire [W_Sgf:0] Data_B,
		output wire [2*W_Sgf+1:0] Result
    );

assign Result = Data_A*Data_B;

endmodule
