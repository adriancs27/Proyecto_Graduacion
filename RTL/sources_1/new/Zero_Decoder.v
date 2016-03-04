`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:26:14 10/01/2015 
// Design Name: 
// Module Name:    Zero_AS_Decoder 
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
module Zero_AS_Decoder(
	
	//INPUTS
	input wire eq_ops, //equality of operands signal
	input wire Sgn_A,  //Signs of the operands
	input wire Sgn_B,
	input wire arit_op, //Add or Subtract function
   
	//OUTPUTS
	output reg zero
	 );

/////The next decoder is based in the next logical behavior///////////////////////
/////The following conditions manager a result of zero:
	
always @*
	case({eq_ops,Sgn_A,Sgn_B,arit_op})
	//there are just four statements when the result of an add or subtract operation will give a zero as a result////////
	4'b1001: zero <= 1'b1; // a - a = 0 
	4'b1010: zero <= 1'b1; // a + (-a) = 0
	4'b1100: zero <= 1'b1; // -a + a = 0
	4'b1111: zero <= 1'b1; //-a - (-a) = 0
	default: zero <= 1'b0;
	
	endcase
		
endmodule
