module uart_tx (
    input wire clk,
    input wire rst_n,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg done
    
);

parameter IDLE  = 2'b00,
          START = 2'b01,
          DATA  = 2'b10,
          CLKS_PER_BIT = 13'd5208,
          STOP  = 2'b11;

reg [1:0] state, next_state;
reg [3:0] bit_cnt;
reg [12:0] baud_cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= next_state;  
end

always @(*) begin
    case (state)
        IDLE: begin
            if (tx_start)
                next_state = START;
            else
                next_state = IDLE;
        end
        START: begin
            if (baud_cnt == CLKS_PER_BIT -1)
                next_state = DATA;
            else
                next_state = START;
        end
        DATA: begin
            if (bit_cnt == 4'd7 && baud_cnt == CLKS_PER_BIT -1)
                next_state = STOP;
            else
                next_state = DATA;
        end
        STOP: begin
            if (baud_cnt == CLKS_PER_BIT -1)
                next_state = IDLE;
            else
                next_state = STOP;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tx <= 1'b1;
        done <= 1'b0;
        baud_cnt <= 13'd0;
        bit_cnt <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                tx <= 1'b1;
                done <= 1'b0;
                baud_cnt <= 13'd0;
                bit_cnt <= 4'd0;
            end
            START: begin
                tx <= 1'b0;
                done <= 1'b0;            
                    baud_cnt <= baud_cnt + 1;
                if(baud_cnt == CLKS_PER_BIT-1)begin
                    baud_cnt <= 0;
                end
            end
            DATA: begin
                tx <= tx_data[bit_cnt];
                done <= 1'b0;
                    baud_cnt <= baud_cnt + 1;
                if(baud_cnt == CLKS_PER_BIT-1)begin
                    baud_cnt <= 0;
                    bit_cnt <= bit_cnt + 1;
                end
            end
            STOP: begin
                tx <= 1'd1;
                    baud_cnt <= baud_cnt + 1;
                if(baud_cnt == CLKS_PER_BIT-1)begin
                    baud_cnt <= 0;
                    done <= 1'b1;
                end
            end
        endcase
    end
end

endmodule