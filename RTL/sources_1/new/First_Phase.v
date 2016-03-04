`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:27 08/17/2015 
// Design Name: 
// Module Name:    First_Phase 
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


//include "prueba.v";

module First_Phase

	# (parameter W = 32 ) // This parameter could be adjust based
	//on the desire precision format
	//W = 64 indicates the double precision format
	//W = 32 indicates the single precision format

	(
	
		input wire clk, //system clock
		input wire rst, //reset of the module
		input wire ctrl_a,//The ctrl_x signals are used to load certain registers within the module
		input wire ctrl_b,
		input wire ctrl_c,
		input wire add_subt, //This signal selects if the operations is an add o subtract operation
		input wire [W-1:0] Data_X, //Data_X and Data_y are both operands of the module
		//they are expected in ieee 754 format
		input wire [W-1:0] Data_Y,
		
		///////////////////////////////////
		output wire [W-1:0] QX,
		output wire [W-1:0] QY, 
		////////////////////////////////////
		
		output wire [W-1:0] DMP, //Because the algorithm these outputs contain the largest and smallest operand
		output wire [W-1:0] DmP

    );

//Wire Signals useful to interconnect the components of the module


wire QAS;
wire gt;
wire gtr;
wire [W-1:0] QYF;
wire [W-1:0] QYFP;
//wire [W-1:0] QXP;
wire [W-1:0] MDM;
wire [W-1:0] MDm;

///////////////////////////////////////////////////////////////////


RegisterAdd #(.W(W)) XRegister ( //Data X input register
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_a), 
    .D(Data_X), 
    .Q(QX)
    );
	 
RegisterAdd #(.W(W)) YRegister ( //Data Y input register
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_a), 
    .D(Data_Y), 
    .Q(QY)
    );

RegisterAdd #(.W(1)) ASRegister ( //Data Add_Subtract input register
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_a), 
    .D(add_subt), 
    .Q(QAS)
    );


Greater_Comparator #(.W(W-1)) GTComparator ( //EXP-MANT Comparator Module
    .Data_A(QX[W-2:0]), 
    .Data_B(QY[W-2:0]), 
    .gthan(gt)
    );

Invert_Sign #(.W(W)) DY_Inv ( //Invert sign of operand Y based on add_sub signal module
    .inv_sign(QAS), 
    .Data(QY), 
    .Fixed_Data(QYF)
    );

	 
RegisterAdd #(.W(1)) CMPRegister ( //Register that stores the result of the GTComparator Module
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_b), 
    .D(gt), 
    .Q(gtr)
    );

	 
RegisterAdd #(.W(W)) DYP ( //Data Y with the correct sign bit
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_b), 
    .D(QYF), 
    .Q(QYFP)
    );

	 
//Register #(.W(W)) DXP ( 
//    .clk(clk), 
//    .rst(rst), 
//    .load(ctrl_b), 
//    .D(QX), 
//    .Q(QXP)
//    );

	 
Multiplexer_AC #(.W(W)) Dir_M (
    .ctrl(~gtr), 
    .D0(QX), 
    .D1(QYFP), 
    .S(MDM)
    );
	 
Multiplexer_AC #(.W(W)) Dir_m (
    .ctrl(gtr), 
    .D0(QX), 
    .D1(QYFP), 
    .S(MDm)
    );


RegisterAdd #(.W(W)) DMC ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_c), 
    .D(MDM), 
    .Q(DMP)
    );

RegisterAdd #(.W(W)) DmC ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl_c), 
    .D(MDm), 
    .Q(DmP)
    );

//generate
//	if(W == 32) begin
//		assign MDMC = {MDM[31:23],1'b1,MDM[22:0],2'b00};
//		assign MDmC = {MDm[31:23],1'b1,MDm[22:0],2'b00};
//	end
//	else begin
//		assign MDMC = {MDM[63:52],1'b1,MDM[51:0],2'b00};
//		assign MDmC = {MDm[63:52],1'b1,MDm[51:0],2'b00};
//	end
//endgenerate	

endmodule
