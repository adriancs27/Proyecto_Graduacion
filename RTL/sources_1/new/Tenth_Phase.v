`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:08 08/27/2015 
// Design Name: 
// Module Name:    Tenth_Phase 
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
module Tenth_Phase 
//Module Parameters
/***SINGLE PRECISION***/
// W = 32 
// W_Exp = 8
// W_Sgf = 23 

/***DOUBLE PRECISION***/
// W = 64 
// W_Exp = 11
// W_Sgf = 52

	# (parameter W = 32, parameter W_Exp = 8, parameter W_Sgf = 23)
//	# parameter (W = 64, W_Exp = 11, W_Sgf = 52)
	
	(
		//INPUTS
		input wire clk, //Clock Signal
		input wire rst, //Reset Signal
		input wire sel_a, //Sel_x , mux's selector signals
		input wire sel_b,
		input wire ctrl_a, //Load_x , Registers load signals
		input wire ctrl_b,
		input wire sgn_M, //Sign of the largest Operand
		input wire [W_Exp-1:0] exp_ieee_p, //Final Exponent
		input wire [W_Sgf-1:0] sgf_ieee_p,//Final Significand
		//OUTPUTS
		output wire [W-1:0] final_result_ieee //Final Result
    );

//Wire Connection signals
wire [W_Exp-1:0] uoverflow_mux;
//wire [31:0] uoverflow_reg;
wire [W-1:0] result_reg;
wire [W-1:0] final_result_reg;

//////////////////////////////////////////////////////////

//MODULE's Body
/////////////////////////////////////////////////////////
generate
if(W == 32) begin
Multiplexer_AC #(.W(W_Exp)) UOverflow_Mux_Reg (
    .ctrl(sel_a), 
    .D0(8'h00), 
    .D1(8'hff), 
    .S(uoverflow_mux)
    );	 
end
else begin
Multiplexer_AC #(.W(W_Exp)) UOverflow_Mux_Reg (
    .ctrl(sel_a), 
    .D0(11'd0), 
    .D1(11'hfff), 
    .S(uoverflow_mux)
    );	
end
endgenerate
////////////////////////////////////////////////////////////////


RegisterAdd #(.W(W)) Cresult_Reg (
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_a), 
    .D({sgn_M,exp_ieee_p,sgf_ieee_p}), 
    .Q(result_reg)
    );	 

///////////////////////////////////////////////////////
generate
if (W == 32) begin
Multiplexer_AC #(.W(W)) Final_Result_Mux_Reg (
    .ctrl(sel_b), 
    .D0({sgn_M,uoverflow_mux,23'd0}), 
    .D1(result_reg), 
    .S(final_result_reg)
    );
end
else begin
Multiplexer_AC #(.W(W)) Final_Result_Mux_Reg (
    .ctrl(sel_b), 
    .D0({sgn_M,uoverflow_mux,52'd0}), 
    .D1(result_reg), 
    .S(final_result_reg)
    );
end
endgenerate
////////////////////////////////////////////////////////
RegisterAdd #(.W(W)) Final_Result_IEEE (
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_b), 
    .D(final_result_reg), 
    .Q(final_result_ieee)
    );	 


endmodule
