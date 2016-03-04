`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:39:21 08/18/2015 
// Design Name: 
// Module Name:    add_subtract 
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
module add_subtract
	# (parameter W = 8)
	(
		input wire op_mode, //0:Add, 1:Subtract
		input wire [W-1:0] Data_A,
		input wire [W-1:0] Data_B,
		output reg [W-1:0] Data_S  
    );

	always @*
		if(op_mode)
			Data_S <= Data_A - Data_B;
		else
			Data_S <= Data_A + Data_B;

endmodule
