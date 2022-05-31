`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2022 14:43:11
// Design Name: 
// Module Name: TB_VGA_timings
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


module TB_VGA_timings;

//signals
reg r_iClk, r_iRst;
wire[9:0] w_oCountH;
wire[9:0] w_oCountV;
wire w_oHS, w_oVS;

//params for VGA controller
localparam WIDTH_inst = 640;
localparam H_FP_inst = 16;
localparam H_PW_inst = 96;
localparam H_BP_inst = 48; //Htot = 20
localparam HEIGHT_inst = 480;
localparam V_FP_inst = 10;
localparam V_PW_inst = 2;
localparam V_BP_inst = 33; //Vtot = 15

VGA_timings
#( .WIDTH(WIDTH_inst), .H_FP(H_FP_inst), .H_PW(H_PW_inst), .H_BP(H_BP_inst), 
   .HEIGHT(HEIGHT_inst), .V_FP(V_FP_inst), .V_PW(V_PW_inst), .V_BP(V_BP_inst))
VGA_timings_inst
(   .iClk(r_iClk), .iRst(r_iRst), 
    .oCountH(w_oCountH), .oCountV(w_oCountV), .oHS(w_oHS), .oVS(w_oVS));
    
always
begin
   r_iClk = 1;
   #(20);
   r_iClk = 0;
   #(20); 
end 


initial
begin
    r_iRst=1;
    #(500);
    r_iRst = 0;
    #(10000);
end








endmodule
