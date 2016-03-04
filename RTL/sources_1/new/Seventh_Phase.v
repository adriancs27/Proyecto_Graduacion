`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:39:04 08/20/2015 
// Design Name: 
// Module Name:    Seventh_Phase 
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
module Seventh_Phase
//Module Parameters
//W_Sgf = 23 ; Single Precision
//W_Sgf = 52 ; Double Precision

	# (parameter W_Sgf = 23)
/*	# (parameter W_Sgf = 52) */
	(
		input wire clk, //clock signal
		input wire rst, //reset signal
		input wire ctrl_a, //ctrl signals are loads of registers
		input wire ctrl_b,
		input wire [W_Sgf+2:0] Sgf_N, //Significand comes from the fourth phase
		input wire [1:0] r_mode, //Rounding codification signal
		input Sgn_M, //Sign of the largest operand
		
		output wire [W_Sgf+1:0] Sgf_Ready //Significand rounded
		
    );


//Wire Interconection Signal
wire selector_reg; //Output from the Decoder
wire [W_Sgf:0] Sgf_R;

wire [W_Sgf+1:0] Sgf_Round_R;


wire [W_Sgf+1:0] Sgf_Rounded;
//Wire One
wire [W_Sgf:0] one;
////////////////////////////////////////////////////////////////////////////
//MODULE BODY

Decoder_4_1 Round_Code (
    .round_mode(r_mode), 
    .lsbs_sgf_n(Sgf_N[1:0]),
	 .Sgn_M(Sgn_M),
    .ctrl(selector_reg)
    );

RegisterAdd #(.W(W_Sgf+1)) Round_Sgf_N (
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_a), 
    .D(Sgf_N[W_Sgf+2:2]), 
    .Q(Sgf_R)
    );
	 
add_sub_carry_out #(.W( W_Sgf+1)) Round_Adder (
    .op_mode(1'b0), 
    .Data_A(Sgf_R), 
    .Data_B(one), 
    .Data_S(Sgf_Round_R)
    );


Multiplexer_AC #(.W(W_Sgf+2)) Dir_M (
    .ctrl(selector_reg), 
    .D0({1'b0,Sgf_R}), 
    .D1(Sgf_Round_R), 
    .S(Sgf_Rounded)
    );

 
RegisterAdd #(.W(W_Sgf+2)) Sgf_Ready_Reg (
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_b), 
    .D(Sgf_Rounded), 
    .Q(Sgf_Ready)
    );

assign one = 1;
endmodule
