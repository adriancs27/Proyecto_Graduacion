`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:36:46 09/06/2015 
// Design Name: 
// Module Name:    FPU_Multiplication_Function 
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
module FPU_Multiplication_Function
	//SINGLE PRECISION PARAMETERS
	# (parameter W = 32, parameter W_Exp = 8, parameter W_Sgf = 23,
		parameter S_Exp = 9) // */
	//DOUBLE PRECISION PARAMETERS
/*	# (parameter W = 64, parameter W_Exp = 11, parameter W_Sgf = 52,
		parameter S_Exp = 12) // */
	(
		input wire clk,
		input wire rst,
		input wire beg_FSM,
		input wire rst_FSM,
		
		input wire [W-1:0] Data_MX,
		input wire [W-1:0] Data_MY,
		input wire [1:0] round_mode,
		
		output wire overflow_flag,
		output wire underflow_flag,
		output wire ready_flag,
		output wire [W-1:0] F_ieee_result
    );




//GENERAL
wire rst_int; //**

//ZERO PHASE
wire load_0;
wire zero_m_flag;

//FIRST PHASE
wire load_1; //**
wire [W-1:0] Op_MX;
wire [W-1:0] Op_MY;
//SECOND PHASE
wire load_2;
wire [W_Exp:0] exp_pr;
//THIRD PHASE
wire load_3;
wire overflow_cout;
wire overflow_comp_a;
wire [W_Exp-1:0] exp_r;

//FOURTH PHASE
wire load_4_A;
wire load_4;
wire [2*W_Sgf+1:0] P_Sgf;

//FIFTH PHASE
wire load_5;
wire selector_a;
wire [W_Sgf+1:0] Sgf_P_Round; //post round significand
wire [W_Sgf:0] Sgf_F; //Final result of significand
wire exp_nu; //Brings info about an update of the exponent

//SIXTH PHASE
wire load_6;
wire load_7;
wire selector_b;
wire overflow_comp_b;
wire [W_Exp-1:0] exp_act;

//SEVENTH PHASE
wire load_8;
wire Sgn_Info;

//EIGHT PHASE
wire load_9;
wire load_10;
wire selector_c;
wire selector_d;

//NINTH PHASE
wire [W_Exp:0] Exp_Add;
wire load_11;
wire load_12;
wire underflow_f;

//////New Clock Wire
wire new_clk;

///////////////////////////////////////////////////////////
`define Freq_DivA
`ifdef Freq_Div

	wire clk_toogle;
	
	FF_T Div_Clk_T (
		.clk(clk), 
		.rst(rst), 
		.Q(clk_toogle)
		);

	BUFG BUFG_inst (
		.O(new_clk), // 1-bit output: Clock output
		.I(clk_toogle)  // 1-bit input: Clock input
		);
`else
	assign new_clk = clk;
	
