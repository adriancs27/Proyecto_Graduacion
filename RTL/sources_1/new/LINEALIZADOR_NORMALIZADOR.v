`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2016 12:59:34
// Design Name: 
// Module Name: LINEALIZADOR_NORMALIZADOR
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


module LINEALIZADOR_NORMALIZADOR(
    input wire CLK,
    input wire [31:0] I,
    input wire [31:0] V,
    input wire RST_LN_FF,
    input wire RST_FSM_LN_FF,
    input wire Begin_FSM_I,
    input wire Begin_FSM_V,
    output wire ACK_I,
    output wire ACK_V,
    output wire [31:0] RESULT_I,
    output wire [31:0] RESULT_V
    );
    
wire ACK_LN;
wire O_F;
wire U_F; 
wire ACK_FF;
wire [31:0] LINEAL;
    
    LINEALIZADOR #(.P(32)) LINEALIZADOR_FLOAT (
        .CLK(CLK), //system clock
        .T(I), //VALOR DEL ARGUMENTO DEL LOGARITMO QUE SE DESEA CALCULAR 
        .RST_LN(RST_LN_FF), //system reset
        .RST_FSM_LN(RST_FSM_LN_FF), //RESET MAQUINA DE ESTADOS 
        .Begin_FSM_LN(Begin_FSM_I), // INICIAL EL CALCULO 
        .ACK_LN(ACK_LN),// INDICA QUE EL CALCULO FUE REALIZADO 
        .O_F(O_F), //BANDERA DE OVER FLOW
        .U_F(U_F),// BANDERA DE UNDER FLOW 
        .RESULT(LINEAL) //RESULTADO FINAL 
        );
        
        
    PFLOAT_TO_PFIXED NORM_I_PFLOAT_PFIXED(
            .CLK(CLK), //system clock
            .F(LINEAL), //VALOR BINARIO EN COMA FLOTANTE 
            .RST_FF(RST_LN_FF), //system reset
            .RST_FSM_FF(RST_FSM_LN_FF),// RESET FSM 
            .Begin_FSM_FF(ACK_LN), //INICIA LA CONVERSION 
            .ACK_FF(ACK_I),//INDICA QUE LA CONVERSION FUE REALIZADA 
            .RESULT(RESULT_I) // RESULTADO FINAL 
            );
            
    PFLOAT_TO_PFIXED_V NORM_V_PFLOAT_PFIXED(
                        .CLK(CLK), //system clock
                        .F(V), //VALOR BINARIO EN COMA FLOTANTE 
                        .RST_FF(RST_LN_FF), //system reset
                        .RST_FSM_FF(RST_FSM_LN_FF),// RESET FSM 
                        .Begin_FSM_FF(Begin_FSM_V), //INICIA LA CONVERSION 
                        .ACK_FF(ACK_V),//INDICA QUE LA CONVERSION FUE REALIZADA 
                        .RESULT(RESULT_V) // RESULTADO FINAL 
                        );
    
endmodule
