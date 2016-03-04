`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:20:57 09/06/2015 
// Design Name: 
// Module Name:    FSM_Mult_Function 
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
module FSM_Mult_Function(
	//INPUTS
	input wire clk,
	input wire rst,
	input wire beg_FSM, //Begin the multiply operation
	input wire rst_FSM, //Is used in the last state, is an aknowledge signal
	
	//ZERO PHASE EVALUATION SIGNALS
	input wire zero_flag,
	
	//THIRD PHASE INPUT SIGNALS *EVALUATION SIGNALS
	input wire overflow_cout,
	input wire overflow_comp_a,
	
	//SIXTH PHASE INPUT SIGNALS *EVALUATION SIGNALS
	input wire overflow_comp_b,
	
	//NINTH PHASE EVALUATION SIGNALS
	input wire underflow_f,
	
	//Zero phase control signals
	output reg rst_int, //Internal reset for the modules that forms part of the multiplication module
	output reg load_0, //Load of register that contains info about zero result
	//First phase control signals
	output reg load_1, //Controls the load signal from the registers of this stage
	//Registers 1---2
	
	//Second phase control signals
	output reg load_2, //Load Signal for register 3
	
	//Third phase control signals
	output reg load_3, //Load signal for registers 4,5,6
	
	//Fourth phase control signals
	output reg load_4_A, //load signal of additional registers
	output reg load_4, //Load signal for register 7
	
	//Fifth Phase control signals
	output reg selector_a, //Controls the mux which selects the significands of the fifth and seventh phase
	output reg load_5,

	//Sixth Phase control signals
	output reg selector_b,
	output reg load_6,
	output reg load_7,

	//Seventh Phase control signals
	output reg load_8,
	
	//Eight Phase control signals
	output reg load_9,
	output reg load_10,
	output reg ready,
	output reg selector_c,
	output reg selector_d,
	
	//Ninth Phase control signals
	output reg load_11,
	output reg load_12
    );


////////States///////////
//Zero Phase
parameter [5:0] zero = 6'd0,
//First Phase
load_operands = 6'd1, //loads both operands to registers

//Zero Phase
zero_check_a = 6'd2,
zero_check_b = 6'd3,
zero_check_c = 6'd4,


//Second Phase
addsub_exp_bias = 6'd5, //It's a "giving time" state for some combinational logic to work
load_addsubexpbias = 6'd6, //Loads the register which contains the result of the second state

//Third Phase
info_exp_a = 6'd7, //Gives time to the comparator of this phase to execute
load_exp_ovflow_info =  6'd8, //Loads the registers with relevant info about
first_ov_ccout = 6'd9, //Ask if exist overflow looking on the carry out bit of the exponet
first_ov_ccomp = 6'd10, //Ask for overflow comparing with the parameter h'fe

//Fourth Phase
load_pre_mult_sgfs = 6'd11,
pre_mult_time = 6'd12,
load_mult_sgfs = 6'd13,//Loads the register which contains the product of the significands

//Fifth Phase
r_sgf_selection_a = 6'd14, //Loads off the register of the state 8, the selector does not change the value
r_sgf_selection_b = 6'd15, //both the a and b selection are thinking to give time to the multiplexers of this stage
r_sgf_selection_c = 6'd16, //Loads a first version of the resultant significand also brings information of an update required by the exponent

//Sixth Phase
exp_update_a = 6'd17,
exp_update_b = 6'd18,
exp_update_c = 6'd19,
exp_update_d = 6'd20,
exp_update_e = 6'd21,
second_ov_ccomp = 6'd22,

//Seventh Phase
round_state_a = 6'd23,
update_sgf_a = 6'd24, //Again to the fifth phase to update the significand
update_sgf_b = 6'd25,
update_sgf_c = 6'd26,
new_update_exp_a = 6'd27, //Again to the sixth phase
new_update_exp_b = 6'd28,
new_update_exp_c = 6'd29,
new_update_exp_d = 6'd30,
new_update_exp_e = 6'd31,
f_overflow_q = 6'd32,

//Eight Phase
final_result_a = 6'd33,
final_result_b = 6'd34,
final_result_c = 6'd35,
final_result_d = 6'd36,

//Overflow management states
overflow_management_a = 6'd37,
overflow_management_b = 6'd38,

//Underflow management states
underflow_check_a = 6'd39,
underflow_check_b = 6'd40,
underflow_check_c = 6'd41,
underflow_check_d = 6'd42,
underflow_info =  6'd43,
underflow_management_a = 6'd44,
underflow_management_b = 6'd45;


//State registers
reg [5:0] state_reg, state_next;

//State registers reset and standby logic
always @(posedge clk, posedge rst)
	if(rst)
		state_reg <= zero;
	else
		state_reg <= state_next;

//Transition and Output Logic
always @*
	begin
	//STATE DEFAULT BEHAVIOR
	state_next = state_reg; //If no changes, keep the value of the register unaltered
	
	//ZERO PHASE DEFAULT SIGNALS
	rst_int = 0; //The internal reset is zero but in the zero state
	load_0 = 0;
	
	//FIRST PHASE DEFAULT SIGNALS
	load_1 = 0; //Default value of this signal, it does not change unless you do it in an state
	//but this value comes back to the default when you exit 
	
	//SECOND PHASE DEFAULT SIGNALS
	load_2 = 0;
	
	//THIRD PHASE DEFAULT SIGNALS
	load_3 = 0;
	
	//FOURTH PHASE DEFAULT SIGNALS
	load_4_A = 0;
	load_4 = 0;
	
	//FIFTH PHASE DEFAULT SIGNALS
	selector_a = 0;
	load_5 = 0;
	
	//SIXTH PHASE DEFAULT SIGNALS
	selector_b = 0;
	load_6 = 0;
	load_7 = 0;
	
	//SEVENTH PHASE DEFAULT SIGNALS
	load_8 = 0;
	
	//EIGHT PHASE DEFAULT SIGNALS
	load_9 = 0;
	load_10 = 0;
	selector_c = 0;
	selector_d = 0;
	ready = 0;
	
	//NINTH PHASE DEFAULT SIGNALS
	load_11 = 0;
	load_12 = 0;
	
	case(state_reg)
		zero:
		begin
			rst_int = 1;
			if(beg_FSM)
				state_next = load_operands; //Jump to the first state of the machine
		end
		//First Phase 
		load_operands:
		begin
			load_1 = 1;
			state_next = zero_check_a;
		end
		
		//Zero Check
		zero_check_a:
		begin
			load_1 = 0;
			state_next = zero_check_b;
		end
		zero_check_b:
		begin
			load_0 = 1;
			state_next = zero_check_c;
		end
		zero_check_c:
		begin
			if(zero_flag)
				state_next = final_result_d;
			else
				state_next = underflow_check_a;
		end
		//Ninth Phase
		underflow_check_a:
		begin
			state_next = underflow_check_b;
		end
		underflow_check_b:
		begin
			load_11 = 1; //Loads the add result of the exponents
			state_next = underflow_check_c;
		end
		underflow_check_c:
		begin
			load_11 = 0;
			state_next = underflow_check_d;
		end
		underflow_check_d:
		begin
			load_12 = 1;
			state_next = underflow_info;
		end
		underflow_info:
		begin
			load_12 = 0;
			if(underflow_f)
				state_next = underflow_management_a;
			else
				state_next = addsub_exp_bias;
		end
		
		//Second Phase
		addsub_exp_bias: //This state gives time to combinational logic 
		begin
			state_next = load_addsubexpbias ;
		end
		load_addsubexpbias:
		begin
			load_2 = 1;
			state_next = info_exp_a; 
		end
		
		//Third phase
		info_exp_a: //Gives time to a combinational logic to execute
		begin
			load_2 = 0;
			state_next = load_exp_ovflow_info;
		end
		load_exp_ovflow_info: //Loads info about the exponent and overflow status
		begin
			load_3 = 1;
			state_next = first_ov_ccout;
		end
		first_ov_ccout:
		begin
			load_3 = 0;
			if(overflow_cout) begin
				selector_d = 1; //Selects the overflow code
				state_next = overflow_management_a; //Ends the process with the exception handling
			end
			else
				state_next = first_ov_ccomp;
		end
		first_ov_ccomp:
			if(overflow_comp_a) begin
				selector_d = 1;
				state_next = overflow_management_a;
			end
			else
				state_next = load_pre_mult_sgfs;
		/////////////////////////////////////////**
		//Fourth Phase
		//****************************CORRECCION CLK SKEW*******
		load_pre_mult_sgfs:
		begin
			load_4_A = 1;
			state_next = pre_mult_time;
		end
		pre_mult_time:
		begin
			load_4_A = 0;
			state_next = load_mult_sgfs;
		end
		load_mult_sgfs:
		begin
			load_4 = 1;
			state_next = r_sgf_selection_a;
		end
		
		//Fifth Phase
		r_sgf_selection_a: // Gives time to combinational logic to execute
		begin
			load_4 = 0;
			state_next = r_sgf_selection_b;
		end
		r_sgf_selection_b:
		begin
			state_next = r_sgf_selection_c;
		end
		r_sgf_selection_c:
		begin
			load_5 = 1;
//			selector_b = 0;
			state_next = exp_update_a;
		end
		
		//Sixth Phase
		exp_update_a:
		begin
			load_5 = 0;
			state_next = exp_update_b;
		end
		exp_update_b:
		begin
			load_6 = 1;
			state_next = exp_update_c;
		end
		exp_update_c: //Time to combinational logic
		begin
			load_6 = 0;
			state_next = exp_update_d;
		end
		exp_update_d:
		begin
			state_next = exp_update_e;
		end
		exp_update_e:
		begin
			load_7 = 1;
			state_next = second_ov_ccomp;
		end
		second_ov_ccomp:
		begin
			load_7 = 0;
			if(overflow_comp_b) begin
				selector_d = 1;
				state_next = overflow_management_a;
			end
			else
				state_next = round_state_a;
		end
		
		//SEVENTH PHASE
		round_state_a:
		begin
			load_8 = 1; //Loads the rounded significand
			selector_a = 1; //Prepares the mux of the fifth phase to reprocess the significand
			state_next = update_sgf_a;
		end
		update_sgf_a: //time to combinational logic
		begin	
			load_8 = 0;
			selector_a = 1;
			state_next = update_sgf_b;
		end
		update_sgf_b: //time to combinational logic
		begin
			selector_a = 1;
			state_next = update_sgf_c;
		end
		update_sgf_c:
		begin
			selector_a = 1;
			load_5 = 1;
			selector_b = 1;
			state_next = new_update_exp_a;
		end
		new_update_exp_a:
		begin
			load_5 = 0;
			selector_a = 0;
			selector_b = 1;
			state_next = new_update_exp_b;
		end
		new_update_exp_b:
		begin
			selector_b = 1;
			load_6 = 1;
			state_next = new_update_exp_c;
		end
		new_update_exp_c:
		begin
			selector_b = 0;
			load_6 = 0;
			state_next = new_update_exp_d;
		end
		new_update_exp_d:
		begin
			state_next = new_update_exp_e;
		end
		new_update_exp_e:
		begin
			load_7 = 1;
			state_next = f_overflow_q;
		end
		f_overflow_q:
		begin
			load_7 = 0;
			selector_c = 1;
			if(overflow_comp_b) begin
				selector_d = 1;
				state_next = overflow_management_a;
			end
			else
				state_next = final_result_a;
		end
		
		//EIGTH PHASE
		final_result_a:
		begin
			selector_c = 1;
			load_9 = 1;
			state_next = final_result_b;
		end
		final_result_b:
		begin
			selector_c = 1;
			load_9 = 0;
			state_next = final_result_c;
		end
		final_result_c:
		begin
			selector_c = 1;
			load_10 = 1;
			state_next = final_result_d;
		end
		final_result_d:
		begin
			selector_c = 0;
			load_10 = 0;
			ready = 1;
			if(rst_FSM)
				state_next = zero;
		end
		
		overflow_management_a:
		begin
			selector_d = 1;
			load_9 = 1;
			state_next = overflow_management_b;
		end
		overflow_management_b:
		begin
			selector_d = 1;
			load_9 = 0;
			load_10 = 1;
			state_next = final_result_d;
		end
		underflow_management_a:
		begin
			load_9 = 1;
			state_next = underflow_management_b;
		end
		underflow_management_b:
		begin
			load_9 = 0;
			load_10 = 1;
			state_next = final_result_d;
		end
		
			
		endcase
	end
			
		
endmodule
