module StateMachine(
	input CLOCK_50,
	input wire [9:0] SW,
	output reg [9:0] LEDR
);


wire s_reset = SW[0];
wire trigger = SW[9];
wire enable;


Timer_1s timer1 (.Rollover(enable), .s_reset(s_reset), .clk(CLOCK_50));

reg [2:0] state, next_state;
reg [3:0] Pulse_Count;
reg [3:0] Set_Count;

//This module implements the state register and handles reset and enable.
always @(posedge CLOCK_50) begin
	case ({s_reset,enable})
		2'b10, 2'b11: state <= 2'h0;
		2'b00: state <= state;
		2'b01: state <= next_state;
	endcase
end

//State transition logic
always @(*) begin
	case(state)
		3'd0: next_state <= (trigger) ? 3'h1 : 3'h0;
		3'd1: next_state <= 3'h2;
		3'd2: next_state <= (Pulse_Count < SW[4:2] + 1) ? 3'h1 : 3'h3;
		3'd3: next_state <= 3'h4;
		3'd4: next_state <= (Set_Count < SW[7:5] + 1) ? 3'h1 : 3'h0;
		default: next_state <= 3'h1;
	endcase
end

//outputs
always @(posedge enable) begin
	
	
	if(state == 3'h0) begin
		Pulse_Count <= 0;
		Set_Count <= 0;
		LEDR[0] <= 0;

		
	end
	if (state == 3'h1) begin
		LEDR[0] <=1;
		Pulse_Count<= Pulse_Count + 1;
		
	end
	if(state == 3'h2) begin
		LEDR[0] <= 0;
		
	end
	if(state == 3'h3) begin
		LEDR[0] <= 0;
		Pulse_Count <= 0;
		Set_Count <= Set_Count + 1;
		
	end
	if(state == 3'h4) begin
		LEDR[0] <= 0;
		
	end
end

//assign enable = 1'b1;//Comment this out to test on board. 
//Uncomment this section to slow down the clock for testing on the board.


endmodule
