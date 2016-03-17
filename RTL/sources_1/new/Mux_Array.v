`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2016 06:18:20 PM
// Design Name: 
// Module Name: Mux_Array
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_Array
    #(parameter SW=26, parameter EW=5)
    (
    input wire [SW-1:0] Data_i,
    input wire FSM_left_right_i,
    input wire [EW-1:0] Shift_Value_i,
    output wire [SW-1:0] Data_o
    );
////
wire [SW-1:0] Data_array[EW:0];
//////////////////7
genvar k;//Level
///////////////////77777
Rotate_Mux_Array #(.SW(SW)) first_rotate(
	.Data_i(Data_i),
	.select_i(FSM_left_right_i),
	.Data_o(Data_array [0][SW-1:0])
	);
generate for (k=0; k < EW; k=k+1) begin
	shift_mux_array #(.SW(SW), .LEVEL(k)) shift_mux_array(
		.Data_i(Data_array[k]),
		.select_i(Shift_Value_i[k]),
		.Data_o(Data_array[k+1])
		);
	end
endgenerate
Rotate_Mux_Array #(.SW(SW)) last_rotate(
	.Data_i(Data_array[EW]),
	.select_i(FSM_left_right_i),
	.Data_o(Data_o)
	);
endmodule
