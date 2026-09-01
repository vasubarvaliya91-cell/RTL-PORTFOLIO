module uart_tx_tb;
reg clk,
    rst_n,
    tx_start;
reg [7:0]tx_data;
wire tx,done;

uart_tx #(.CLKS_PER_BIT(16)) uut(.clk(clk),
                                 .rst_n(rst_n),
                                 .tx_start(tx_start),
                                 .tx_data(tx_data),
                                 .tx(tx),
                                 .done(done));

initial clk = 0;
always #10 clk = ~clk;

initial begin


    $dumpfile("sim/dump.vcd");   
    $dumpvars(0, uart_tx_tb);        

    rst_n    = 0;
    tx_start = 0;
    tx_data  = 8'd0; 


    repeat(5) @(posedge clk);
    rst_n = 1;
 

    repeat(2) @(posedge clk);
    tx_data = 8'hA5;
    tx_start = 1'b1;
    @(posedge clk);
    tx_start = 0;
    @(posedge done);
    $display("DONE");

    repeat(5) @(posedge clk);
    $finish;
end
endmodule   