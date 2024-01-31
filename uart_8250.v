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
    
    always @(posedge CYC_I or negedge RST_I) begin
        if (!RST_I) begin
            
        end
        else begin
            
        end
    end
    
endmodule
