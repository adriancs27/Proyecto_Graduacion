`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:35:37 09/10/2015 
// Design Name: 
// Module Name:    Shift_Module_Param 
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
module Shift_Module_Param

	# (parameter W_Sgf = 23,
		parameter W_Exp = 8)
	
	(
	input wire [W_Exp-1:0] nshift,
	input wire [W_Sgf+2:0] sgfm,
	output wire [W_Sgf+2:0] sgfm_n
    );

	assign sgfm_n = sgfm >> nshift; 


endmodule
