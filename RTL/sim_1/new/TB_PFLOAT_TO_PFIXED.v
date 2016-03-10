`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2016 16:32:47
// Design Name: 
// Module Name: TB_PFLOAT_TO_PFIXED
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


module TB_PFLOAT_TO_PFIXEDRESULT;
        
         reg [31:0] F;
         reg CLK; //system clock
		 reg RST_FF; //system reset
		 reg RST_FSM_FF;
		 reg Begin_FSM_FF;
		 
		 //OUTPUT SIGNALS
		 wire ACK_FF;
         wire [31:0] RESULT;                

    
    
	// Instantiate the Unit Under Test (UUT)
	PFLOAT_TO_PFIXED uut (
        .CLK(CLK), //RELOJ DEL SISTEMA
        .F(F),
        .RST_FF(RST_FF), //system reset
        .RST_FSM_FF(RST_FSM_FF),
        .Begin_FSM_FF(Begin_FSM_FF), //inicia la maquina de estados 
        .ACK_FF(ACK_FF),
        .RESULT(RESULT)
        );



	
	initial begin
		// Initialize Inputs
		CLK = 0;	
        Begin_FSM_FF = 0;
		#10 RST_FF=1;
        RST_FSM_FF=1;
        //F = 32'b00111111100100110011001100110011;//1.15	float
        
        //F = 32'b01000000010000011001100110011010;//3.025	float
        //F = 32'b00111100110011001100110011001101;//0.025	float
        //F = 32'b00111100100100110111010010111100; //0.018 float 
        //F = 32'b01000000100001001100110011001101; //4.15 float
        //F = 32'b00111111100000000000000000000000; //1 float
        //F = 32'b10111111100000000000000000000000; //-1 float 
        //F = 32'b10111111100100110011001100110011; //-1.15 float 
         F = 32'b11000001011101000000000000000000; //-15.25
        //F = 32'b01000001011101000000000000000000; //15.25
        #10 RST_FF=0;
        RST_FSM_FF=0;
                
        
        Begin_FSM_FF = 1;
        #10 Begin_FSM_FF = 0;
		           
        
       
        
        
    end


 //******************************* Se ejecuta el CLK ************************

   initial forever #5 CLK = ~CLK;

endmodule
