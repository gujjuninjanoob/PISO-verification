//
//      +--------------------+
//         |RST_N        |
//         |DCLK DUT     |
//         |DVALID       |
//     ===>|DI[7:0]   TXD|===>
//         |CTRL_*       |
//      +--------------------+



module parallel_to_serial_converter (
//   RST_N - input aynchronous reset.    
input wire RST_N,
//DCLK - input clock for parallel data. It is run at the fastest
 possible frequency to achieve serial transmission without idle.
    input wire DCLK,
// DVALID - input bit indicate DI[7:0] is valid (DCLK domain).
    input wire DVALID,
// DI[7:0] - input 8-bit parallel data (DCLK domain).
    input wire [7:0] DI,
//CTRL_PARITY_EN - static input to enable/disable odd parity for serial transmission.
    input wire CTRL_PARITY_EN,
//CTRL_BAUD_RATE[1:0] - static input baud rate configuration:
                               2'b00 - 9600 bps
                               2'b01 - 19200 bps
                               2'b10 - 38400 bps
                               2'b11 - 115200 bps
    input wire [1:0] CTRL_BAUD_RATE,
//TXD - serial output at configured baud rate.    
output reg TXD
);

    //  FSM States for PISO
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        PARITY,
        STOP
    } state_t;
    
  //instance for the FSM state/
    state_t state, next_state;

    // Internal registers
    reg [7:0] data_reg;
    reg [2:0] bit_cnt;
    reg parity_bit;

    // Baud rate divider
    reg [12:0] baud_cnt; // Enough bits for slowest rate (9600 bps)
    reg baud_tick;

    wire [12:0] baud_div;

    // Baud rate divisor based on CTRL_BAUD_RATE
    assign baud_div = (CTRL_BAUD_RATE == 2'b00) ? 13'd5208 : // 9600 bps
                      (CTRL_BAUD_RATE == 2'b01) ? 13'd2604 : // 19200 bps
                      (CTRL_BAUD_RATE == 2'b10) ? 13'd1302 : // 38400 bps
                                                   13'd434; // 115200 bps

    // Baud tick generator
    always @(posedge DCLK or negedge RST_N) begin
        if (!RST_N) begin
            baud_cnt <= 0;
            baud_tick <= 0;
        end else begin
            if (baud_cnt >= baud_div) begin
                baud_cnt <= 0;
                baud_tick <= 1;
            end else begin
                baud_cnt <= baud_cnt + 1;
                baud_tick <= 0;
            end
        end
    end

    // FSM State transitions
    always @(posedge DCLK or negedge RST_N) begin
        if (!RST_N)
            state <= IDLE;
        else if (baud_tick)
            state <= next_state;
    end

    // FSM Next State logic
    always @(*) begin
        case (state)
            IDLE: next_state = (DVALID) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_cnt == 3'd7) ? 
                                   (CTRL_PARITY_EN ? PARITY : STOP) : DATA;
            PARITY: next_state = STOP;
            STOP: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // FSM Output logic
    always @(posedge DCLK or negedge RST_N) begin
        if (!RST_N) begin
            TXD <= 1'b1; // Idle value
            data_reg <= 8'd0;
            bit_cnt <= 3'd0;
            parity_bit <= 1'b0;
        end else if (baud_tick) begin
            case (state)
                IDLE: begin
                    TXD <= 1'b1;
                    if (DVALID) begin
                        data_reg <= DI;
                        parity_bit <= ^DI ? 1'b0 : 1'b1; // Odd parity
                        bit_cnt <= 3'd0;
                    end
                end
                START: begin
                    TXD <= 1'b0; // Start bit
                end
                DATA: begin
                    TXD <= data_reg[bit_cnt];
                    bit_cnt <= bit_cnt + 1;
                end
                PARITY: begin
                    TXD <= parity_bit;
                end
                STOP: begin
                    TXD <= 1'b1; // Stop bit
                end
                default: TXD <= 1'b1;
            endcase
        end
    end

endmodule
