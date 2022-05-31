`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2022 16:41:19
// Design Name: 
// Module Name: TB_FSM
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2022 17:03:33
// Design Name: 
// Module Name: TB_VGA_pattern
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


module TB_FSM;

//signals
reg r_iClk, r_iRst, r_iPushUp, r_iPushDown, r_iPushLeft, r_iPushRight, r_iScreensaver;
wire[9:0] w_oShapeX, w_oShapeY, w_oShapeSize;
wire w_oLEDUp, w_oLEDDown, w_oLEDLeft, w_oLEDRight;


//params for VGA controller
localparam WIDTH_inst = 640;
localparam H_FP_inst = 16;
localparam H_PW_inst = 96;
localparam H_BP_inst = 48; //Htot = 20
localparam HEIGHT_inst = 480;
localparam V_FP_inst = 10;
localparam V_PW_inst = 2;
localparam V_BP_inst = 33; //Vtot = 15

FSM_lab5 FSM_lab5_inst(.iClk(r_iClk), .iRst(r_iRst), .iScreensaver(r_iScreensaver), 
.iPushUp(r_iPushUp), .iPushDown(r_iPushDown), .iPushLeft(r_iPushLeft), .iPushRight(r_iPushRight), 
.oLEDUp(w_oLEDUp), .oLEDDown(w_oLEDDown),  .oLEDLeft(w_oLEDLeft), .oLEDRight(w_oLEDRight), 
.oShapeX(w_oShapeX), .oShapeY(w_oShapeY), .oShapeSize(w_oShapeSize));



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
    r_iPushUp = 0;
    r_iPushDown = 0;
    r_iPushLeft = 0;
    r_iPushRight = 0;
    r_iScreensaver = 0;
    #(50000000);
    r_iRst = 0;
    #(500);
    #(10000000);
    r_iScreensaver = 1;
    #(1000000);
end


endmodule