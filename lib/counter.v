`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2022 14:32:23
// Design Name: 
// Module Name: counter
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


module counter#(
    parameter LIM = 150,
    parameter N   = $clog2(LIM-1)
    )
    (
    input wire iClk, iRst, iEn,
    output wire [N-1:0] oQ
    );
    
//signal declaration
reg [N-1:0] r_CntCurr;
wire [N-1:0] w_CntNext;
wire w_Rst;

always @(posedge iClk)
    if (iRst == 1)
        r_CntCurr <= 0;
    else if (iEn == 1)
        if (r_CntCurr == LIM-1)
            r_CntCurr <= 0;
        else
            r_CntCurr <= w_CntNext;
            
//increment
assign w_CntNext = r_CntCurr+1;

//output
assign oQ = r_CntCurr;
            
            
    
endmodule
