`timescale 1ns/1ps
module uart_8250_tst();
    
    reg [3:0] A;
    reg [3:0] B;
    reg CI;
    wire [3:0] SUM;
    wire [4:0] Carry;
    
    integer tst_cnt_1;
    integer tst_cnt_2;
    
    uart_8250 fadd0(A[0],
    B[0],
    CI,
    SUM[0],
    Carry[1]);
    
    uart_8250 fadd2(A[1],
    B[1],
    Carry[1],
    SUM[1],
    Carry[2]);
    
    uart_8250 fadd3(A[2],
    B[2],
    Carry[2],
    SUM[2],
    Carry[3]);
    
    uart_8250 fadd4(A[3],
    B[3],
    Carry[3],
    SUM[3],
    Carry[4]);
    
    /*iverilog */
    initial
    begin
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, uart_8250_tst);     //tb模块名称
    end
    /*iverilog */
    
    initial
    begin
        CI = 0;
        for(tst_cnt_1 = 0;tst_cnt_1<16;tst_cnt_1 = tst_cnt_1 +1)
        begin
            for(tst_cnt_2 = 0;tst_cnt_2<16;tst_cnt_2 = tst_cnt_2 +1)
            begin
                #1 A = tst_cnt_1;
                B    = tst_cnt_2;
            end
        end
        
        #1 $finish;
    end
    
endmodule
