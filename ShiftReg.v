`timescale 1ns/1ps

module ShiftReg(

input wire enable,
input wire clk,
input wire [7:0] ascii,
output reg [7:0] out

);
parameter N = 10;
reg [9:0] shift;

always @ (posedge clk) begin
	
	if(enable) begin
		shift[N-1:1] <= shift[N-2:0]; 
		shift[0] <= 0;
	end
	else begin
		shift <= {1'b1, ascii, 1'b0};
	end
	out <= shift[8:1];
end
endmodule