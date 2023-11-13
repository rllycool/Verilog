module Timer43(
input wire clk, s_reset,
output reg Rollover
);

integer count;
initial begin
   count = 0;
   Rollover = 1'b0;
end

always @ (posedge clk) begin
   Rollover = 1'b0;
   //833333
	//434
   if (count == 217) begin
      Rollover = 1'b1;
      count = 0;
   end


   if (s_reset) begin
      Rollover = 1'b0;
      count = 0;
   end

   count = count + 1;
end
endmodule
