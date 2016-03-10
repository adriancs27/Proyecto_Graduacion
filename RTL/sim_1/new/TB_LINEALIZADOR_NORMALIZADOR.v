`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2016 13:38:37
// Design Name: 
// Module Name: TB_LINEALIZADOR_NORMALIZADOR
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


module TB_LINEALIZADOR_NORMALIZADOR;
        
        parameter P=32;
        parameter D = 5; 
         reg [P-1:0] T;
         reg CLK; //system clock
		 reg RST_LN_FF; //system reset
		 reg RST_FSM_LN_FF;
		 reg Begin_FSM_LN;
		 
		 //OUTPUT SIGNALS
		 wire ACK_FF;
         wire [31:0] RESULT;
                 

    
    
	// Instantiate the Unit Under Test (UUT)
	LINEALIZADOR_NORMALIZADOR uut(
        .CLK(CLK),
        .T(T),
        .RST_LN_FF(RST_LN_FF),
        .RST_FSM_LN_FF(RST_FSM_LN_FF),
        .Begin_FSM_LN(Begin_FSM_LN),
        .ACK_FF(ACK_FF),
        .RESULT(RESULT)
        );


	
	initial begin
		// Initialize Inputs
		CLK = 0;	
        Begin_FSM_LN = 0;
		#10 RST_LN_FF=1;
        RST_FSM_LN_FF=1;
        //T = 32'b00111110101000000000000000000000;//0.3125//00111100001000111101011100001010; // 0.01
        //T = 32'b00111111000000000000000000000000; //0.5	
        //T = 32'b00111110000110011001100110011010; //0.15
        T = 32'b00111101110011001100110011001101; //0.1
        //T = 32'b00111110100110011001100110011010; //0.3
        #10 RST_LN_FF=0;
        RST_FSM_LN_FF=0;
                
        
        Begin_FSM_LN = 1;
        #10 Begin_FSM_LN = 0;
		           
        
       
        
        
    end


 //******************************* Se ejecuta el CLK ************************

   initial forever #5 CLK = ~CLK;

endmodule

