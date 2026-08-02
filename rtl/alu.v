module alu(input [7:0]a, b,
           input [2:0]op,
           output reg [7:0]result, 
           output reg zero, carry, borrow
          );
always @(*)begin
  result = 8'b0;
  zero = 1'b0;
  carry = 1'b0;
  borrow = 1'b0;
  case(op)
       3'b000:begin
                  {carry,result} = a + b;
              end
       3'b001:begin
                  result = a - b;
                  borrow = (a < b) ? 1 : 0;
              end
       3'b010: result = a & b;
       3'b011: result = a | b;
       3'b100: result = a ^ b;
       3'b101: result = ~a;
       3'b110: result = a << 1;
       3'b111: result = a >> 1;
  endcase
  zero = (result == 8'b0);
end
endmodule