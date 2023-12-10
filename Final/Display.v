`timescale 1ns / 1ps


module Display(
    input Clk,//clock input,100MHz,P17
    input En,//enable input if==0,no display;
    input [3:0] Digital1,//the 1st from left LED digital diplay  input, the value can be from 0000-1111B
    input [3:0] Digital2,//the 2rd from left LED digital disple, so as the followings
    input [3:0] Digital3,
    input [3:0] Digital4,
    input [3:0] Digital5,
    input [3:0] Digital6,
    input [3:0] Digital7,
    input [3:0] Digital8,
    output[7:0] DigitSel,
    output [6:0] A_2_GRight4,//the right 4  senven segment display value, A_2_G[6] is refer to G segment,
    output [6:0] A_2_GLeft4//the left 4 seven sement display value;
    );
    wire DisplayClk;
    wire [1:0] Counter2bit;
    wire [3:0] dinLeft4,dinRight4;
    
    
  DisplayClock U1(.Clk(Clk),
                  .DisplayClk(DisplayClk));
                  
  BinaryCounter2Bit U2(.Clk(DisplayClk),
                    .Counter(Counter2bit));
               
  SevenSegmentDisplayDecoder U3(.din(dinLeft4),
                                .A_2_G(A_2_GLeft4));
  SevenSegmentDisplayDecoder U4(.din(dinRight4),
                                .A_2_G(A_2_GRight4));                     
 
 DatalSelect U5(.din({Digital8,Digital7,Digital6,Digital5}), 
                .sel(Counter2bit),
                .dout(dinLeft4));
 
  DatalSelect U6(.din({Digital4,Digital3,Digital2,Digital1}), 
                .sel(Counter2bit),
                .dout(dinRight4));
                
 DigitsSelect U7(.sel(Counter2bit),
              .Enable(En),
               .DigitsSel(DigitSel[7:4]));                  
                
 DigitsSelect U8(.sel(Counter2bit),
              .Enable(En),
               .DigitsSel(DigitSel[3:0]));                 
 endmodule

module DisplayClock(
    input Clk,
    output DisplayClk
    );
    reg [17:0] d;
    always @(posedge Clk)
    begin
    d<=d+1;
    end
    assign DisplayClk=d[17];
endmodule

module BinaryCounter2Bit(
     input Clk,
     output reg [1:0] Counter
     );
      
     always @(posedge Clk)
     begin
     Counter<=Counter+1;
     end
 endmodule
 
 module SevenSegmentDisplayDecoder(
        input [3:0]din,
        output reg [6:0]A_2_G
        );
      always @(*)
      begin
      case(din)
      4'h0:A_2_G<=7'h3F;              
      4'h1:A_2_G<=7'h06;
      4'h2:A_2_G<=7'h5B;
      4'h3:A_2_G<=7'h4F;
      4'h4:A_2_G<=7'h66;
      4'h5:A_2_G<=7'h6D;
      4'h6:A_2_G<=7'h7D;
      4'h7:A_2_G<=7'h07;
      4'h8:A_2_G<=7'h7F;
      4'h9:A_2_G<=7'h6F;
      4'hA:A_2_G<=7'h77;
      4'hB:A_2_G<=7'h5E;//7C;
      4'hC:A_2_G<=7'h40;//39;
      4'hD:A_2_G<=7'h73;//5E;
      4'hE:A_2_G<=7'h79;
      4'hF:A_2_G<=7'h71;
      default:
      A_2_G<=7'h00;
      endcase
      end
 endmodule
 
 module DatalSelect(
        input [15:0]din,
        input [1:0]sel,
        output reg [3:0]dout
        );
       always @(*)
       begin
        case(sel)
        2'b00:dout=din[3:0];
        2'b01:dout=din[7:4];
        2'b10:dout=din[11:8];
        2'b11:dout=din[15:12];
        default:
        dout=0;
        endcase
       end        
  endmodule
 
 module  DigitsSelect(
         input [1:0]sel,
         input Enable,
         output reg [3:0]DigitsSel
         );      
    
        always @(*)
        begin
        if(Enable)
        begin
            case(sel)
             2'b00:DigitsSel=4'b0001;
             2'b01:DigitsSel=4'b0010;
             2'b10:DigitsSel=4'b0100;
             2'b11:DigitsSel=4'b1000;
             default
             DigitsSel=4'b0000;
             endcase
        end
        else
        DigitsSel=4'b0000;
        end
  endmodule