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
        /* address validation */
        ADR_O <= 32'h1250_0000;
        #1 ADR_O <= 32'h1250_0001;
        #1 ADR_O <= 32'h1250_0002;
        #1 ADR_O <= 32'h1250_0003;
        #1 ADR_O <= 32'h1250_0010;
        #1 ADR_O <= 32'h1250_00a0;
        #1 ADR_O <= 32'h1256_0002;
        #1 ADR_O <= 32'h0250_0000;
        #1 ADR_O <= 32'hf250_0005;

        
        
        #1 $finish;
    end
    
endmodule
