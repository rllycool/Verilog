//Ethan Tillotson
//ECE4623

module UART(
input CLOCK_50,
input [1:0]KEY,
input [9:0] SW,
inout [39:0] GPIO,
output wire [9:0] LEDR
);

wire enable;
reg r;


wire SampleEnable;
wire Samp;
wire RShift;
reg [3:0] n;
reg [1:0] count;
wire rollover86;
wire rollover43;
wire rollover10;

wire load;
reg check;
reg SendTen;
reg gpiocheck;
reg [3:0] numer;
reg [3:0] pulse;
wire [9:0] display1;
//ECE4623
wire stub;
reg [2:0] state, next_state;

Timer868 timer868( .clk(CLOCK_50), .Rollover(rollover86), .s_reset(r));
Timer43 timer43( .clk(CLOCK_50), .Rollover(rollover43), .s_reset(enable)); //what is s_reset????
Timer10 timer10( .clk(CLOCK_50), .Rollover(rollover10));
ShiftReg shiftyboy ( .clk(CLOCK_50), .enable(RShift), .out(LEDR[7:0]), .ascii(GPIO[0]), .load(load)); //ascii gpio[0]
RisingEdgeDetector rizz ( .clk(CLOCK_50), .signal(r), .edging(RShift));
RisingEdgeDetector SampleEn (.clk(CLOCK_50), .signal(rollover86), .edging(SampleEnable));

RisingEdgeDetector SampleEn2 ( .clk(CLOCK_50), .signal(GPIO[0]), .edging(load));
RisingEdgeDetector StateEn ( .clk(CLOCK_50), .signal(GPIO[0]), .edging(enable));

always @(posedge CLOCK_50) begin
	state <= next_state;
end

//State transition logic
always @(*) begin
	case(state)
		3'd0: next_state <= (enable) ? 3'h1 : 3'h0;
		3'd1: next_state <= (n >= 4'b1001) ? 3'h0 : 3'h2;
		3'd2: next_state <= (SampleEnable) ? 3'h1 : 3'h2;
	endcase
end



always @(posedge CLOCK_50) begin

	if(state == 3'h0) begin
		n <= 1'b0;
		count <= 1'b0;
		r <= 1'b0;
		//load <= 1'b1;
		
	end
	if(state == 3'h1) begin
		r <= 1'b1;
		n <= n + 1'b1;
		count <= 1'b0;
	//	load <= 1'b0;
		
	end
	if (state == 3'h2) begin
		r <= 1'b0;
		count <= count + 1'b1;
	//	load <= 1'b0;
		
	end
end

assign GPIO[1] = RShift;

endmodule