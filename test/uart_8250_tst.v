`timescale 1ns/1ps
module uart_8250_tst();
    
    reg CLK_O;
    reg RST_O;
    reg [31:0] ADR_O;
    reg [31:0] DAT_O;
    wire [31:0] DAT_I;
    reg WE_O;
    reg [3:0] SEL_O;
    reg STB_O;
    wire ACK_I;
    reg CYC_O;
    wire INT_I;
    
    uart_8250 u(
    CLK_O,
    RST_O,
    ADR_O,
    DAT_O,
    DAT_I,
    WE_O,
    SEL_O,
    STB_O,
    ACK_I,
    CYC_O,
    INT_I
    );
    
    /* iverilog */
    initial
    begin
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, uart_8250_tst);     //tb模块名称
    end
    /* iverilog */
    
    initial
    begin
        RST_O    = 1;
        #1 RST_O = 0;
        CYC_O    = 0;
        #1 RST_O = 1;

        /* 换波特率 */

        #1 ADR_O = 32'h1250_0003;
        DAT_O    = 32'h80;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        #1 ADR_O = 32'h1250_0000;
        DAT_O    = 32'h03;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        #1 ADR_O = 32'h1250_0003;
        DAT_O    = 32'h00;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #5 CLK_O = 0;
        
        /* 测试数据发送 */

        ADR_O = 32'h1250_0000;
        DAT_O    = 32'h12;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        ADR_O = 32'h1250_0000;
        DAT_O    = 32'h34;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        ADR_O = 32'h1250_0000;
        DAT_O    = 32'h56;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        STB_O    = 0;
        CYC_O    = 0;
    end

    always 
    begin
        #1 CLK_O = 1;
        #1 CLK_O = 0;
    end
    
endmodule
