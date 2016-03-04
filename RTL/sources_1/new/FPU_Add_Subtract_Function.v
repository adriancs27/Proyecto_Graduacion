`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:06:01 08/27/2015 
// Design Name: 
// Module Name:    FPU_Add_Subtract_Function 
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
module FPU_Add_Subtract_Function
//Add/Subtract Function Parameters
	
   # (parameter W = 32, parameter W_Exp = 8, parameter W_Sgf = 23,
		parameter S_Exp = 9)  //Single Precision */
		
/*	# (parameter W = 64, parameter W_Exp = 11, parameter W_Sgf = 52,
		parameter S_Exp = 12) //-- Double Precision */
	(
		//FSM Signals 
		input wire clk,
		input wire rst,
		input wire beg_FSM,
		input wire rst_FSM,
		
		//First Phase signals
		input wire [W-1:0] Data_X,
		input wire [W-1:0] Data_Y,
		input wire add_subt,
		 
		//Seventh Phase signals
		input wire [1:0] r_mode,
		
		//OUTPUT SIGNALS
		output wire overflow_flag,
		output wire underflow_flag,
		output wire ready,
		output wire [W-1:0] final_result_ieee
    );



////////////1///////////////
wire load_1, load_2, load_3; 
wire [W-1:0] DMP, DmP;
wire [W-1:0] QX, QY;
///////////2///////////////
wire load_4, load_5; 
wire [W_Sgf+2:0] sgfm_n;

//////////3////////////////
wire load_6; 
wire [W_Sgf+3:0] sgf_R;

/////////4/////////////////
wire selector_4_P;
wire load_7; //USR
wire load_8;
wire sl, sr;
wire Sgf_ncarry;
wire Sgf_nbit;
wire [W_Sgf+2:0] Sgf_NF;

/////////5////////////////
wire add_subt_5_P;
wire selector_5_P;
wire selector_5_P_exp;
wire [W_Exp-1:0] exp_update_ieee;
wire [W_Exp-1:0] exp_update_uo;

/////////6///////////////
wire load_12;
wire overflow_a;
wire underflow;

////////7///////////////
wire load_13;
wire load_14;
wire [W_Sgf+1:0] Sgf_Ready;

/////////8//////////////
wire load_15;
wire [W_Sgf-1:0] Sgf_R_ieee;
wire exp_na;

/////////9/////////////
wire load_16;
wire load_17;
wire overflow_pr;
wire [W_Exp-1:0] exp_ieee_p;

////////10////////////
wire selector_10_P_a;
wire selector_10_P_b;

///////WIRES REG SIGNALS////
wire selector_4_P_reg;
wire selector_5_P_reg;
wire selector_5_P_exp_reg;
wire selector_10_P_a_reg;
wire selector_10_P_b_reg;
wire add_subt_5_P_reg;
//wire sl_reg;
//wire sr_reg;

///0///////////////////////
wire load_0;
wire zero_flag;


wire rst_int;

FSM_Add_Subtract FS_Module(
    .clk(clk), //check
    .rst(rst), //check
    .rst_FSM(rst_FSM), //check 
    .beg_FSM(beg_FSM), //check
	 .zero_flag(zero_flag), //check -- 0
    .Sgfn_R_MSBs({Sgf_ncarry,Sgf_nbit}), //check -- 4
    .overflow_a(overflow_a), //check -- 6
    .underflow(underflow), //check -- 6
    .ovflow_post_round(overflow_pr), //check -- 9
	 .load_0(load_0), //check -- 0
    .load_1(load_1), //check -- 1
    .load_2(load_2), //check -- 1
    .load_3(load_3), //check -- 1
    .load_4(load_4), //check -- 2
    .load_5(load_5), //check -- 2
    .load_6(load_6), //check -- 3
    .selector_4_P(selector_4_P), //check -- 4
    .load_8(load_8), //check -- 4
    .sl(sl), //check -- 4
    .sr(sr), //check -- 4
    .load_7(load_7), //check -- 4
    .add_subt_5_P(add_subt_5_P), //check -- 5
    .load_9(load_9), //check -- 5
    .load_10(load_10), //check -- 5
    .selector_5_P(selector_5_P), //check -- 5
    .selector_5_P_exp(selector_5_P_exp), //check -- 5
    .load_11(load_11), //check -- 5
    .load_12(load_12), //check -- 6
    .load_13(load_13), //check -- 7
    .load_14(load_14), //check -- 7
    .load_15(load_15), //check -- 8
    .load_16(load_16), //check -- 9
    .load_17(load_17), //check -- 9
    .selector_10_P_a(selector_10_P_a), 
    .load_18(load_18), 
    .selector_10_P_b(selector_10_P_b), 
    .load_19(load_19),
	 .rst_int(rst_int),
	 .ready(ready)
    );
	 


///////////Selector Registers////////////////////////////
////////////////////4///////////////////////////////////
RegisterAdd #(.W(1)) Sel_4_P ( //Data X input register
    .clk(clk), 
    .rst(rst_int), 
    .load(selector_4_P), 
    .D(1'b1), 
    .Q(selector_4_P_reg)
    );

////////////////////5///////////////////////////////////	 
RegisterAdd #(.W(1)) Sel_5_P( //Data X input register
    .clk(clk), 
    .rst(rst_int), 
    .load(selector_5_P), 
    .D(1'b1), 
    .Q(selector_5_P_reg)
    );

RegisterAdd #(.W(1)) Sel_5_P_exp ( //Data X input register
    .clk(clk), 
    .rst(rst_int), 
    .load(selector_5_P_exp), 
    .D(1'b1), 
    .Q(selector_5_P_exp_reg)
    );

RegisterAdd #(.W(1)) as_5_P_Reg ( //Data X input register
    .clk(clk), 
    .rst(rst_int), 
    .load(add_subt_5_P), 
    .D(1'b1), 
    .Q(add_subt_5_P_reg)
    );
/////////////////////////////////////////////////////////
RegisterAdd #(.W(1)) Sel_10_P_a ( //Data X input register
    .clk(clk), 
    .rst(rst_int), 
    .load(selector_10_P_a), 
    .D(1'b1), 
    .Q(selector_10_P_a_reg)
    );

RegisterAdd #(.W(1)) Sel_10_P_b ( //Data X input register
    .clk(clk), 
    .rst(rst_int), 
    .load(selector_10_P_b), 
    .D(1'b1), 
    .Q(selector_10_P_b_reg)
    );
///////////////////////////////////////////////////////////
//Register #(.W(1)) sl_reg_M ( 
//    .clk(clk), 
//    .rst(rst), 
//    .load(sl), 
//    .D(1'b1), 
//    .Q(sl_reg)
//    );
//
//
//Register #(.W(1)) sr_reg_M ( //Data X input register
//    .clk(clk), 
//    .rst(rst), 
//    .load(sr), 
//    .D(1'b1), 
//    .Q(sr_reg)
//    );


////////////////////////////////////////////////////////
	 
//ADD/SUB FUNCTION BODY

//This Module classify both operands
//in largest and smallest one///////////////////////////////
First_Phase #(.W(W)) Operands_Classification (
    .clk(clk), //**
    .rst(rst_int), //** 
    .ctrl_a(load_1), //**
    .ctrl_b(load_2), //**
    .ctrl_c(load_3), //**
    .add_subt(add_subt), //**
    .Data_X(Data_X), //**
    .Data_Y(Data_Y), //**
	 .QX(QX), 
    .QY(QY), 
    .DMP(DMP), //**
    .DmP(DmP) //**
    );
////////////////////////////////////////////////////////////


//Zero Detector/////////////////////////////////////////

Zero_InfAdd_Unit #(.W(W)) Zero_Except_Module (
    .clk(clk), 
    .rst(rst_int), 
    .load(load_0), 
    .Data_A(QX), 
    .Data_B(QY), 
    .arit_op(add_subt), 
    .zero(zero_flag)
    );

//This module normalize the mantissa of the smallest operand//
Second_Phase #(.W_Exp(W_Exp), .W_Sgf(W_Sgf)) Normalization_Smallest_Significand(
    .clk(clk), //check
    .rst(rst_int), //check
    .ctrl_a(load_4), //check
    .ctrl_b(load_5), //check
    .exp_M(DMP[W-2:W-S_Exp]), //check
    .exp_m(DmP[W-2:W-S_Exp]), //check
    .sgfm(DmP[W-S_Exp-1:0]), //check
    .sgfm_n(sgfm_n) //check
    );
////////////////////////////////////////////////////////////////

//In this module occurs the add/subtract of significands
Third_Phase #(.W_Sgf(W_Sgf)) Add_Sub_Significands (
    .clk(clk), //check
    .rst(rst_int), //check
    .ctrl(load_6), //check
    .sgf_M({1'b1,DMP[W-S_Exp-1:0],2'b00}), //check
    .sgf_m(sgfm_n), //check
    .sgn_M(DMP[W-1]), //check
    .sgn_m(DmP[W-1]), //check
    .sgf_R(sgf_R) //check
    );
///////////////////////////////////////////////////////////////

//Sequential Shifting Module
Fourth_Phase #(.W_Sgf(W_Sgf)) Fourth_Module (
    .clk(clk), //check
    .rst(rst_int), //check
    .Sgf_R(sgf_R), //check 
    .selector(selector_4_P_reg), //check 
    .ctrl_b(load_7), //check 
    .ctrl_c(load_8), //check 
    .shift_left(sl), //check 
    .shift_right(sr), //check 
    .shift_in(1'b0), //check 
    .Sgf_ncarry(Sgf_ncarry), //check 
    .Sgf_nbit(Sgf_nbit), //check 
    .Sgf_NF(Sgf_NF) //check 
    );


//Update Exponent 1
Fifth_Phase #(.W_Exp(W_Exp)) Update_Exponent_First_Time (
    .clk(clk), //check 
    .rst(rst_int), //check 
    .ctrl_a(load_9), //check 
    .ctrl_b(load_10), //check 
    .ctrl_c(load_11), //check 
    .add_sub_ctrl(add_subt_5_P_reg), //check 
    .selector_a(selector_5_P_reg), //check 
    .selector_b(selector_5_P_exp_reg), //check 
    .exp_M(DMP[W-2:W-S_Exp]), //check 
    .exp_update_ieee(exp_update_ieee), //check 
    .exp_update_uo(exp_update_uo)//check 
    );
	 


//Looking for an underflow/overflow
Sixth_Phase #(.W_Exp(W_Exp)) First_Und_Ov_Search(
    .clk(clk), //check 
    .rst(rst_int), //check 
    .ctrl(load_12), //check
    .exp(exp_update_uo), //check
    .overflow(overflow_a), //check
    .underflow(underflow) //check
    );

//Rounding the significand
Seventh_Phase #(.W_Sgf(W_Sgf)) Round_Resultant_Significand (
    .clk(clk), //check
    .rst(rst_int), //check
    .ctrl_a(load_13), //check
    .ctrl_b(load_14), //check
    .Sgf_N(Sgf_NF[W_Sgf+2:0]), //check
    .r_mode(r_mode), //check
	 .Sgn_M(DMP[W-1]), 
    .Sgf_Ready(Sgf_Ready) //check
    );


Eight_N_Phase #(.W_Sgf(W_Sgf)) Select_Final_Significand(
    .clk(clk), //check
    .rst(rst_int), //check
    .load(load_15), //check
    .Sgf_Ready(Sgf_Ready), //check
    .Sgf_R_ieee(Sgf_R_ieee), //check
    .exp_na(exp_na) //check 
    );

Eight_NE_Phase #(.W_Exp(W_Exp)) Select_Final_Exponent (
    .clk(clk), //check
    .rst(rst_int), //check
    .load_a(load_16), //check
    .load_b(load_17), //check
    .exp_update(exp_update_ieee), //check
    .selector(exp_na), //check
    .exp_ieee_p(exp_ieee_p), //check
    .overflow_pr(overflow_pr) //check
    );
	 
Tenth_Phase #(.W(W), .W_Exp(W_Exp), .W_Sgf(W_Sgf)) Tenth_Module(
    .clk(clk), //check
    .rst(rst_int), //check
    .sel_a(selector_10_P_a_reg), //check
    .sel_b(selector_10_P_b_reg), //check
    .ctrl_a(load_18), //check
    .ctrl_b(load_19), //check
    .sgn_M(DMP[W-1]),  
    .exp_ieee_p(exp_ieee_p), 
    .sgf_ieee_p(Sgf_R_ieee), 
    .final_result_ieee(final_result_ieee)
    );

assign overflow_flag = (overflow_pr || overflow_a) ? 1'b1:1'b0;
assign underflow_flag = underflow; 

endmodule
