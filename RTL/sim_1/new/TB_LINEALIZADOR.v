`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2016 17:19:18
// Design Name: 
// Module Name: TB_LINEALIZADOR
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


module TB_LINEALIZADOR;
        
        parameter P=32;
        parameter D = 5; 
         reg [P-1:0] T;
         reg CLK; //system clock
		 reg RST_LN; //system reset
		 reg RST_FSM_LN;
		 reg Begin_FSM_LN;
		 
		 //OUTPUT SIGNALS
		 wire ACK_LN;
         wire O_F;
         wire U_F;
         wire [P-1:0] RESULT;
                 

    
    
	// Instantiate the Unit Under Test (UUT)
	LINEALIZADOR uut (
        .CLK(CLK), //RELOJ DEL SISTEMA
        .T(T),
        .RST_LN(RST_LN), //system reset
        .RST_FSM_LN(RST_FSM_LN),
        .Begin_FSM_LN(Begin_FSM_LN), //inicia la maquina de estados 
        .ACK_LN(ACK_LN),
        .O_F(O_F),
        .U_F(U_F),
        .RESULT(RESULT)
        );



	
	initial begin
		// Initialize Inputs
		CLK = 0;	
        Begin_FSM_LN = 0;
		#10 RST_LN=1;
        RST_FSM_LN=1;
        T = 32'b00111011110110111000101110101100;//0.006677688//00111100001000111101011100001010; // 0.01	
        
        #10 RST_LN=0;
        RST_FSM_LN=0;
                
        
        Begin_FSM_LN = 1;
        #10 Begin_FSM_LN = 0;
		           
        
       
        
        
    end


 //******************************* Se ejecuta el CLK ************************

   initial forever #5 CLK = ~CLK;

endmodule

