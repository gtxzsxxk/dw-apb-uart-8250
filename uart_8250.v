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
                  output reg INT_O);       /* 中断信号 */

    parameter base_addr = 32'h1250_0000;
    parameter FIFO_SIZE = 8'd32;
    wire valid_addr = ADR_I[31:4] == base_addr[31:4];
    wire [3:0] offset = ADR_I[3:0];

    
    reg [7:0] RHR; /* Receive FIFO output */
    reg [7:0] THR; /* Transmit FIFO input */
    reg [7:0] IER; /* Interrupt Enable Register */
    reg [7:0] IIR; /* Interrupt ID Register */
    reg [7:0] FCR; /* FIFO Control Register */
    reg [7:0] LCR; /* Line Control Register */
    reg [7:0] MCR; /* Modem Control Register */
    reg [7:0] LSR; /* Line Status Register */
    reg [7:0] MSR; /* Modem Status Register */

    reg [7:0] tx_fifo [FIFO_SIZE];
    reg [7:0] rx_fifo [FIFO_SIZE];
    
    always @(posedge CYC_I or negedge RST_I) begin
        if (!RST_I) begin
            
        end
        else begin
            case (offset)
                4'h0: begin
                    if(WE_I) begin
                        THR <= DAT_I[7:0];
                        DAT_O <= 32'bz;
                    end
                    else begin
                        DAT_O <= {24'b0, RHR};
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
    end
    
endmodule
