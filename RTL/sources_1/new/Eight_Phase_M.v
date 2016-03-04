`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:54:12 09/06/2015 
// Design Name: 
// Module Name:    Eight_Phase_M 
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
module Eight_Phase_M
	//SINGLE PRECISION PARAMETERS
	# (parameter W = 32)
	//DOUBLE PRECISION  PARAMETERS
/*	# (parameter W = 64) */
	( 
	 input wire clk,
	 input wire rst,
	 input wire load_a,
	 input wire load_b,
	 input wire selector_a,
	 input wire selector_b,
    input wire [W-1:0] ieee_result,
	 
	 output wire [W-1:0] F_ieee_result
	 );

//
//wire [W-1:0] D0;
wire [W-1:0] D1;
wire [W-1:0] S1;
wire [W-1:0] S2;
//

wire [W-1:0] Underflow_D;
wire [W-1:0] Overflow_D;	 
//Register #(.W(32)) Overflow_BitStream_Reg ( //Data X input register
//    .clk(clk), 
//    .rst(rst), 
//    .load(load_a), 
//    .D({ieee_result[W-1],8'hff,23'd0}), 
//    .Q(D0)
//    );

	 
Multiplexer_AC #(.W(W)) U_O_Mux_Select (
    .ctrl(selector_a), 
    .D0(Underflow_D), 
    .D1(Overflow_D), 
    .S(S1)
    ); 
 
RegisterMult #(.W(W)) IEEE_BitStream_Reg ( //Data X input register
    .clk(clk), 
    .rst(rst), 
    .load(load_a), 
    .D(ieee_result), 
    .Q(D1)
    );
	 
Multiplexer_AC #(.W(W)) MUX_F_IEEE_R (
    .ctrl(selector_b), 
    .D0(S1), 
    .D1(D1), 
    .S(S2)
    ); 
	 
RegisterMult #(.W(W)) IEEE_F_R_Reg ( //Data X input register
    .clk(clk), 
    .rst(rst), 
    .load(load_b), 
    .D(S2), 
    .Q(F_ieee_result)
    );

generate
	if ( W == 32) begin
		assign Underflow_D = {ieee_result[W-1],8'h00,23'd0};
		assign Overflow_D = {ieee_result[W-1],8'hff,23'd0};
	end
	else begin
		assign Underflow_D = {ieee_result[W-1],11'h000,52'd0};
		assign Overflow_D = {ieee_result[W-1],11'hfff,52'd0};
	end
endgenerate

endmodule
