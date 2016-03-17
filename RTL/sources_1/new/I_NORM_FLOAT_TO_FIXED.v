`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2016 14:21:56
// Design Name: 
// Module Name: I_NORM_FLOAT_TO_FIXED
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


module I_NORM_FLOAT_TO_FIXED(
    input wire CLK, //system clock
    input wire [31:0] F, //VALOR BINARIO EN COMA FLOTANTE 
    input wire RST_FF, //system reset
    input wire RST_FSM_FF,// RESET FSM 
    input wire Begin_FSM_FF, //INICIA LA CONVERSION 
    output wire ACK_FF,//INDICA QUE LA CONVERSION FUE REALIZADA 
    output wire [31:0] RESULT // RESULTADO FINAL 
    );
    
wire Exp_out;  
wire [7:0] Exp;      
wire EN_REG1; 
wire LOAD;
wire MS_1;
    
    FSM_Convert_Float_To_Fixed FSM_CONVERT_FLOAT_FIXED(
		.CLK(CLK), //system clock
		.RST_FF(RST_FF), //system reset
		.RST_FSM_FF(RST_FSM_FF),
		.Exp_out(Exp_out),
		.Begin_FSM_FF(Begin_FSM_FF), //inicia la maquina de estados 
		.Exp(Exp),	
        .EN_REG1(EN_REG1),  
        .LOAD(LOAD),
        .MS_1(MS_1),
        .ACK_FF(ACK_FF)

	 );
	 
	 Convert_Float_To_Fixed CONVERT_FLOAT_FIXED(
        .CLK(CLK),
        .FLOAT(F),
        .EN_REG1(EN_REG1),
        .LOAD(LOAD),
        .MS_1(MS_1),
        .Exp_out(Exp_out),
        .FIXED(RESULT), 
        .Exp(Exp)
     
      );
endmodule