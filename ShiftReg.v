`timescale 1ns/1ps

module ShiftReg(

input wire load,
input wire enable,
input wire clk,
input wire ascii,
output reg [7:0] out

);

reg [9:0] shift = 10'b0000000000;
//assign lights = shift;
//assign out = in >> N;
always @ (posedge clk) begin
	
	if(enable) begin
		
		shift[9:0] <= {ascii, shift[9:1]};
		//shift[9:0] <= {shift[8:0], ascii};
		//shift <= shift >> 1'b1;
	end
	
	out <= shift[8:1];
end
endmodule