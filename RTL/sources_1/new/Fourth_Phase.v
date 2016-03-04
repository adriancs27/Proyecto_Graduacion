`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:30:39 08/19/2015 
// Design Name: 
// Module Name:    Fourth_Phase 
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
//In this module occurs the normalization of the resultant significand
//from the third phase

module Fourth_Phase

//Parameters of the module
//Single Precision W_Sgf = 23 
//Double Precision W_Sgf = 52
	
	# (parameter W_Sgf = 23)
	
/*	# (parameter W_Sgf = 52)*/
	(
		///INPUTS 
		input wire clk, //clock signal
		input wire rst, //reset signal
		input wire [W_Sgf+3:0] Sgf_R, //Resultant significand with carry out
		input wire selector, //Selector that controls a Mux
		//This Mux select the update significand if necessary to aply
		//the shifting process (normalization)
		
//		input wire ctrl_a,
		input wire ctrl_b,
		input wire ctrl_c,
//		input wire ctrl_d,
		input wire shift_left,
		input wire shift_right,
		input wire shift_in,
		
		//OUTPUTS
		output wire Sgf_ncarry,
		output wire Sgf_nbit,
		output wire [W_Sgf+2:0] Sgf_NF //The result of this module
		//does not consider the carry out bit, because it's assumed 
		//that the normalization process is ready
    );
	 

///Wire Interconnection Signals//////////////////////////////////////
wire [W_Sgf+3:0] Sgfn_RP;
wire [W_Sgf+3:0] Sgf_RM;
//////////////////////////////////////////////////////////////////////


//BODY OF THE MODULE//////////////////////////////////////////////////

//Multiplex the actual and a update version of the significand
//from the third phase, this is for normalization purposes
Multiplexer_AC #(.W(W_Sgf+4)) Dir_Sgf (
    .ctrl(selector), 
    .D0(Sgf_R), 
    .D1(Sgfn_RP), 
    .S(Sgf_RM)
    );

//Universal Shift Register, used to shift the significand
//according to the MSB's of it
Universal_Shift_Register #(.W(W_Sgf+4)) SgfShift (
    .clk(clk), 
    .rst(rst), 
    .shift_left(shift_left), 
    .shift_right(shift_right), 
    .load(ctrl_b), 
    .shift_in(shift_in), 
    .D(Sgf_RM), 
    .Q(Sgfn_RP)
    );

//Register that stores the normalized significand
RegisterAdd #(.W(W_Sgf+3)) SgfRegister_F ( 
    .clk(clk), 
    .rst(rst),
    .load(ctrl_c), 
    .D(Sgfn_RP[W_Sgf+2:0]), 
    .Q(Sgf_NF)
    );

///////////////////////////////////////////////////////////////////
assign Sgf_ncarry = Sgfn_RP[W_Sgf+3]; //Carry Bit of the significand
assign Sgf_nbit = Sgfn_RP[W_Sgf+2]; //Leading Bit of the significand

////////////////////////////////////////////////////////////////////

endmodule
