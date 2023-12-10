`timescale 1ns / 1ps


module SignalGenerator(
    input Clk,
    input [2:0] ControlFrequency,
    input [2:0] ControlPeriodic,
    input [1:0] ControlDuty,
    output SignalOutFrequency,
    output SignalOutPeridic,
    output SignalOutDuty
    );
    
    reg [17:0]dF;
    reg [18:0]dP;
    reg [17:0]dD;
    reg duty;
    //Generate the Fxin signal;
    always @(posedge Clk)
    begin
    if(dF[17])
    dF<=0;
    else
    dF<=dF+ControlFrequency;
    end
    assign SignalOutFrequency=dF[16];
    //Generate the Pxin signal;
    always @(posedge Clk)
    begin
    if(dP[18])
    dP<=0;
    else
    dP<=dP+ControlPeriodic;
    end
    assign SignalOutPeridic=dP[17];
  
  //Generate the Dxin signal;
    always @(posedge Clk)
    begin
    if(dD[17])
    dD<=0;
    else 
    begin
    dD<=1+dD;
       if(dD<{ControlDuty,14'b10_0000_0000_0000})
        duty<=1;
        else
        duty<=0;
       end
     end
    assign SignalOutDuty=duty;
   
   
endmodule
