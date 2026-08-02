module alu_tb;
reg [7:0] a;
reg [7:0] b;
reg [2:0] op;


wire [7:0] result;
wire zero;
wire carry;
wire borrow;

alu uut (          
    .a(a),         
    .b(b),
    .op(op),
    .result(result),
    .zero(zero),
    .carry(carry),
    .borrow(borrow)
);

initial begin
    $dumpfile("sim/dump.vcd");   
    $dumpvars(0, alu_tb);        
end

initial begin

    
    a = 8'd10;
    b = 8'd5;
    op = 3'b000;    
    #10;            
    if (result == 8'd15)
        $display("PASS | ADD | 10+5 = %0d", result);
    else
        $display("FAIL | ADD | expected 15 got %0d", result);



    a = 8'd250;
    b = 8'd10;
    op = 3'b000;    
    #10;               
    if (result == 8'd4  && carry == 1'b1)
        $display("PASS | OVERFLOW carry = %0d", carry);
    else
        $display("FAIL | ADD | expected 260 got %0d", result);

       

    a = 8'd10;
    b = 8'd5;
    op = 3'b001;    
    #10;            
    if (result == 8'd5)
        $display("PASS | SUB | 10-5 = %0d", result);
    else
        $display("FAIL | SUB | expected 5 got %0d", result);



    a = 8'd5;
    b = 8'd10;
    op = 3'b001;    
    #10;            
    if (result == 8'd251 && borrow == 1'b1)
        $display("PASS | OVERFLOW | borrow = %0d", borrow);
    else
        $display("FAIL DIDNT WORK %0d", borrow);



    a = 8'd5;
    b = 8'd5;
    op = 3'b001;    
    #10;            
    if (zero == 1'd1)
        $display("PASS | ZERO = %0d", zero);
    else
        $display("FAIL | ZERO | expected 1 got %0d", zero);  


    a = 8'd10;
    b = 8'd5;
    op = 3'b010;    
    #10;            
    if (result == 8'd0)
        $display("PASS | AND OPERATION = %0d", result);
    else
        $display("FAIL | AND OPERATION expected 0 got %0d", result);


    a = 8'd10;
    b = 8'd5;
    op = 3'b011;    
    #10;            
    if (result == 8'd15)
        $display("PASS | OR OPERATION = %0d", result);
    else
        $display("FAIL | OR OPERATION expected 15 got %0d", result);


    a = 8'd10;
    b = 8'd5;
    op = 3'b100;    
    #10;            
    if (result == 8'd15)
        $display("PASS | XOR OPERATION = %0d", result);
    else
        $display("FAIL | XOR OPERATION expected 15 got %0d", result);


    a = 8'd10;
    op = 3'b101;    
    #10;            
    if (result == 8 'd245)
        $display("PASS | NOT OPERATION = %0d", result);
    else
        $display("FAIL | NOT OPERATION expected 245 got %0d", result);

    a = 8'd10;
    op = 3'b110;    
    #10;            
    if (result == 8'd20)
        $display("PASS | LEFT SHIFT OPERATION = %0d", result);
    else
        $display("FAIL | LEFT SHIFT OPERATION expected 20 got %0d", result);


    a = 8'd10;
    op = 3'b111;    
    #10;            
    if (result == 8'd5)
        $display("PASS | RIGHT SHIFT OPERATION = %0d", result);
    else
        $display("FAIL | RIGHT SHIFT OPERATION expected 5 got %0d", result);
    $finish;
end
endmodule