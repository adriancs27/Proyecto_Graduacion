`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:23:30 08/17/2015 
// Design Name: 
// Module Name:    Invert_Sign 
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
module Invert_Sign
	# (parameter W = 32)
	(
		input wire inv_sign, //This signal indicates if Data requires a sign invertion
		input wire [W-1:0] Data, //Data Input
		output wire [W-1:0] Fixed_Data  //Data Output, it says fixed because a probably sign invertion of Data input
    );

	assign Fixed_Data = (inv_sign == 1'b1) ? {~Data[W-1],Data[W-2:0]} : Data;

endmodule
