`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2022 14:32:38
// Design Name: 
// Module Name: VGA_timings
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_timings#(
    parameter WIDTH = 640,
    parameter H_FP = 16,
    parameter H_PW = 96,
    parameter H_BP = 48,
    parameter N_W = $clog2(WIDTH + H_FP + H_PW + H_BP),
    parameter HEIGHT = 480,
    parameter V_FP = 10,
    parameter V_PW = 2,
    parameter V_BP = 33,
    parameter N_H = $clog2(HEIGHT + V_FP + V_PW + V_BP)
    )
    (
    input wire iClk, iRst,
    output wire oHS, oVS,
    output wire [N_W-1:0] oCountH,
    output wire [N_H-1:0] oCountV
    );   
    wire r_oHS;
    wire r_oVS;
    wire r_vEnCurrent;
    wire r_vsync;
    wire r_hsync;
    wire w_vEn;
    localparam totalWIDTH = WIDTH + H_FP + H_PW + H_BP;
    localparam totalHEIGHT = HEIGHT + V_FP + V_PW + V_BP;
    //horizontal counter    
    counter #( .LIM(totalWIDTH) )
    counter_horizontal (.iClk(iClk), .iRst(iRst), .iEn(1), .oQ(oCountH)); 
    //vertical counter - count up when horizontal counter is 1 
    counter #( .LIM(totalHEIGHT) )
    counter_vertical (.iClk(iClk), .iRst(iRst), .iEn(w_vEn), .oQ(oCountV));
  /*  always @(posedge iClk)
    begin
        r_vEnCurrent <= (oCountH+2 == totalWIDTH);
        r_vsync <= ((oCountH+1 >= (WIDTH + H_FP)) & (oCountH+1 < (WIDTH + H_FP + H_PW)));
        r_hsync <= ((oCountV >= (HEIGHT + V_FP)) & (oCountV < (HEIGHT + V_FP + V_PW)));
    end */
    
    assign r_vEnCurrent = (oCountH+2 == totalWIDTH);
    assign r_hsync = ((oCountH+1 >= (WIDTH + H_FP)) & (oCountH+1 < (WIDTH + H_FP + H_PW)));
    assign r_vsync = ((oCountV >= (HEIGHT + V_FP)) & (oCountV < (HEIGHT + V_FP + V_PW)));
    assign w_vEn = r_vEnCurrent;
    assign oVS = ~r_vsync;
    assign oHS = ~r_hsync;
endmodule
