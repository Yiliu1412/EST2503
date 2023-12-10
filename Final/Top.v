`timescale 1ns / 1ps



module Top(
    input Clk,//clock, use the 100MHz clock source on the board by p17 pin
    input En,//enable,if enable ==0, the display is light off;
    input Buttom,
    input [7:0]sw,
    output [6:0] A_2_GRight4, //right 4 LED display digitals segment output
    output [6:0] A_2_GLeft4,//left 4 LED display digitals segment output
    output [7:0] DigitalSel,//digitals select control signals, from left to digitals 8 to 1;
    output DpLeft,// dp for left 4 digitals
    output DpRight//dp for right 4 digitals s
    
    );
    reg [31:0]Number;    //example of a number for display ,you can modify here for your number to display.;
    wire Fxin,Pxin,Dxin;
    wire [15:0]Frequency;
    wire [15:0]Periodic;
    wire [15:0]Duty;

      
    
    assign DpLeft=DigitalSel[6];
    assign DpRight=DigitalSel[2];
    //these two sentence above is to control the dp for display, as above value of these sentences, 
    // the result is show as 1.2345.678, you can modify the subscript number of DigitlaSel for your own needs.
    
    reg buttom_state = 0; // 用于存储开关状态的寄存器
    reg last_buttom_state = 0; // 用于检测边缘的辅助寄存器
    
    always @(posedge Clk) begin
        if (Buttom && !last_buttom_state) begin
            buttom_state <= !buttom_state; // 检测到上升沿时翻转状态
        end
        last_buttom_state <= Buttom; // 更新最后的状态
    end
    
    
    always @(*) 
        begin
            if (buttom_state) begin
                Number = 32'h19198100; // 固定显示此数字
                end 
            else begin
                Number[31:28] = 15; // 显示 'F'
                Number[27:24] = 0;  // 显示 '0'
                Number[23:20] = Frequency / 1000; // 频率的千位
                Number[19:16] = (Frequency / 100) % 10; // 频率的百位
                Number[15:12] = (Frequency / 10) % 10; // 频率的十位
                Number[11:8] = Frequency % 10; // 频率的个位
                Number[7:4] = 10; // 显示 '.'
                Number[3:0] = 11; // 显示 '.'
            end
        end

        
Display myDisplay(.Clk(Clk),    
                             .En(1), 
                             .Digital1(Number[3:0]),
                             .Digital2(Number[7:4]),
                             .Digital3(Number[11:8]),
                             .Digital4(Number[15:12]),
                             .Digital5(Number[19:16]),
                             .Digital6(Number[23:20]),
                             .Digital7(Number[27:24]),
                             .Digital8(Number[31:28]),
                             .DigitSel(DigitalSel),
                             .A_2_GRight4(A_2_GRight4),
                             .A_2_GLeft4(A_2_GLeft4));

 FrequencyMeter U10(
    .Fxin(Fxin),
    .Clk(Clk),
    .Frequency(Frequency)
);
                     
 SignalGenerator U11(.Clk(Clk),
    .ControlFrequency(sw[7:5]),//these three switch is for control Frequency;
    .ControlPeriodic(sw[4:2]),//these three switch is for control Periodic;
    .ControlDuty(sw[1:0]),//these two switch is for control Duty;
    .SignalOutFrequency(Fxin),//this signal is Frequency signal output, vaild in 
    //sw[7:5],000,000Hz;
    //sw[7:5],001,0.763KHz
    //sw[7:5],010,1.526KHz
    //sw[7:0],100,3.051KHz
    .SignalOutPeridic(Pxin),//this signal is Periodic signal output, vaild in
    //sw[4:2],001,2.622ms
    //sw[4:2],010,1.310ms
    //sw[4:2],100,0.655ms
    .SignalOutDuty(Dxin));//this signal is Duty signal output,vaild in 
    //sw[1:0],00,6.25% duty
    //sw[1:0],01,18.78% duty
    //sw[1:0],10,31.27% duty
    //sw[1:0],11,43.78% duty
 
endmodule
