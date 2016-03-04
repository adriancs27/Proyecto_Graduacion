`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:06:01 10/01/2015 
// Design Name: 
// Module Name:    Zero_InfAdd_Unit 
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

//This modules is specially design to handle the zero condition on the add function
//the objective is to have a quick response to operations whose result will be a zero
//so, this is basically a module that compares both operands and considers if the 
//operation is an add or subtract to take decisions about the result 

module Zero_InfAdd_Unit

//SINGLE PRECISION PARAMETERS//////
	# (parameter W = 32) 
	
//DOUBLE PRECISION PARAMETERS//////
/*	# (parameter W = 64) */
	(
	//INPUTS
		input wire clk,
		input wire rst,
		input wire load,
		input wire [W-1:0] Data_A, //Data_A and Data_B are the operands
		input wire [W-1:0] Data_B, 
		input wire arit_op, //add or subtract operation
	//OUTPUTS
		output wire zero //flag zero signal , it indicates to the add_Sub module
		//that the result is zero
	
    );


//CONNECTION WIRES/////////////////////////////////////////////
wire eq_ops;
wire zero_reg;
//////////////////////////////////////////////////////////////
//BODY OF THE MODULE////

Comparator_Equal #(.S(W-1)) Magnitude_Comp  (
    .Data_A(Data_A[W-2:0]), 
    .Data_B(Data_B[W-2:0]), 
    .equal_sgn(eq_ops)
    );
	 
Zero_AS_Decoder Z_AS_Deco (
    .eq_ops(eq_ops), 
    .Sgn_A(Data_A[W-1]), 
    .Sgn_B(Data_B[W-1]), 
    .arit_op(arit_op), 
    .zero(zero_reg)
    );

RegisterAdd #(.W(1)) Zero_Info_Register(
    .clk(clk), 
    .rst(rst), 
    .load(load), 
    .D(zero_reg), 
    .Q(zero)
    );




endmodule
