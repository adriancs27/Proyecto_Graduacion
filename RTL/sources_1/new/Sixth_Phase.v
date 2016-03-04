`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:11:30 08/20/2015 
// Design Name: 
// Module Name:    Sixth_Phase 
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
module Sixth_Phase
//Module Parameter
//W_Exp = 8 ; Single Precision Format
//W_Exp = 11; Double Precision Format

	# (parameter W_Exp = 8)
/*	# (parameter W_Exp = 11)*/
	(
		input wire clk, //clock signal
		input wire rst, //reset signal
		input wire ctrl, //load register
		input wire [W_Exp-1:0] exp, //exponent of the fifth phase
		output wire overflow, //overflow flag
		output wire underflow //underflow flag
		
    );

wire [W_Exp-1:0] U_limit; //Max Normal value of the standar ieee 754
wire [W_Exp-1:0] L_limit; //Min Normal value of the standar ieee 754

wire overflow_reg;
wire underflow_reg;

//Compares the exponent with the Max Normal Value, if the exponent is
//larger than U_limit then exist overflow
Greater_Comparator #(.W(W_Exp)) GTComparator ( 
    .Data_A(exp), 
    .Data_B(U_limit), 
    .gthan(overflow_reg)
    );

//Compares the exponent with the Min Normal Value, if the exponent is
//smaller than U_limit then exist overflow	 
Comparator_Less #(.W(W_Exp)) LTComparator (
    .Data_A(exp),  
    .Data_B(L_limit), 
    .less(underflow_reg)
    );

//Those registers stores the underflow/overflow info
RegisterAdd #(.W(1)) R_Overflow ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl), 
    .D(overflow_reg), 
    .Q(overflow)
    );

RegisterAdd #(.W(1)) R_Underflow ( 
    .clk(clk), 
    .rst(rst), 
    .load(ctrl), 
    .D(underflow_reg), 
    .Q(underflow)
    );

//This generate sentence creates the limit values based on the 
//precision format

generate
	if(W_Exp == 8) begin
		assign U_limit = 8'hfe;
		assign L_limit = 8'h01;
	end
	else begin
		assign U_limit = 11'b11111111110;
		assign L_limit = 11'b00000000001;
	end
endgenerate

endmodule
 
