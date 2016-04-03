`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2016 14:22:38
// Design Name: 
// Module Name: FSM_Convert_Float_To_Fixed
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


module FSM_Convert_Float_To_Fixed(
		//INPUTS
		input wire CLK, //system clock
		input wire RST_FF, //system reset 
		input wire Exp_out, // INDICA SI EL VALOR DEL EXPONENTE ES MAYOR QUE 127 
		input wire Begin_FSM_FF, //inicia la maquina de estados 
		input wire [7:0] Exp, //CONTIENE EL EXPONENTE DEL NUMERO EN PUNTO FLOTANTE 
		// OUTPUTS		
        output reg EN_REG1, //ENABLE PARA EL REGISTRO QUE GUARDA EL NUMERO EN PUNTO FLOTANTE 
        output reg LOAD, //SELECCION PARA EL REGISTRO DE DESPLAZAMIENTOS 
        output reg MS_1, // SELECCION DEL MUX 1 (VALOR INICIAL DEL EXPONENTE , VALOR MODIFICADO DEL EXPONENTE)
        output reg ACK_FF, // INDICA QUE LA CONVERSION FUE REALIZADA
        output reg EN_MS_1 

	 );


parameter [2:0] 
    //se definen los estados que se utilizaran en la maquina
					 a = 3'b000,
				     b = 3'b001,
					 c = 3'b010,
					 d = 3'b011,
					 e = 3'b100,
					 f = 3'b101;
					
					
reg [2:0] state_reg, state_next ; //state registers declaration

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
	
	EN_REG1 = 1'b0;
    ACK_FF = 1'b0;
    EN_MS_1=1'b0;
    MS_1=1'b0;
    LOAD = 1'b0;
    
	case(state_reg)
		a: 
		begin
			
			if(Begin_FSM_FF) 
			    begin
			    EN_REG1 = 1'b1;
			    ACK_FF = 1'b0;    
				state_next = b;
				end
			else
			    
                state_next = a;
           
		end
		
		b:
		begin
			EN_REG1 = 1'b0;
			if(Exp == 8'b01111111)
                state_next = f;
            else
            state_next = c;
		end
		
		c:
        begin
            EN_MS_1 = 1'b1;
            MS_1 = 1'b1;
            state_next = d;
        end
        
        		
		d:
		begin
		      LOAD = 1'b1;
		      state_next = e;
        end
	
		e:
		begin
			LOAD = 1'b0;
			ACK_FF = 1'b1;
			if(RST_FF)
                 state_next = a;
            else
                state_next = e;
		end
		
		f:
        begin
            EN_MS_1 = 1'b1;
            MS_1 = 1'b0;
            state_next = d;
        end
        
        
	endcase
end

endmodule