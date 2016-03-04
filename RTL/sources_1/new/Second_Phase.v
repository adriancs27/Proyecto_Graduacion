`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:50:31 08/18/2015 
// Design Name: 
// Module Name:    Second_Phase 
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

//Uncomment the parameters with ** to work on double precision and comment the
//the single precision parameters 
module Second_Phase

//SINGLE PRECISION PARAMETERS
	# (parameter W_Exp = 8,
		parameter W_Sgf = 23)

//DOUBLE PRECISION PARAMETERS
/*#  (parameter Width_Exp = 11,
		parameter Width_Sgf = 52)
*/

	(

	//General Parameters
	input wire clk, //clk and rst are the control signals of the pipeline registers
	input wire rst,
	input wire ctrl_a, //register load signal
	input wire ctrl_b, //register load signal

	//Exponent and smallest Mantissa inputs
	//sgf is about significand and I declare the input as significand
	//because in this phase it's made it the concatenation process
	//that turns de Mantissa in true mantissa or significand
	
	input wire [W_Exp-1:0] exp_M, //It's an input provided by the first phase and makes reference to the largest exponent
	input wire [W_Exp-1:0] exp_m, //It's an input provided b the first phase and makes reference to the smallest exponent
	input wire [W_Sgf-1:0] sgfm, //It's the significand of the smallest operand
	
	output wire [W_Sgf+2:0] sgfm_n //The output considers the 3 concatenated bits
		
    );
	 


//Wire connection signals ///////////////////////////

wire [W_Exp-1:0] subt_exp; 
wire [W_Exp-1:0] subt_exp_r;
wire [W_Sgf+2:0] sgfsn;

//////////////////////////////////////////////////////


//MODULE BODY////////////////////////////////////////

//Ripple Carry Adder
//It's not necessary to use a Full Adder
//Because the subtract process in this case will not cause a carry out
add_subtract #(.W(W_Exp)) SExp (
    .op_mode(1'b1), 
    .Data_A(exp_M), 
    .Data_B(exp_m), 
    .Data_S(subt_exp)
    );

//This register stores the result of the subtraction process between
//the exponents 
RegisterAdd #(.W(W_Exp)) ESRegister ( //Data X input register
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_a), 
    .D(subt_exp), 
    .Q(subt_exp_r)
    );
	 
//This module receives two values, the significand (already concatenated)
//and the result of the exponents subtract to shift right the smallest
//mantissa, this is a merely combinational process and can be consider
//the normalization process of that mantissa.

Shift_Module_Param #(.W_Sgf(W_Sgf),.W_Exp(W_Exp)) Shift_Comb_Mantm (
    .nshift(subt_exp_r), 
    .sgfm({1'b1,sgfm,2'b00}), 
    .sgfm_n(sgfsn)
    );

//This registers stores the smallest normalized significand
RegisterAdd #(.W(W_Sgf+3)) SGFmRegister ( //Data X input register
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_b), 
    .D(sgfsn), 
    .Q(sgfm_n)
    );
////////////////////////////////////////////////////////////////////////////	 
endmodule
