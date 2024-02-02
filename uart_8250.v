module uart_8250 (input CLK_I,             /* 时钟 */
                  input RST_I,             /* 复位 */
                  input [31:0] ADR_I,      /* 地址 */
                  input [31:0] DAT_I,      /* 数据输入 */
                  output reg [31:0] DAT_O, /* 数据输出 */
                  input WE_I,              /* 写使能 */
                  input [3:0] SEL_I,       /* 字节选择信号 */
                  input STB_I,             /* 选通信号 */
                  output reg ACK_O,        /* 操作成功结束 */
                  input CYC_I,             /* 总线周期信号 */
                  output reg INT_O,
                  output reg TX_O);       /* 中断信号 */
    
    parameter base_addr = 32'h1250_0000;
    parameter FIFO_SIZE = 8'd32;
    wire valid_addr     = ADR_I[31:4] == base_addr[31:4];
    wire [3:0] offset   = ADR_I[3:0];
    
    
    reg [7:0] RHR; /* Receive FIFO output */
    reg [7:0] IER; /* Interrupt Enable Register */
    reg [7:0] IIR; /* Interrupt ID Register */
    reg [7:0] FCR; /* FIFO Control Register */
    reg [7:0] LCR; /* Line Control Register */
    reg [7:0] MCR; /* Modem Control Register */
    reg [7:0] LSR; /* Line Status Register */
    reg [7:0] MSR; /* Modem Status Register */
    
    reg [7:0] tx_fifo [0:FIFO_SIZE - 1];
    reg [7:0] tx_shifting;
    reg [7:0] tx_fifo_head;
    reg [7:0] tx_fifo_tail;
    reg tx_completed_flag;
    reg tx_shift_ready_flag;
    reg [3:0] tx_shift_cnt;

    reg [7:0] rx_fifo [0:FIFO_SIZE - 1];
    reg [7:0] rx_fifo_head;
    reg [7:0] rx_fifo_tail;
    
    reg [15:0] clock_divisor; /* 0时2分频，1时2分频，2时4分频，3时6分频 */
    
    reg [15:0] clock_div_cnt;
    
    reg divided_clk;
    
    always @(posedge CLK_I or negedge RST_I) begin
        if (!RST_I) begin
            RHR <= 8'b0;
            IER <= 8'h0;
            IIR <= 8'hc1;
            FCR <= 8'b1100_0000;
            LCR <= 8'b0000_0011;
            MCR <= 8'b0;
            LSR <= 8'b0; /* 不应该放在这里 */
            MSR <= 8'b0; /* 不应该放在这里 */
            
            tx_fifo_head <= 0;
            tx_fifo_tail <= 0;

            tx_shift_ready_flag <= 0;

            rx_fifo_head <= 0;
            rx_fifo_tail <= 0;
            
            clock_divisor <= 0;
            clock_div_cnt <= 0;
            divided_clk   <= 0;
            
            DAT_O <= 32'bz;
            ACK_O <= 1'bz;
            INT_O <= 1'b0;
        end
        else begin
            if (STB_I && CYC_I) begin
                case (offset)
                    4'h0: begin
                        if (WE_I) begin
                            if (LCR[7]) begin
                                /* LSB of clock_divisor */
                                clock_divisor[7:0] <= DAT_I[7:0];
                            end
                            else begin
                                /* TODO: 添加进fifo */
                                if(tx_fifo_tail == FIFO_SIZE - 1) begin
                                    /* FIFO已经满了 */
                                    tx_fifo_head <= 0;
                                    tx_fifo_tail <= 1;
                                    tx_fifo[0] <= DAT_I[7:0];
                                end
                                else begin
                                    tx_fifo[tx_fifo_tail] <= DAT_I[7:0];
                                    tx_fifo_tail <= tx_fifo_tail + 1;
                                end
                            end
                            DAT_O <= 32'bz;
                        end
                        else begin
                            DAT_O <= {24'b0, RHR};
                        end
                        ACK_O <= 1'b1;
                        INT_O <= 1'b0;
                    end
                    4'h1: begin
                        if (WE_I) begin
                            if (LCR[7]) begin
                                /* MSB of clock_divisor */
                                clock_divisor[15:8] <= DAT_I[7:0];
                            end
                            else begin
                                IER <= DAT_I[7:0];
                            end
                            DAT_O <= 32'bz;
                        end
                        else begin
                            DAT_O <= {24'b0, IER};
                        end
                        ACK_O <= 1'b1;
                        INT_O <= 1'b0;
                    end
                    4'h2: begin
                        /* Write: FIFO Control */
                        /* Read: Get Interrupt Information */
                        if (WE_I) begin
                            FCR   <= DAT_I[7:0];
                            DAT_O <= 32'bz;
                        end
                        else begin
                            DAT_O <= {24'b0, IIR};
                        end
                        ACK_O <= 1'b1;
                        INT_O <= 1'b0;
                    end
                    4'h3: begin
                        /* Line Control Register */
                        if (WE_I) begin
                            LCR   <= DAT_I[7:0];
                            DAT_O <= 32'bz;
                        end
                        else begin
                            DAT_O <= {24'b0, LCR};
                        end
                        ACK_O <= 1'b1;
                        INT_O <= 1'b0;
                    end
                    4'h4: begin
                        /* Modem Control Write Only */
                        if (WE_I) begin
                            LCR <= DAT_I[7:0];
                        end
                        DAT_O <= 32'bz;
                        ACK_O <= 1'b1;
                        INT_O <= 1'b0;
                    end
                    4'h5: begin
                        /* Line Status Read Only */
                        if (!WE_I) begin
                            DAT_O <= {24'b0, LSR};
                        end
                        else begin
                            DAT_O <= 32'bz;
                        end
                        ACK_O <= 1'b1;
                        INT_O <= 1'b0;
                    end
                    4'h6: begin
                        /* Line Status Read Only */
                        if (!WE_I) begin
                            DAT_O <= {24'b0, MSR};
                        end
                        else begin
                            DAT_O <= 32'bz;
                        end
                        ACK_O <= 1'b1;
                        INT_O <= 1'b0;
                    end
                    default: begin
                        DAT_O <= 32'bz;
                        ACK_O <= 1'bz;
                        INT_O <= 1'b0;
                    end
                endcase
            end
            else begin
                DAT_O <= 32'bz;
                ACK_O <= 1'bz;
                INT_O <= 1'b0;
            end
            
            /* clock division */
            if (clock_div_cnt >= (clock_divisor - 1) || clock_divisor == 0) begin
                clock_div_cnt <= 0;
                divided_clk   <= ~ divided_clk;
            end
            else begin
                clock_div_cnt <= clock_div_cnt + 1;
            end

            /* FIFO Control Register */
            if(FCR[1]) begin
                rx_fifo_head <= 0;
                rx_fifo_tail <= 0;
            end
            if(FCR[2]) begin
                tx_fifo_head <= 0;
                tx_fifo_tail <= 0;
            end

            /* 只要没到头，就往里边搬东西 */
            if(tx_fifo_head < tx_fifo_tail ||
                (tx_fifo_tail == tx_fifo_head && tx_fifo_head > 0)) begin
                /* fifo非空 */
                LSR[5] <= 0;
                if(tx_completed_flag && !tx_shift_ready_flag) begin
                    tx_shifting <= tx_fifo[tx_fifo_head];
                    tx_fifo_head <= tx_fifo_head + 1;
                    tx_shift_ready_flag <= 1;
                end
                if(!tx_completed_flag) begin
                    tx_shift_ready_flag <= 0;
                end
            end
            else begin
                LSR[5] <= 1;
                tx_shift_ready_flag <= 0;
                if (tx_fifo_tail > 0 && tx_fifo_head > 0) begin
                    tx_fifo_head <= 0;
                    tx_fifo_tail <= 0;
                end
            end

            
            
        end
    end

    always @(posedge divided_clk or negedge RST_I) begin
        if(!RST_I) begin
            tx_completed_flag <= 1;
            tx_shift_cnt <= 0;
            TX_O <= 1;
        end
        else begin
            if(tx_shift_ready_flag) begin
                tx_completed_flag <= 0;
                tx_shift_cnt <= 8;
                TX_O <= 0;
            end
            else begin
                if(!tx_completed_flag) begin
                    if(tx_shift_cnt > 0) begin
                        TX_O <= tx_shifting[0];
                        tx_shifting <= {1'b0, tx_shifting[7:1]};
                    end
                    else begin
                        TX_O <= 1;
                        tx_completed_flag <= 1;
                    end
                    tx_shift_cnt <= tx_shift_cnt - 1;
                end
                else begin
                    TX_O <= 1;
                end
            end
        end
    end
    
endmodule
