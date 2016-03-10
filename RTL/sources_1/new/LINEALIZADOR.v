`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2016 16:43:38
// Design Name: 
// Module Name: LINEALIZADOR
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


module LINEALIZADOR #(parameter P = 32)(
    input wire CLK, //system clock
    input wire [P-1:0] T, //VALOR DEL ARGUMENTO DEL LOGARITMO QUE SE DESEA CALCULAR 
    input wire RST_LN, //system reset
    input wire RST_FSM_LN, //RESET MAQUINA DE ESTADOS 
    input wire Begin_FSM_LN, // INICIAL EL CALCULO 
    output wire ACK_LN,// INDICA QUE EL CALCULO FUE REALIZADO 
    output wire O_F, //BANDERA DE OVER FLOW
    output wire U_F,// BANDERA DE UNDER FLOW 
    output wire [P-1:0] RESULT //RESULTADO FINAL 
    
    );
    

wire [4:0] CONT_ITERA;
wire RST;
wire MS_1;
wire EN_REG3;
wire EN_REG4;
wire [1:0] MS_4;
wire ADD_SUBT;
wire Begin_SUM;
wire EN_REG1X;
wire EN_REG1Z;
wire EN_REG1Y;
wire [1:0] MS_2;
wire [1:0] MS_3;
wire EN_REG2;
wire CLK_CDIR;
wire EN_REG2XYZ;
wire ACK_SUM;

 
Coprocesador_CORDIC C_CORDIC_LN (
                .T(T),
                .CLK(CLK), //RELOJ DEL SISTEMA
                .RST(RST),
                .MS_1(MS_1),
                .EN_REG3(EN_REG3),
                .EN_REG4(EN_REG4),
                .MS_4(MS_4),
                .ADD_SUBT(ADD_SUBT),
                .Begin_SUM(Begin_SUM),
                .EN_REG1X(EN_REG1X),
                .EN_REG1Z(EN_REG1Z),
                .EN_REG1Y(EN_REG1Y),
                .MS_2(MS_2),
                .MS_3(MS_3),
                .EN_REG2(EN_REG2),
                .CLK_CDIR(CLK_CDIR),
                .EN_REG2XYZ(EN_REG2XYZ),
                .ACK_SUM(ACK_SUM),
                .O_F(O_F),
                .U_F(U_F),
                .RESULT(RESULT),
                .CONT_ITERA(CONT_ITERA)
                );
                
FSM_C_CORDIC M_E_LN (
                        .CLK(CLK), //RELOJ DEL SISTEMA
                        .RST_LN(RST_LN), //system reset
                        .RST_FSM_LN(RST_FSM_LN),
                        .ACK_ADD_SUBT(ACK_SUM),
                        .Begin_FSM_LN(Begin_FSM_LN), //inicia la maquina de estados 
                        .CONT_ITER(CONT_ITERA),
                        .RST(RST),
                        .MS_1(MS_1),
                        .EN_REG3(EN_REG3),
                        .EN_REG4(EN_REG4),
                        .MS_4(MS_4),
                        .ADD_SUBT(ADD_SUBT),
                        .Begin_SUM(Begin_SUM),
                        .EN_REG1X(EN_REG1X),
                        .EN_REG1Z(EN_REG1Z),
                        .EN_REG1Y(EN_REG1Y),
                        .MS_2(MS_2),
                        .MS_3(MS_3),
                        .EN_REG2(EN_REG2),
                        .CLK_CDIR(CLK_CDIR),
                        .EN_REG2XYZ(EN_REG2XYZ),
                        .ACK_LN(ACK_LN)
                        );
endmodule
