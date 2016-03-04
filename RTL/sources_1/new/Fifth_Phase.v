`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:24:59 08/20/2015 
// Design Name: 
// Module Name:    Fifth_Phase 
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
module Fifth_Phase

//Module Parameters
//W_Exp = 8 ; Single Precision Format
//W_Exp = 11; Double Precision Format

	# (parameter W_Exp = 8)
//	# (parameter W_Exp = 11) 	
	(
		//INPUTS
		input wire clk, //Clock Signal
		input wire rst, //Reset Signal
		input wire ctrl_a, //ctrl signals are loads of registers
		input wire ctrl_b,
		input wire ctrl_c,
		input wire add_sub_ctrl, //signal that defines the operation of the ripple adder
		input wire selector_a, //selectors are control signal for muxes
		input wire selector_b,
		input wire [W_Exp-1:0] exp_M, //This value is the exponent of the largest operand,
		//and it's connected from the first phase
	
		//OUTPUTS
		output wire [W_Exp-1:0] exp_update_ieee, 
		output wire [W_Exp-1:0] exp_update_uo
//		output wire change_selector
		
    );

//Wire interconection signals

wire [W_Exp-1:0] exp;
wire [W_Exp-1:0] exp_reg;
wire [W_Exp-1:0] exp_update;
wire [W_Exp-1:0] exp_update_P;
wire [W_Exp-1:0] exp_update_F;

//Wire Constant One
wire [W_Exp-1:0] one;

//MODULE BODY///////////////////////////////////////
//Select the correct exponent to update
//in case of normalization in the previous stage
Multiplexer_AC #(.W(W_Exp)) Exp_S (
    .ctrl(selector_a), 
    .D0(exp_M), 
    .D1(exp_update_P), 
    .S(exp)
    );

//Stores the Multiplexer selected value
RegisterAdd #(.W(W_Exp)) RExp ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_a), 
    .D(exp), 
    .Q(exp_reg)
    );

//Add or subtract one from the exponent
add_subtract #(.W(W_Exp)) SExp (
    .op_mode(add_sub_ctrl), 
    .Data_A(exp_reg), 
    .Data_B(one), 
    .Data_S(exp_update)
    );

//Stores the result of the add-subtract process
RegisterAdd #(.W(W_Exp)) UExp ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_b), 
    .D(exp_update), 
    .Q(exp_update_P)
    );

//Selects at the end of the process the exponent that will be used
//in the post round actualization phase
Multiplexer_AC #(.W(W_Exp)) Exp_F ( //New hardware
    .ctrl(selector_b), 
    .D0(exp_M), 
    .D1(exp_update_P), 
    .S(exp_update_F)
    );
	 
//This register stores the final exponent value of the process
RegisterAdd #(.W(W_Exp)) Exp_F_ieee ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_c), 
    .D(exp_update_F), 
    .Q(exp_update_ieee)
    );
//	//////////////////////////////////////////////////////////////// 
assign one = 1;
assign  exp_update_uo = exp_update_P;
//This signal is going to an underflow/overflow phase

endmodule
