`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:31:07 08/19/2015 
// Design Name: 
// Module Name:    Universal_Shift_RegisterAdd 
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
module Universal_Shift_Register
	# (parameter W = 8)
	(
		input wire clk, //System Clock
		input wire rst, //System Reset
		input wire shift_left, //1: shift Left ; 0:Shift Right
		input wire shift_right,
		input wire load, //Load D to Q
		input wire shift_in, //Value to shift in
		input wire [W-1:0] D, //Data input
		output reg [W-1:0] Q //Data output
    );

//Universal Shift Register Body
always @(posedge clk, posedge rst)
	if(rst)
		Q <= 0;
	else if(load)
		Q <= D;
	else if(shift_left) //Shift left
		Q <= {D[W-2:0],shift_in};
	else if(shift_right)//Shift Right
		Q <= {shift_in,D[W-1:1]};
	else
		Q <= Q;
endmodule
