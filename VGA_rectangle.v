`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2022 16:43:12
// Design Name: 
// Module Name: VGA_pattern
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


module VGA_rectangle#(
    parameter WIDTH = 640,
    parameter H_FP = 16,
    parameter H_PW = 96,
    parameter H_BP = 48,
    
    parameter HEIGHT = 480,
    parameter V_FP = 10,
    parameter V_PW = 2,
    parameter V_BP = 33
    ) (
    input wire iClk, iRst,
    input wire [9:0] iCountH, iCountV,
    iShapeX, iShapeY, iShapeSize,
    input wire iHS, iVS,
    output wire oHS, oVS,
    output wire [3:0] oRed, oGreen, oBlue
    );
    wire [3:0] r_oRed, r_oGreen, r_oBlue;
    
    wire active;
    wire activeHorizontal;
    wire activeVertical;
    
    assign activeHorizontal = (iCountH <= WIDTH) ? 1:0;
    assign activeVertical = (iCountV <= HEIGHT) ? 1:0;
    assign active = activeHorizontal & activeVertical;
    
    assign inRectangleHorizontal = (iCountH >= iShapeX &
                                    iCountH < (iShapeX + iShapeSize))
                                    ? 1 : 0;
    assign inRectangleVertical = (iCountV >= iShapeY &
                                  iCountV < (iShapeY + iShapeSize))
                                  ? 1 : 0;
                                  
    assign inRectangle = inRectangleHorizontal & inRectangleVertical;
    
    assign r_oRed = (inRectangle & active) ? 4'b1111 : 4'b0000;
    assign r_oGreen = 4'b0000;
    assign r_oBlue = 4'b0000;
    
    assign oRed = r_oRed;
    assign oGreen = r_oGreen;
    assign oBlue = r_oBlue;
    assign oHS = iHS;
    assign oVS = iVS;
    
endmodule
