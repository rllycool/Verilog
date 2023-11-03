//Ethan Tillotson
//ECE4623

module UART(
input CLOCK_50,
input [1:0]KEY,
input [9:0] SW,
output [39:0] GPIO,
output wire [9:0] LEDR
);

reg enable;
reg load;
wire rollover86;
wire rollover43;
wire rollover10;

reg check;
reg [3:0] numer;
reg [3:0] pulse;
wire [9:0] display1;

reg [2:0] state, next_state;

Timer868 timer868( .clk(CLOCK_50), .Rollover(rollover86));
Timer43 timer43( .clk(CLOCK_50), .Rollover(rollover43));
Timer10 timer10( .clk(CLOCK_50), .Rollover(rollover10));
ShiftReg shiftyboy ( .clk(CLOCK_50), .load(load), .enable(enable), .out(GPIO[1]), .lights(display1), .ascii(SW[7:0]));


always @(posedge rollover86) begin
	state <= next_state;
end



always @(posedge rollover43)begin
	enable <= !enable;
end

//State transition logic
always @(*) begin

	case(state)
		3'd0: next_state <= (KEY[1] == 1'b1) ? 3'h1 : 3'h0;
		3'd1: next_state <= 3'h2;
		3'd2: next_state <= (pulse >= 4'b1010 && KEY[1] == 1'b0) ? 3'h0 : 3'h2;
	endcase
end

always @(posedge rollover10) begin
	if(state == 3'h0) begin
		load <= 1'b1;
		
	end
	if(state == 3'h1) begin
		load <= 1'b0;
	end
	if (state == 3'h2) begin
		//enable <= 1'b0;
		load <= 1'b0;
	
	end
end


assign LEDR = display1;

always @(posedge rollover86) begin

	if(pulse >= 4'b1010) begin
		pulse <= pulse + 1'b1; //
		//
		pulse <= 4'b0000;
		
		
	end
	else begin
	pulse <= pulse + 1'b1;

	end
end


endmodule