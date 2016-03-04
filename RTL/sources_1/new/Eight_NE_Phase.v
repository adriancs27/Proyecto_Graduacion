`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:16 08/24/2015 
// Design Name: 
// Module Name:    Eight_NE_Phase 
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
module Eight_NE_Phase
//Module Parameters
//W_Exp = 8 ; Single Precision
//W_Exp = 11 ; Double Precision
	# (parameter W_Exp  = 8)
/* # (parameter W_Exp = 11) */
	(
		//INPUTS
		input wire clk, //Clock Signal
		input wire rst, //Reset Signal
		input wire load_a, //load signal for registers
		input wire load_b,
		input wire [W_Exp-1:0] exp_update, //Connect to the last
		//update exponent
		input wire selector,//Connect to the need update flago
		//from Eigth Module
		
		//OUTPUTS
		output wire [W_Exp-1:0] exp_ieee_p, //Final exponent Value
		output wire overflow_pr  //Overflow Signal
		
    );

//Wire Interconnection Signals
wire [W_Exp-1:0] exp_update_reg;
wire [W_Exp-1:0] exp_plus_one;
wire [W_Exp-1:0] exp_def;
wire [W_Exp-1:0] U_Limit;
wire overflow_reg;
////////////////////////////////////////////////////
//Wire One
wire [W_Exp-1:0] one;
//MODULE's BODY
RegisterAdd #(.W(W_Exp)) exp_u_register ( 
    .clk(clk), 
    .rst(rst), 
    .load(load_a), 
    .D(exp_update), 
    .Q(exp_update_reg)
    );
	 
add_subtract #(.W(W_Exp)) exp_po (
    .op_mode(1'b0), 
    .Data_A(exp_update_reg), 
    .Data_B(one), 
    .Data_S(exp_plus_one)
    );

Multiplexer_AC #(.W(W_Exp)) dir_exp_up (
    .ctrl(selector), 
    .D0(exp_update_reg), 
    .D1(exp_plus_one), 
    .S(exp_def)
    );
	 
Greater_Comparator #(.W(W_Exp)) GTComparator_AM ( 
    .Data_A(exp_def), 
    .Data_B(U_Limit), 
    .gthan(overflow_reg)
    );

RegisterAdd #(.W(W_Exp)) exp_fp_reg ( 
    .clk(clk), 
    .rst(rst), 
    .load(load_b), 
    .D(exp_def), 
    .Q(exp_ieee_p)
    );
	 
RegisterAdd #(.W(1)) overflow_am ( 
    .clk(clk), 
    .rst(rst), 
    .load(load_b), 
    .D(overflow_reg), 
    .Q(overflow_pr)
    );
	 
generate 
	if (W_Exp == 8)
		assign U_Limit = 8'hfe;
	else
		assign U_Limit = 11'hffe;
endgenerate

assign one = 1;
endmodule
