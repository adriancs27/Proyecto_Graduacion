`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:50:28 08/24/2015 
// Design Name: 
// Module Name:    Eight_N_Phase 
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
module Eight_N_Phase
//Module Parameters
//W_Sgf = 23 ; Single Precision
//W_Sgf = 52 ; Double Precision

	# (parameter W_Sgf = 23)
/*	# (parameter W_Sgf = 52) */
	(
		//INPUTS
		input wire clk, //clock signal
		input wire rst, //reset signal
		input wire load, //register load signal
		input wire [W_Sgf+1:0] Sgf_Ready, // Post Round Significand
		//25 Bits, 1 carry out bit and 24 of true Mantissa
		
		//OUTPUTS
		output wire [W_Sgf-1:0] Sgf_R_ieee, //This is the final result
		//23 bits of Mantissa
		output wire exp_na //A flag that indicates if the exponent needs
		//actualization
    );

//Wire interconection signals
wire [W_Sgf:0] Sgf_R_ieee_reg; //Output of the Multiplexer -- 24 Bits

//MODULE's BODY
//Multiplex the correct significand
Multiplexer_AC #(.W(W_Sgf+1)) Dir_Sgf_iee (
    .ctrl(Sgf_Ready[W_Sgf+1]), 
    .D0(Sgf_Ready[W_Sgf:0]), 
    .D1(Sgf_Ready[W_Sgf+1:1]), 
    .S(Sgf_R_ieee_reg)
    );

//Stores the value of the multiplexer
RegisterAdd #(.W(W_Sgf)) Sgf_ieee_Register ( 
    .clk(clk), 
    .rst(rst), 
    .load(load), 
    .D(Sgf_R_ieee_reg[W_Sgf-1:0]), 
    .Q(Sgf_R_ieee)
    );

//Stores the flag of need actualization (exponent)
RegisterAdd #(.W(1)) Exp_na_Reg( 
    .clk(clk), 
    .rst(rst), 
    .load(load), 
    .D(Sgf_Ready[W_Sgf+1]), 
    .Q(exp_na)
    );
/////////////////////////////////////////////////////////////////
endmodule
