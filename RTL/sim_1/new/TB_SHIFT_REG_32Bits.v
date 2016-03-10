`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2016 14:02:47
// Design Name: 
// Module Name: TB_SHIFT_REG_32Bits
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


module TB_SHIFT_REG_32Bits;

	reg CLK;
    reg RST;
    reg SL; 
    reg SR;  
    reg [1:0] S;
    reg [31:0] D; 
    //outputs
    wire [31:0] Q;

    
        
	// Instantiate the Unit Under Test (UUT)
	SHIFT_REG_32Bits uut (
		.CLK(CLK),
		.RST(RST), 
		.SL(SL),
		.SR(SR),
		.S(S),
		.D(D),
		.Q(Q)
	);

  

	
	initial begin
		// Initialize Inputs
		CLK = 0;
		RST = 0;
		S= 2'b00;
		D = 32'b11111111111111111111111111111111;
		SL=0;
		SR=0;	
        #10 S = 2'b11; 
        #10 S = 2'b10; 
        #10 S = 2'b01;
		#10 S = 2'b11;
	
		
//		// Wait 100 ns for global reset to finish
       
        
        
    end


 //******************************* Se ejecuta el CLK ************************

   initial forever #5 CLK = ~CLK;

endmodule
