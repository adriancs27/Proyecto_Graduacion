`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2016 10:04:33
// Design Name: 
// Module Name: PFLOAT_TO_PFIXED_V
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


module PFLOAT_TO_PFIXED_V(
    input wire CLK, //system clock
    input wire [31:0] F, //VALOR BINARIO EN COMA FLOTANTE 
    input wire RST_FF, //system reset
    input wire RST_FSM_FF,// RESET FSM 
    input wire Begin_FSM_FF, //INICIA LA CONVERSION 
    output wire ACK_FF,//INDICA QUE LA CONVERSION FUE REALIZADA 
    output wire [31:0] RESULT // RESULTADO FINAL 
    );
    
wire Exp_out; 
wire [7:0] REG3;  
wire [7:0] Exp;      
wire EN_REG1;
wire EN_REG3;  
wire [1:0] S;
wire MS_1;
wire MS_2;
    
    FSM_FF FSM_FLOAT_FIXED(
		.CLK(CLK), //system clock
		.RST_FF(RST_FF), //system reset
		.RST_FSM_FF(RST_FSM_FF),
		.Exp_out(Exp_out),
		.Begin_FSM_FF(Begin_FSM_FF), //inicia la maquina de estados 
		.REG3(REG3),
		.Exp(Exp),	
        .EN_REG1(EN_REG1),
        .EN_REG3(EN_REG3),  
        .S(S),
        .MS_1(MS_1),
        .MS_2(MS_2),
        .ACK_FF(ACK_FF)

	 );
	 
	 FLOAT_TO_FIXED_V COPROCESADOR_FLOAT_FIXED_V(
        .CLK(CLK),
        .FLOAT(F),
        .EN_REG1(EN_REG1),
        .EN_REG3(EN_REG3),  
        .S(S),
        .MS_1(MS_1),
        .MS_2(MS_2),
        .Exp_out(Exp_out),
        .FIXED(RESULT), 
        .REG3(REG3),
        .Exp(Exp)
     
      );
endmodule
