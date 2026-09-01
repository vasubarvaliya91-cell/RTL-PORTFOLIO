module uart_rx_tb;
reg clk,
    rst_n,
    tx;
wire [7:0]tx_data;
wire done;

uart_rx #(.CLKS_PER_BIT(16)) uut(.clk(clk),
                                 .rst_n(rst_n),
                                 .tx_data(tx_data),
                                 .tx(tx),
                                 .done(done));

initial clk = 0;
always #10 clk = ~clk;

initial begin


    $dumpfile("sim/dump.vcd");   
    $dumpvars(0, uart_rx_tb);        

    rst_n    = 1'b0; 
    tx = 1'b1;
    repeat(5) @(posedge clk);
    rst_n = 1;
     

    repeat(2) @(posedge clk);  
    tx = 1'b0;
    repeat(16) @(posedge clk);
    tx = 1'b1;
    repeat(16) @(posedge clk);
    tx = 1'b0;
    repeat(16) @(posedge clk);
    tx = 1'b1;
    repeat(16) @(posedge clk);
    tx = 1'b0;
    repeat(16) @(posedge clk);
    tx = 1'b0;
    repeat(16) @(posedge clk);
    tx = 1'b1;
    repeat(16) @(posedge clk);
    tx = 1'b0;
    repeat(16) @(posedge clk);
    tx = 1'b1;
    repeat(16) @(posedge clk);
    tx = 1'b1;
    repeat(16) @(posedge clk);
    if(tx_data == 8'hA5)
    $display("DATA RECIVED SUCCESSFULLY");

    repeat(5) @(posedge clk);
    $finish;
end
endmodule   