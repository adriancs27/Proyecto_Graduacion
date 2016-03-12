`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2016 14:27:36
// Design Name: 
// Module Name: Float_to_fixed
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


module Float_to_fixed_I(
input wire CLK, //CLOCK 
input wire [31:0] FLOAT, //VALOR DEL NUMERO EN PUNTO FLOTANTE 
input wire EN_REG1, // ENABLE PARA EL REGISTRO 1 QUE GUARDA EL NUMERO EN PUNTO FLOTANTE 
input wire EN_REG3,  // GUARDA EL EXPONENTE MODIFICADO 
input wire [1:0] S, // SELECCION PARA EL REGISTRO DE DESPLAZAMIENTOS  
input wire MS_1, //SELECCIONA EL VALOR DEL EXPONENTE O EL EXPONENTE MODIFICADO 
input wire MS_2, //SELECCIONA LA SUMA O RESTA DEL EXPONENTE 


output wire Exp_out, //INIDICA SI EL EXPONENTE ES MAYOR QUE 127 
output wire [31:0] FIXED, //CONTIENE EL RESULTADO EN COMA FIJA  
output wire [7:0] REG3, // CONTIENE EL VALOR DEL EXPONENTE MODIFICADO 
output wire [7:0] Exp //CONTIENE EL VALOR INICIAL DEL EXPONENTE 

    );


parameter P = 32;
wire [31:0] float; 

FF_D #(.P(P)) REG_FLOAT ( 
        .CLK(EN_REG1), 
        .RST(1'b0),
        .EN(1'b1), 
        .D(FLOAT), 
        .Q(float)
        );

Comparador_Mayor EXP127(
        .CLK(CLK),
        .A(float[30:23]),
        .B(8'b01111111),
        .Out(Exp_out)
        );

wire [31:0] O_SR;
wire [31:0] P_RESULT;
wire [31:0] MUX32;
wire [31:0] NORM;
//wire [7:0] REG3;
wire [7:0] MUX1;
wire [7:0] MUX2;
wire [7:0] ADD;
wire [7:0] SUBT;

assign O_SR [31:27] = 5'b00000;
assign O_SR [26] = 1'b1;  
assign O_SR [25:3] = float[22:0];
assign O_SR [2:0] = 3'b000;

assign Exp = float[30:23];


SHIFT_REG_32Bits S_REG(
       .RST(1'b0),
       .CLK(CLK),
       .SL(1'b0),
       .SR(1'b0),
       .S(S),
       .D(O_SR),
       .Q(P_RESULT)
);

Mux_2x1_8Bits  MUX2x1_1 ( 
            .MS(MS_1), 
            .D_0(float[30:23]), 
            .D_1(REG3), 
            .D_out(MUX1)
            );

S_ADD  ADD_EXP ( 
            .A(MUX1), 
            .B(5'b00001), 
            .Y(ADD)
             );

S_SUBT  SUBT_EXP ( 
            .A(MUX1), 
            .B(5'b00001), 
            .Y(SUBT)
             );


Mux_2x1_8Bits  MUX2x1_2 ( 
            .MS(MS_2), 
            .D_0(SUBT), 
            .D_1(ADD), 
            .D_out(MUX2)
            );

REG_8Bits REG_3(
            .CLK(EN_REG3), //RELOJ DEL SISTEMA
            .RST(1'b0), //RESET
            .EN(1'b1), //ENABLE
            .D(MUX2), //ENTRADA
            .Q(REG3) //SALIDA
            );

NORMALIZADOR NORMA_I(
            .A(P_RESULT), //entrada al normalizador 
            .Y(NORM)//salida de la normalizacion en coma fija, coma entre el bit 30 y 29
                );
                
SUBT_32Bits  SUBT_RESULT ( 
            .A(0), 
            .B(NORM), 
            .Y(MUX32)
             );

//assign MUX32 = P_RESULT ^ 32'b11111111111111111111111111111111;

Mux_2x1 #(.P(P)) MUX2x1_32Bits ( 
    .MS(float[31]), 
    .D_0(NORM), 
    .D_1(MUX32), 
    .D_out(FIXED)
    );
    




//Mux_2x1 #(.P(P)) MUX2x1_32Bits ( 
//            .MS(MS_1), 
//            .D_0(P_RESULT), 
//            .D_1(32'b00000000000000000000000000000000), 
//            .D_out(MUX1)
//            );
endmodule
