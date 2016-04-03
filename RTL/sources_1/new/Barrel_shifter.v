`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2016 11:27:29 AM
// Design Name: 
// Module Name: Barrel_shifter
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


module Barrel_Shifter
    #(parameter SW=32, parameter EW=8) //Implicit bit + Significand Width (23 bits for simple format, 52 bits for Double format) 
    //+ guard Bit +  round bit
    (
    input wire clk,
    input wire rst,
    input wire ctrl_a_i,
    input wire [EW-1:0] Shift_Value_0_i,
    input wire [SW-1:0] Shift_Data_0_i,
    input wire FSM_left_right_i,
    
    /////////////////////////////////////////////7
    output wire [SW-1:0] N_mant_o
    );


    wire [SW-1:0] Data_Reg;


    ////////////////////////////////////////////////////7



    Mux_Array #(.SW(SW),.EW(EW)) Mux_Array(
        .Data_i(Shift_Data_0_i),
        .FSM_left_right_i(FSM_left_right_i),
        .Shift_Value_i(Shift_Value_0_i),
        .Data_o(Data_Reg)
        );

    RegisterAdd #(.W(SW)) Output_Reg(
        .clk(clk),
        .rst(rst),
        .load(ctrl_a_i),
        .D(Data_Reg),
        .Q(N_mant_o)
        );

endmodule