`endif
/////////////////////////////////////////////////////////////////////////

FSM_Mult_Function FSM_FPU_Multiplication (
    .clk(new_clk), //** 
    .rst(rst), //**
    .beg_FSM(beg_FSM), //** 
    .rst_FSM(rst_FSM), //**
	 .zero_flag(zero_m_flag), 
    .overflow_cout(overflow_cout), 
    .overflow_comp_a(overflow_comp_a), 
    .overflow_comp_b(overflow_comp_b),
	 .underflow_f(underflow_f), 	 
    .rst_int(rst_int), 
	 .load_0(load_0),
    .load_1(load_1), 
    .load_2(load_2), 
    .load_3(load_3), 
	 .load_4_A(load_4_A), 
    .load_4(load_4), 
    .selector_a(selector_a), 
    .load_5(load_5), 
    .selector_b(selector_b), 
    .load_6(load_6), 
    .load_7(load_7), 
    .load_8(load_8), 
    .load_9(load_9), 
    .load_10(load_10), 
    .ready(ready_flag), 
    .selector_c(selector_c),
	 .selector_d(selector_d), 
    .load_11(load_11), 
    .load_12(load_12)
    );



First_Phase_M #(.W(W)) Exponent_load_reg (
    .clk(new_clk), //**
    .rst(rst_int), //**
    .load(load_1), //** 
    .Data_MX(Data_MX), //** 
    .Data_MY(Data_MY), //**
    .Op_MX(Op_MX), 
    .Op_MY(Op_MY)
    );

Zero_InfMult_Unit #(.W(W)) Zero_Result_Detect (
    .clk(clk), 
    .rst(rst_int), 
    .load(load_0), 
    .Data_A(Op_MX), 
    .Data_B(Op_MY), 
    .zero_m_flag(zero_m_flag)
    );

Ninth_Phase_M #(.W_Exp(W_Exp)) Underflow_Management_State (
    .clk(new_clk), 
    .rst(rst_int), 
    .load_a(load_11), 
    .load_b(load_12), 
    .Exp_X(Op_MX[W-2:W-S_Exp]), 
    .Exp_Y(Op_MY[W-2:W-S_Exp]), 
    .Exp_Add(Exp_Add), 
    .underflow_f(underflow_f)
    );

Second_Phase_M #(.W_Exp(W_Exp)) AddSub_ExpBias_Funct (
    .clk(new_clk), 
    .rst(rst_int), 
    .load(load_2), 
    .exp_add(Exp_Add), 
    .exp_pr(exp_pr)
    );

Third_Phase_M #(.W_Exp(W_Exp)) FT_exp_info (
    .clk(new_clk), 
    .rst(rst_int), 
    .load(load_3), 
    .exp(exp_pr[W_Exp-1:0]), 
    .cout_exp(exp_pr[W_Exp]), 
    .exp_r(exp_r), 
    .overflow_cout(overflow_cout), 
    .overflow_comp(overflow_comp_a)
    );

Fourth_Phase_M #(.W_Sgf(W_Sgf)) Significands_Multiplication_Funct (
    .clk(new_clk), 
    .rst(rst_int), 
	 .load_a(load_4_A), 
    .load_b(load_4), 
    .Sgf_X({1'b1,Op_MX[W-S_Exp-1:0]}),//Leading bit concatenation 
    .Sgf_Y({1'b1,Op_MY[W-S_Exp-1:0]}), 
    .P_Sgf(P_Sgf) //48 BITS
    );


Fifth_Phase_M #(.W_Sgf(W_Sgf)) First_Normalization_RSignificand (
    .clk(new_clk), 
    .rst(rst_int), 
    .load(load_5), 
    .selector(selector_a), 
    .Sgf_FP(P_Sgf[2*W_Sgf+1:W_Sgf]), 
    .Sgf_PR(Sgf_P_Round), 
    .exp_nu(exp_nu), //to the sixth phase
    .Sgf_F(Sgf_F)
    );

Sixth_Phase_M #(.W_Exp(W_Exp)) Exp_Update_Function (
    .clk(new_clk), 
    .rst(rst_int), 
    .load_a(load_6), 
    .load_b(load_7), 
    .exp_pr(exp_r), 
    .exp_na(exp_nu), 
    .selector(selector_b), 
    .exp_act(exp_act), //FINAL EXPONENT
    .overflow_b(overflow_comp_b)
    );

Seventh_Phase_M #(.W_Sgf(W_Sgf)) Round_Significand_Function (
    .clk(new_clk), 
    .rst(rst_int), 
    .load(load_8), 
    .round_mode(round_mode), 
    .Sgf_round_bits(P_Sgf[W_Sgf-1:0]), 
    .Sgn_X(Op_MX[W-1]), 
    .Sgn_Y(Op_MY[W-1]), 
    .Sgf_PR(Sgf_F), 
    .Sgn_Info(Sgn_Info), 
    .Sgf_P_Round(Sgf_P_Round)
    );

Eight_Phase_M #(.W(W)) Final_Result_Module (
    .clk(new_clk), 
    .rst(rst_int), 
    .load_a(load_9), 
    .load_b(load_10), 
	 .selector_a(selector_d), 
    .selector_b(selector_c), 
    .ieee_result({Sgn_Info,exp_act,Sgf_F[W_Sgf-1:0]}), 
    .F_ieee_result(F_ieee_result)
    );



assign overflow_flag = overflow_cout || overflow_comp_a || overflow_comp_b;
assign underflow_flag = underflow_f;

endmodule
