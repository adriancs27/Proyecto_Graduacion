`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2016 12:07:59
// Design Name: 
// Module Name: FSM_C_CORDIC
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


module FSM_C_CORDIC(
		//INPUTS
		input wire CLK, //system clock
		input wire RST_LN, //system reset
		input wire RST_FSM_LN,
		input wire ACK_ADD_SUBT,
		input wire Begin_FSM_LN, //inicia la maquina de estados 
		input wire [4:0] CONT_ITER,
		
		//OUTPUT SIGNALS
		output reg RST,
        output reg MS_1,
        output reg EN_REG3,
        output reg EN_REG4,
        output reg [1:0] MS_4,
        output reg ADD_SUBT,
        output reg Begin_SUM,
        output reg EN_REG1X,
        output reg EN_REG1Z,
        output reg EN_REG1Y,
        output reg [1:0] MS_2,
        output reg [1:0] MS_3,
        output reg EN_REG2,
        output reg CLK_CDIR,
        output reg EN_REG2XYZ,
        output reg ACK_LN

	 );


parameter [5:0] 
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
					 k = 6'd10,                          
					 l = 6'd11,  
					 m = 6'd12,
					 n = 6'd13,
					 o = 6'd14,
					 p = 6'd15, 
					 q = 6'd16, 
					 r = 6'd17,
					 s = 6'd18, 
					 t = 6'd19,
                     u = 6'd20,  
					 v = 6'd21, 
					 w = 6'd22,
					 x = 6'd23,
					 y = 6'd24,
	                 z = 6'd25;
					
reg [5:0] state_reg, state_next ; //state registers declaration

////
always @(posedge CLK, posedge RST_LN)
	if (RST_LN) begin
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
	
	EN_REG2 = 0;
    EN_REG3 = 0;
    EN_REG4 = 0;
    EN_REG1X = 0;
    EN_REG1Y = 0;
    EN_REG1Z = 0;
    EN_REG2XYZ = 0;
    Begin_SUM = 0;
    ACK_LN = 0;
    CLK_CDIR = 0;
   // MS_1 = 1'b0;
   // MS_2 = 2'b00;
   // MS_3 = 2'b00;
   // MS_4 = 2'b00;
    //ADD_SUBT = 0;
   // RST = 0;
    
    
	case(state_reg)
//First phase transitions 
		a: 
		begin
			
			if(Begin_FSM_LN) 
			    begin
			    RST = 1;    
				state_next = b;
				end
			else
                state_next = a;
		end
		
		b:
		begin
			RST = 0;
			MS_1 = 1;
			state_next = c;
		end
		
		
		c:
		begin
			EN_REG3 = 1;
			MS_4 = 2'b10;
			ADD_SUBT = 0;
			state_next = d;
		end
	
		d:
		begin
			Begin_SUM = 1;
			state_next = e;
		end
		
		e:
        begin
            Begin_SUM = 0;
            state_next = f;
        end
        
        
		f:
		begin
			
			if(ACK_ADD_SUBT)
			    begin 
			    EN_REG1X = 1;
                EN_REG1Z = 1;
				state_next = g;
				end
			else
				state_next = f;
		end
		
		g:
		begin
		    EN_REG1X = 0;
            EN_REG1Z = 0;
			ADD_SUBT = 1;
			state_next = h;
		end
		
		h:
        begin
            Begin_SUM = 1;
            state_next = i;
        end
                
        i:
        begin
            Begin_SUM = 0;
            state_next = j;
        end
		
		j:
        begin
                        
            if(ACK_ADD_SUBT)
                begin 
                EN_REG1Y = 1;
                MS_1 = 0;
                MS_4 = 2'b01;
                ADD_SUBT = 0;
                state_next = k;
                end
            else
               state_next = j;
        end
        
        k:
        begin
            MS_2 = 2'b10;
            EN_REG1Y = 0;
            EN_REG1Z = 0;
            EN_REG2 = 1;
            MS_3 = 2'b10;
            state_next = l;
        end

        l:
        begin
            EN_REG2XYZ = 1;
            EN_REG2 = 0;
            state_next = m;
        end
        
        m:
        begin
            Begin_SUM = 1;
            EN_REG2XYZ = 0;
            CLK_CDIR = 1;
            MS_2 = 2'b01;
            state_next = n;
        end

        n:
        begin
            Begin_SUM = 0;
            CLK_CDIR = 0;
            state_next = o;
        end 
        
		o:
        begin
                        
            if(ACK_ADD_SUBT)
               begin 
               EN_REG1X = 1;
               EN_REG2XYZ = 1;
               MS_3 = 2'b01;
               state_next = p;
               end
            else
               state_next = o;
        end 
        
        p:
        begin
            Begin_SUM = 1;
            EN_REG1X = 0;
            EN_REG2XYZ = 0;
            MS_2 = 2'b00;
            state_next = q;
        end          
        
        q:
        begin
            Begin_SUM = 0;
            state_next = r;
        end
        
		r:
        begin
                       
            if(ACK_ADD_SUBT)
                begin 
                EN_REG1Y = 1;
                EN_REG2XYZ = 1;
                MS_3 = 2'b00;
                state_next = s;
                end
            else
               state_next = r;
        end  

        s:
        begin
            Begin_SUM = 1;
            EN_REG1Y = 0;
            EN_REG2XYZ = 0;
            state_next = t;
        end          
        
        t:
        begin
            Begin_SUM = 0;
            state_next = u;
        end  
        
		u:
        begin
            
            if(ACK_ADD_SUBT)
                begin 
                EN_REG1Z = 1;
                state_next = v;
                end
            else
               state_next = u;
        end        

		v:
        begin
                       
            if(CONT_ITER == 5'b01111 ) //15 iteraciones
                begin 
                MS_4 = 2'b00;
                ADD_SUBT = 1;
                EN_REG1Z = 0; 
                state_next = w;
                end
            else
               state_next = k;
        end  	
        
        w:
        begin
            Begin_SUM = 1;
            state_next = x;
        end          
        
        x:
        begin
            Begin_SUM = 0;
            state_next = y;
        end 
 
		y:
        begin
            
            if(ACK_ADD_SUBT)
               begin 
               EN_REG4 = 1;
               state_next = z;
               end
            else
               state_next = y;
        end 

        z:
        begin
            EN_REG4 = 0;
            ACK_LN = 1;
            if(RST_FSM_LN)
                state_next = a;
        end
	//**REVISADO
	endcase
end

	
endmodule	