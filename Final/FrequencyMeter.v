`timescale 1ns / 1ps

module FrequencyMeter(
    input Clk,
    input Fxin,
    output reg [15:0]Frequency    
    );
     reg [15:0] cnt;
     wire signalB;
    
        always@(posedge Fxin)  
         begin  

             if(!signalB)             
                 cnt = 0 ; 
             else  
                 cnt = cnt + 1 ;   
         end
         always@(negedge signalB)
            begin
               Frequency = cnt ; 
            end       
           
    clk_div(.Clk(Clk),.signalB(signalB));
endmodule



module clk_div(   //分频模块
    input Clk,    //系统时钟，100 MHz 
    output reg signalB
    );
    reg [31:0] clk_cnt;
    always@(posedge Clk) //100MHz时钟频率下的每一上升沿  
         begin  
                if(clk_cnt == 99999999)
                    begin
                        signalB=~signalB;
                        clk_cnt=0;
                    end
                else
                    clk_cnt = clk_cnt + 1 ;
         end  
endmodule
