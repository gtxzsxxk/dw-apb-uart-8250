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
        RST_O    = 0;
        CYC_O    = 0;
        #1 RST_O = 1;
        /* address validation */
        // ADR_O    = 32'h1250_0000;
        // #1 ADR_O = 32'h1250_0001;
        // #1 ADR_O = 32'h1250_0002;
        // #1 ADR_O = 32'h1250_0003;
        // #1 ADR_O = 32'h1250_0010;
        // #1 ADR_O = 32'h1250_00a0;
        // #1 ADR_O = 32'h1256_0002;
        // #1 ADR_O = 32'h0250_0000;
        // #1 ADR_O = 32'hf250_0005;
        
        /* register read and write */
        // ADR_O    = 32'h1250_0001;
        // DAT_O    = 32'b0001_1101;
        // WE_O     = 1;
        // STB_O    = 1;
        // CYC_O    = 1;
        // #1 CLK_O = 1;
        // #1 CLK_O = 0;
        
        // #1 ADR_O = 32'h1250_0002;
        // DAT_O    = 32'b1001_0001;
        // WE_O     = 1;
        // STB_O    = 1;
        // CYC_O    = 1;
        // #1 CLK_O = 1;
        // #1 CLK_O = 0;
        
        // #1 ADR_O = 32'h1250_0002;
        
        // WE_O     = 0;
        // STB_O    = 1;
        // CYC_O    = 1;
        // #1 CLK_O = 1;
        // #1 CLK_O = 0;
        
        // #1 ADR_O = 32'h1250_0003;
        // DAT_O    = 32'b1010_1101;
        // WE_O     = 1;
        // STB_O    = 1;
        // CYC_O    = 1;
        // #1 CLK_O = 1;
        // #1 CLK_O = 0;
        
        // #1 ADR_O = 32'h1250_0003;
        
        // WE_O     = 0;
        // STB_O    = 1;
        // CYC_O    = 1;
        // #1 CLK_O = 1;
        // #1 CLK_O = 0;
        
        /* Test of writing divisor latch */

        /* 此时应该为2分频 */
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        
        #1 ADR_O = 32'h1250_0003;
        DAT_O    = 32'b1000_0000;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        #1 ADR_O = 32'h1250_0000;
        DAT_O    = 32'b0000_0001;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        
        #1 ADR_O = 32'h1250_0001;
        DAT_O    = 32'b0000_0000;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        /* 2分频 */
        
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        
        #1 ADR_O = 32'h1250_0000;
        DAT_O    = 32'b0000_0010;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        
        #1 ADR_O = 32'h1250_0001;
        DAT_O    = 32'b0010_0000;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        
        #1 ADR_O = 32'h1250_0001;
        DAT_O    = 32'b0000_0000;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        /* 4分频 */
        
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        
        #1 ADR_O = 32'h1250_0000;
        DAT_O    = 32'b0000_0011;
        WE_O     = 1;
        STB_O    = 1;
        CYC_O    = 1;
        #1 CLK_O = 1;
        #1 CLK_O = 0;

        /* 6分频 */
        
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        #1 CLK_O = 1;
        #1 CLK_O = 0;
        
        #1 $finish;
    end
    
endmodule
