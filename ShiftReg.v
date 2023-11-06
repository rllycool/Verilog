`timescale 1ns/1ps

module ShiftReg(

input wire enable,
input wire clk,
input wire [7:0] ascii,
output reg out

);

reg [9:0] shift;

always @ (posedge enable) begin

	shift <= {1'b1, ascii, 1'b0};
	
	shift <= {1'b1, shift[9:1]}; //shift 1 to MSB
	out <= shift[8:1];

end
endmodule