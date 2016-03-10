`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2016 15:43:46
// Design Name: 
// Module Name: FSM_FF
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


module FSM_FF(
		//INPUTS
		input wire CLK, //system clock
		input wire RST_FF, //system reset
		input wire RST_FSM_FF,//RESET MAQUINA  
		input wire Exp_out, // INDICA SI EL VALOR DEL EXPONENTE ES MAYOR QUE 127 
		input wire Begin_FSM_FF, //inicia la maquina de estados 
		input wire [7:0] REG3, //CONTIENE LA RESTA O SUMA DEL EXPONENTE SEGUN SEA EL CASO 
		input wire [7:0] Exp, //CONTIENE EL EXPONENTE DEL NUMERO EN PUNTO FLOTANTE 
		// OUTPUTS		
        output reg EN_REG1, //ENABLE PARA EL REGISTRO QUE GUARDA EL NUMERO EN PUNTO FLOTANTE 
        output reg EN_REG3, //ENABLE PARA EL REGISTRO QUE GUARDA EL VALOR DEL EXPONENTE MODIFICADO 
        output reg [1:0] S, //SELECCION PARA EL REGISTRO DE DESPLAZAMIENTOS 
        output reg MS_1, // SELECCION DEL MUX 1 (VALOR INICIAL DEL EXPONENTE , VALOR MODIFICADO DEL EXPONENTE)
        output reg MS_2, // SELECCION DEL MUX 2 (SUMA , RESTA ) DEL EXPONENTE 
        output reg ACK_FF // INDICA QUE LA CONVERSION FUE REALIZADA 

	 );


parameter [4:0] 
    //se definen los estados que se utilizaran en la maquina
					 a = 6'd0,
				     b = 6'd1,
					 c = 6'd2,
					 d = 6'd3,
					 e = 6'd4,
					 f = 6'd5,
					 g = 6'd6, 
					 h = 6'd7,   
					 i = 6'd8,
					 j = 6'd9,
					 k = 6'd10;
					
reg [4:0] state_reg, state_next ; //state registers declaration

////
always @(posedge CLK, posedge RST_FF)
	if (RST_FF) begin
		state_reg <= a;	
	end
	else begin
		state_reg <= state_next;
	end

//assign State = state_reg;
///	
always @*
begin
	state_next = state_reg;
	
	EN_REG1 = 0;
    EN_REG3 = 0;
    ACK_FF = 0;
    
	case(state_reg)
		a: 
		begin
			
			if(Begin_FSM_FF) 
			    begin
			    EN_REG1 = 1;
			    ACK_FF = 0;    
				state_next = b;
				end
			else
                state_next = a;
		end
		
		b:
		begin
			EN_REG1 = 0;
			S = 2'b11;
			MS_1 = 0;
			state_next = c;
		end
		
		c:
        begin
            if(Exp == 8'b01111111)
                state_next = i;
            else
                state_next = d;
        end
        
        		
		d:
		begin
			if(Exp_out == 1)
                state_next = e;
            else
                state_next = j;
        end
	
		e:
		begin
			MS_2 = 0;
			S = 2'b10;
			state_next = f;
		end
		
		f:
        begin
            S = 2'b00;
            EN_REG3 = 1;
            state_next = g;
        end
        
        g:
        begin
            EN_REG3 = 0;
            state_next = h;
        end
        
		h:
		begin
			MS_1 = 1;
			if(REG3 == 8'b01111111)
			    state_next = i;
			else
				state_next = d;
		end
		
		i:
        begin
            S = 2'b00;
            ACK_FF = 1;
            if(RST_FSM_FF)
                state_next = a;
        end
        
		j:
        begin
            S = 2'b01;
            MS_2 = 1;
            state_next = f;
        end
	endcase
end

endmodule	