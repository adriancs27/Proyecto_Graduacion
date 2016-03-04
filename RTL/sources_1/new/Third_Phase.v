`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:53:41 08/18/2015 
// Design Name: 
// Module Name:    Third_Phase 
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
module Third_Phase
//This Module executes the add or subtract operation over the significands

//Parameter of the Module
//Single Precision W_Sgf = 23
//Double Precision W_Sgf = 52

	# (parameter W_Sgf = 23)
	
/*	# (parameter W_Sgf = 52)
*/
	(
		//INPUTS
		input wire clk, //clock of the module
		input wire rst, //reset of the module
		input wire ctrl, //load signal of a register
		input wire [W_Sgf+2:0] sgf_M, //Significand of the largest operand
		input wire [W_Sgf+2:0] sgf_m, //Significand of the smallest operand
		input wire sgn_M, //Sign bit of the largest operand
		input wire sgn_m, //Sign bit of the smallest operand
		
		//OUTPUTS
		output wire [W_Sgf+3:0] sgf_R //The resultant significand has become
		//in a 27 bitstream value, this is because we need the carry out bit
		//to make a normalization process of the result
		
    );


//Wire Interconnect Signals

wire eq_sgn;
wire [W_Sgf+3:0] r_add_subt_sgf;

////////////////////////////

//BODY OF THE MODULE//////////////////////////////////////////////////

//1-Bit Comparator, is used to compare an equality of the signs
//because if the signs are equal the significands are added, otherwise 
//it's necessary to subtract them.

Comparator_Equal #(.S(1)) Sgn_Comp (
    .Data_A(sgn_M), 
    .Data_B(sgn_m),  
    .equal_sgn(eq_sgn)
    );

//This is a full adder, remember that is necessary the carry out bit
//in a next stage to normalize the resultant significand

add_sub_carry_out #(.W(W_Sgf+3)) Sgf_AS (
    .op_mode(~eq_sgn),  
    .Data_A(sgf_M), 
    .Data_B(sgf_m), 
    .Data_S(r_add_subt_sgf)
    );

//This register stores the resultant significand
RegisterAdd #(.W(W_Sgf+4)) R_Sgf ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl), 
    .D(r_add_subt_sgf), 
    .Q(sgf_R)
    );
//////////////////////////////////////////////////////////////////////////////////
endmodule
