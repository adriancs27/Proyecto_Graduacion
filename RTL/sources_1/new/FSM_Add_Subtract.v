`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:09:39 08/25/2015 
// Design Name: 
// Module Name:    FSM_Add_Subtract 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FSM_Add_Subtract
	(
		//INPUTS
		input wire clk, //system clock
		input wire rst, //system reset
		input wire rst_FSM,
		input wire beg_FSM, //Begin Finite State Machine
		//**REVISAD
		
	//////////////////////////////////////////////////////////////////////////////
		//Zero phase evaluation signals
		input wire zero_flag,
		
	/////////////////////////////////////////////////////////////////////////////
	
		//Fourth phase evaluation signals
		input wire [1:0] Sgfn_R_MSBs, //Signal used to shift the RegisterAdd on fourth phase
		//**REVISADO
		
		//Sixth phase evaluation signals
		input wire overflow_a, //The a it's because there's another phase where we can get an overflow
		input wire underflow,
		//**REVISADO
			
		//Ninth phase evaluation signals
		input wire ovflow_post_round,
		//**REVISADO
		
		
		//OUTPUT SIGNALS
	
////////////////////////////////////////////////////////////////////////////////////	
		//Zero Phase control signals
		output reg load_0,
///////////////////////////////////////////////////////////////////////////////////

		//First phase control signals
		output reg load_1, //This signal enables the RegisterAdds 1,2 and 3 from the first module
		output reg load_2, //Enables RegisterAdds 4,5, 6 ; RegisterAdd 6 was removed
		output reg load_3, //Enables RegisterAdds 7,8
		//*********************REVISADO
		
		//Second phase control signals
		output reg load_4, //Enables register 9
		output reg load_5, //Enables register 10
		//********************REVISADO
		
		//Third phase control signals
		output reg load_6, //Enables register 11
		//********************REVISADO
		
		//Fourth phase control signals
		output reg selector_4_P, //Mux signal
		output reg load_8, //Enables register 13 
		////Universal Shift Register
		output reg sl, //Shift left signal
		output reg sr, //Shift right signal
		output reg load_7, //Register 12 
		//********************REVISADO
		
		//Fifth phase control signals
		output reg add_subt_5_P, //Select if add or subtract a 1 from the exponent of the largest operand 
		output reg load_9, //Enables Register 14
		output reg load_10, //Enables Register 15 
		output reg selector_5_P, //Selector of which exponent to update
		output reg selector_5_P_exp,
		output reg load_11, //Enables register 16
		//*********************REVISADO
		
		//Sixth phase control signals
		output reg load_12, //Enables register 17 and 18
		//*********************REVISADO
		
		//Seventh phase control signals
		output reg load_13, //Loads register 19
		output reg load_14, //Loads register 20
		//*********************REVISADO
		
		//Eight phase control signals
		output reg load_15, //Loads registers 21,22
		//*********************REVISADO
		
		//Ninth phase control signals
		output reg load_16, //Loads register 23
		output reg load_17, //Loads registers 24,25
		//*********************REVISADO
	 
		//Tenth phase control signals
		output reg selector_10_P_a,
		output reg load_18, //Loads registers 26,27
		output reg selector_10_P_b,
		output reg load_19, //Load register 28
		//*********************REVISADO
		
		//Internal reset signal
		output reg rst_int,
		//Ready  Signal
		output reg ready
	 );


parameter [5:0] 
//First I'm going to declarate the registers of the first phase of execution
					 zero = 6'd0, //This state evaluates the beg_FSM to begin operations
				     load_oper = 6'd1, //This state enables the registers that contains
											 //both operands and the operator
					 off_load_oper = 6'd2, //Disable the load statement of the registers on load_oper,
					 //moreover it's a steady state to combinational logic to do their stuff
					 
			///////NEW STATES/////////////////////

					 zero_info_state_a = 6'd3,
					 zero_info_state_b = 6'd4,
					 
			/////////////////////////////////////	
			
					 load_swap = 6'd5, //Load the registers that contains info to swap both operando and classify them as largest and smalest
					 off_load_swap = 6'd6, //Again it's a disable state and it's useful to give time to some combinational logic to work
					 load_op_m_M = 6'd7, //In this state occurs the load of the registers wich saves the operands (largest and smallest) in a correct format  
					 off_load_op_m_M = 6'd8, //load off of 5'd5 register
					 //**********************REVISADO

//Second phase states
					 load_diff_exp = 6'd9, //Load the register 9, which stores the exponent subtract result
					 off_load_diff_exp = 6'd10, //Disables the load statement of the register 9 and gives time to combinational logic to work                         
					 load_norm_sgfm  = 6'd11, //Load the register 10, wich contains the smallest normalized significand 
					 off_load_norm_sgfm = 6'd12,
					 //********************REVISADO
					 
//Third phase states
					 sgf_add_sub = 6'd13,
					 off_sgf_add_sub = 6'd14,
					 //********************REVISADO
					 
//Fourth phase states
					 norm_sgf_r = 6'd15, //Load the first time the significand from the third phase
					 norm_sgf_r_a = 6'd16, //Asking about the MSB's combination
					 norm_sgf_r_b = 6'd18, //Asking about the MSB's combination
					 norm_sgf_r_c = 6'd17, //Shift left state
					 norm_sgf_r_d = 6'd19, //Shift right state
                     norm_sgf_r_e = 6'd29, //Significand Normalized  
					 norm_sgf_r_f = 6'd27, //Prepares the normalization process again
					 norm_sgf_r_g = 6'd28, //Prepares the normalization process again
					//*********************REVISADO

//Fifth phase states
					exp_update = 6'd20, //load the exponent of the largest significand -- Register 14
					exp_update_a = 6'd21, //Disable de load of the register 14 and make some time to the combinational logic
					exp_update_b = 6'd22, //load the exponent plus or less one to the register 15
					exp_update_c = 6'd23, //Disables the load of the register 15 and it's a pointer to the handling exception logic
					//*********************REVISADO
					
//Sixth phase states
					except_hand = 6'd24, //Loads the registers containing information about overflow and underflow
					except_hand_a = 6'd25, //Overflow?
					except_hand_b = 6'd26, //Underflow?
					//*********************REVISADO

//Seventh phase states
					round_sgf_r = 6'd30,
					round_sgf_r_a = 6'd31,
					round_sgf_r_b = 6'd32,
					round_sgf_r_c = 6'd33,
					//*********************REVISADO
					
//Eight phase states
					round_sgf_r_d = 6'd34,
					//*********************REVISADO

//Ninth phase states
					overflow_post_round = 6'd35,
					overflow_post_round_a = 6'd36,
					overflow_post_round_b = 6'd37,
					overflow_post_round_c = 6'd38,
					//*********************REVISADO

//Tenth phase states
					final_result_a = 6'd39,
					final_result_a_a = 6'd40,
					final_result_a_b = 6'd41,
					final_result_a_c = 6'd42,
					
					final_result_b = 6'd43,
					final_result_b_a = 6'd44,
					
					final_result_c = 6'd45,
					
					final_result_d = 6'd46,
					final_result_d_a = 6'd47,
					final_result_d_b = 6'd48;
					//**********************REVISADO
	
					
reg [5:0] state_reg, state_next ; //state registers declaration
		 

////
always @(posedge clk, posedge rst)
	if (rst) begin
		state_reg <= zero;	
	end
	else begin
		state_reg <= state_next;
	end

///	
always @*
	begin
	state_next = state_reg;
	
	//Zero phase signals
	load_0 = 0;
	//First phase signals
	load_1 = 0;
	load_2 = 0;
	load_3 = 0;
	//**REVISADO
	
	//Second phase signals
	load_4 = 0;
	load_5 = 0;
	//**REVISADO
	
	//Third phase signals
	load_6 = 0; 
	//**REVISADO
	
	//Fourth phase signals
	selector_4_P = 0;
	load_7 = 0;
	sl = 0;
	sr = 0;
	load_8 = 0;
	//**REVISADO
	
	//Fifth phase signals
	load_9 = 0;
	load_10 = 0;
	load_11 = 0;
	add_subt_5_P = 0;
	selector_5_P = 0;
	selector_5_P_exp = 0;
	//**REVISADO
	
	//Sixth phase signals
	load_12 = 0;
	//**REVISADO
	
	//Seventh phase signals
	load_13 = 0;
	load_14 = 0;
	//**REVISADO
	
	//Eight phase signals
	load_15 = 0;
	//**REVISADO
	
	//Ninth phase signals
	load_16 = 0;
	load_17 = 0;
	//**REVISADO
	
	//Tenth phase signals
	selector_10_P_a = 0;
   load_18 = 0; 
   selector_10_P_b = 0;
	load_19 = 0; 
	//**REVISADO
	
	//Ready Phase
	ready = 0;
	//**REVISADO
	rst_int = 0;

	case(state_reg)
//First phase transitions 
		zero: begin
			rst_int = 1;
			if(beg_FSM) begin
				state_next = load_oper;
			end
		end
		load_oper:
		begin
			load_1 = 1;
			state_next = off_load_oper;
		end
		off_load_oper:
		begin
			load_1 = 0;
			state_next = zero_info_state_a;
		end
		
		////////////INTRODUCTION OF THE ZERO EXCEPTION STATES
		zero_info_state_a:
		begin
			load_0 = 1;
			state_next = zero_info_state_b;
		end
		zero_info_state_b:
		begin
			load_0 = 0;
			if(zero_flag)
				state_next = final_result_a_c;
			else
				state_next = load_swap;
		end
		//////////////////////////////////////////////////////
		load_swap:
		begin
			load_2 = 1;
			state_next = off_load_swap;
		end
		off_load_swap:
		begin
			load_2 = 0;
			state_next = load_op_m_M;
		end
		load_op_m_M: 
		begin
			load_3 = 1;
			state_next = off_load_op_m_M;
		end
		off_load_op_m_M:
		begin
			load_3 = 0;
			state_next = load_diff_exp;
		end
		//**REVISADO
		
////SECOND PHASE TRANSITIONS AND OUTPUT LOGIC
		load_diff_exp:
		begin
			load_4 = 1;
			state_next = off_load_diff_exp;
		end
		off_load_diff_exp:
		begin
			load_4 = 0;
			state_next = load_norm_sgfm;			
		end
		load_norm_sgfm:
		begin
			load_5 = 1;
			state_next = off_load_norm_sgfm;
		end
		off_load_norm_sgfm:
		begin
			load_5 = 0;
			state_next = sgf_add_sub;
		end
		//**REVISADO
		
////THIRD PHASE TRANSITIONS AND OUTPUT LOGIC
		sgf_add_sub:
		begin
			load_6 = 1;
			state_next = off_sgf_add_sub;
		end
		off_sgf_add_sub:
		begin
			load_6 = 0;
			state_next = norm_sgf_r;
		end
		//**REVISADO
	
///FOURTH PHASE TRANSITIONS AND OUTPUT LOGIC
		norm_sgf_r: //Occurs the normalization process
		begin
			load_7 = 1; //Load shift register
		   state_next = norm_sgf_r_a; //I'm going to verify if the resultant significand is normalized or not
		end
		norm_sgf_r_a: //a: We ask about the state of the carry out bit and leading bit of the resultant significand
		//as a strategy to decide how to act over the universal shift register 
		begin
			load_7 = 0; //Cancels the shift statement on the USR
			if(Sgfn_R_MSBs == 2'b00) //Shifth left if this condition is achieved
				state_next = norm_sgf_r_c; //b: Shift left state
			else
				state_next = norm_sgf_r_b; //Ask for another bit combination
		end
		norm_sgf_r_b:
		begin
			if (Sgfn_R_MSBs == 2'b10 || Sgfn_R_MSBs == 2'b11) begin
				state_next = norm_sgf_r_d; //Shift right state
			end else
				state_next = norm_sgf_r_e;	//Everything's ok			
		end
		///////////////////
		norm_sgf_r_c: //Attend the shift left process
		begin
			sl = 1;
			add_subt_5_P = 1; //THIS SIGNAL IS PROPERTY OF THE FIFTH PHASE
			state_next = exp_update; //We need to update the exponent because the shift on the signficand
		end
		norm_sgf_r_d: //Attend the shift right process
		begin
			sr = 1;
			add_subt_5_P = 0; //THIS SIGNAL IS PROPERTY OF THE FIFTH PHASE
			state_next = exp_update; //We need to update the exponent because the shift on the exponent
		end
		norm_sgf_r_e: //If the MSB'S of the resultant significand are 01 the significand is normalized
		begin
			load_8 = 1; //It's possible a no normalization process the first time, so we need to charge this value
			load_11 = 1; //It's the probably resultant exponent -- Register 16
			state_next = round_sgf_r; //So we proceed to the rounding state
		end
		norm_sgf_r_f: //Again, we need to look if the significand is not normalized yet	
		begin
			load_8 = 1;// load the new shifted significand to verify if is normalized
			selector_4_P = 1; //Selects the new shifted significand to verify again 
			selector_5_P = 1; //Selects the new exponent in case we need to update it
			selector_5_P_exp = 1; //The resultant exponent is given for the modified one
			state_next = norm_sgf_r_g;
			//and the selectors remain like this for the rest of the process
		end
		norm_sgf_r_g:
		begin
			load_8 = 0;
			state_next = norm_sgf_r; //Begins the verification and normalization process again
		end
		//****REVISADO-------------***PUEDEN HABER ERRORES!
		
///FIFTH PHASE TRANSITION AND OUTPUT LOGIC
		exp_update:
		begin
			sl = 0;//STOPS DE SHIFTING PROCESS
			sr = 0;
			load_9 = 1;
			state_next = exp_update_a;	
		end
		exp_update_a:
		begin
			load_9 = 0;
			state_next = exp_update_b;
		end
		exp_update_b:
		begin
			load_10 = 1;
			state_next = exp_update_c;
		end
		exp_update_c:
		begin
			load_10 = 0;
			state_next = except_hand;
		end 
		//*****REVISADO
			
///SIXTH PHASE TRANSITION AND OUTPUT LOGIC
		except_hand: //First stage of exception handling
		begin
			load_12 = 1;
			state_next = except_hand_a;	
		end
		except_hand_a: 
		begin
			load_12 = 0;
			if(overflow_a)
				state_next = final_result_a; //Modifies the tenth phase 
			else
				state_next = except_hand_b; //INCLUIR EN LOS ESTADOS
		end
		except_hand_b:
		begin
			if(underflow)
				state_next = final_result_b; //Modifies the tenth phase
			else
				state_next = norm_sgf_r_f;
		end
		//**REVISADO
		
////SEVENTH PHASE TRANSITION AND OUTPUT LOGIC
	round_sgf_r:
	begin
		load_8 = 0; //Turnos off the load function of the final significand register
		load_11 = 0; //Turns off the load function of the final exponent register
		load_13 = 1; //Loads register 19
		state_next = round_sgf_r_a;
	end
	round_sgf_r_a:
	begin
		load_13 = 0; //Turn off the load process of the register 19 and gives time to the combinational logic
		state_next = round_sgf_r_b;
	end
	round_sgf_r_b:
	begin
		load_14 = 1;
		state_next = round_sgf_r_c;
	end
	round_sgf_r_c:
	begin
		load_14 = 0;
		state_next = round_sgf_r_d;
	end
	//**REVISADO

//EIGTH PHASE TRANSITION AND OUTPUT LOGIC
	round_sgf_r_d:
	begin
	load_15 = 1;
	state_next = overflow_post_round;
	end
	//**REVISADO

//NINTH PHASE TRANSITION AND OUTPUT LOGIC	
	overflow_post_round:
	begin
		load_15 = 0;
		load_16 = 1;
		state_next =  overflow_post_round_a;
	end
	overflow_post_round_a:
	begin
		load_16 = 0;
		state_next = overflow_post_round_b;
	end
	overflow_post_round_b:
	begin
		load_17 = 1;
		state_next = overflow_post_round_c;
	end
	overflow_post_round_c:
	begin
		load_17 = 0;
		state_next = final_result_c;
	end
  //**REVISADO
  
//TENTH PHASE TRANSITION AND OUTPUT LOGIC
	final_result_a: //Overflow before rounding
	begin
		selector_10_P_a = 1;
		state_next = final_result_a_a;
	end
	final_result_a_a:
	begin
		load_18 = 1;
		state_next = final_result_a_b;
	end
	final_result_a_b:
	begin
		load_18 = 0;
		load_19 = 1;
		state_next = final_result_a_c;
	end	
	final_result_a_c:
	begin
		ready = 1;
		load_19 = 0;
		if(rst_FSM)
			state_next = zero;
	end
	////////////////////////////////////////////////////
	final_result_b: //Underflow before rounding
	begin
		load_18 = 1;
		state_next = final_result_b_a;
	end
	final_result_b_a:
	begin
		load_18 = 0;
		load_19 = 1;
		state_next = final_result_a_c;
	end	
	///////////////////////////////////////////////////////
	final_result_c: //Overflow (or not) post rounding
	begin
		if(ovflow_post_round)
			state_next = final_result_a; //Overflow post round
		else
			state_next = final_result_d; //No problem with the operation
	end
	////////////////////////////////////////////////////////
	final_result_d:
	begin
		selector_10_P_b = 1;
		state_next = final_result_d_a;
	end
	final_result_d_a:
	begin
//		selector_10_P_b = 1; //ojoooooooooooo
		load_18 = 1;
		state_next = final_result_d_b;
	end
	final_result_d_b:
	begin
//		selector_10_P_b = 1; //ojoooooooooooooooo
		load_18 = 0;
		load_19 = 1;
		state_next = final_result_a_c;
	end	
	//**REVISADO
	endcase
end

	
endmodule		 

