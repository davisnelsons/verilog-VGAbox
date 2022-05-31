`timescale 1ns / 1ps

module FSM_lab5 (
  input   wire  iClk, iRst, iScreensaver,
  input wire iPushUp, iPushDown, iPushLeft, iPushRight,
  output  wire  oLEDUp, oLEDDown, oLEDLeft, oLEDRight, 
  output wire[9:0] oShapeX, oShapeY, oShapeSize 
    );
    
    
  // 0. State definition
  localparam sIdle    = 3'b000;
  localparam sPushUp    = 3'b001;
  localparam sPushDown    = 3'b010;
  localparam sPushLeft  = 3'b011;
  localparam sPushRight    = 3'b100;
  localparam sReset = 3'b101;
  localparam sScreensaver = 3'b110;
  
  reg speedX_current, speedY_current, speedX_next, speedY_next;
 
  localparam shapeSize = 60;    // NEW
  localparam defaultX = 290;    // NEW
  localparam defaultY = 210;    // NEW
  
  
  reg[2:0] rFSM_current, wFSM_next;
  wire oToggle, iToggleEnable;
  reg[9:0] rShapeX_current, rShapeX_next, rShapeY_current, rShapeY_next,
           rShapeX_out, rShapeY_out ;
  wire[9:0] rShapeX_plus, rShapeX_minus, rShapeY_plus, rShapeY_minus;// NEW registers to update shape values
  
  //init toggle
  toggle #(.CLK_FREQ(100000))
  toggle_inst(.iClk(iClk), .iRst(iRst), .oToggle(oToggle));
  
  // 1. State register
  //  - with synchronous reset
  always @(posedge iClk)
  begin
    if (iRst == 1)
      rFSM_current <= sReset;
    else if (iScreensaver == 1)
      rFSM_current <= sScreensaver;
    else
      rFSM_current <= wFSM_next;
  end
  // updates values of shapeX and Y when toggle is high
  
  //update current every clock cycle
  always @(posedge iClk)
  begin
    if(iRst == 1)
        begin
            rShapeX_current <= defaultX;
            rShapeY_current <= defaultY;
        end
    else
        begin
            rShapeX_current <= rShapeX_next;
            rShapeY_current <= rShapeY_next;
        end
  end
  
  //update out (from current) only every toggle to slow down the movement
  always @(posedge oToggle)
  begin
    if(iRst == 1)
      begin
        rShapeX_out <= defaultX;
        rShapeY_out <= defaultY;
      end
    else
      begin
        rShapeX_out <= rShapeX_current;
        rShapeY_out <= rShapeY_current; 
      end
  end
  
  
  //check if within bounds, assign value accordingly
  assign rShapeX_plus = (rShapeX_out < 580) ? rShapeX_out + 1 : rShapeX_out;
  assign rShapeX_minus = (rShapeX_out > 0) ? rShapeX_out - 1 : rShapeX_out; 
  assign rShapeY_plus = (rShapeY_out < 420) ? rShapeY_out + 1 : rShapeY_out;
  assign rShapeY_minus = (rShapeY_out > 0) ? rShapeY_out - 1 : rShapeY_out;


  always @(*)
  begin
    rShapeY_next = defaultY;
    rShapeX_next = defaultX;
    case (rFSM_current)
      sPushUp:
          begin
            rShapeY_next = rShapeY_minus;     
            rShapeX_next = rShapeX_current;
          end
      sPushDown:
          begin
            rShapeY_next = rShapeY_plus; 
            rShapeX_next = rShapeX_current;
          end
      sPushLeft:
      begin
        rShapeY_next = rShapeY_current;
        rShapeX_next = rShapeX_minus;   
      end
      sPushRight:
      begin
        rShapeX_next = rShapeX_plus; 
        rShapeY_next = rShapeY_current;
      end
      sReset:
          begin
           rShapeX_next = defaultX;
           rShapeY_next = defaultY;
          end
      sScreensaver:
          begin
           rShapeX_next = (speedX_current == 1) ?  (rShapeX_out + 1) : (rShapeX_out - 1) ;
           rShapeY_next = (speedY_current == 1) ?  (rShapeY_out + 1) : (rShapeY_out - 1) ;
          end
      sIdle:
          begin
               rShapeX_next = rShapeX_current;
               rShapeY_next = rShapeY_current;
          end
    endcase
  end 
  // 2. Next state logic
  //  - only defines the value of wFSM_next
  //  - in function of inputs and rFSM_current
  always @(*)
  begin
    case (rFSM_current)
   
      sIdle:    if (iPushUp == 1)
                  wFSM_next = sPushUp;
                else if (iPushDown == 1)
                  wFSM_next = sPushDown;
                else if (iPushLeft == 1)
                  wFSM_next = sPushLeft;
                else if (iPushRight == 1)
                  wFSM_next = sPushRight;
                else if(iRst == 1)
                  wFSM_next = sReset;
                else
                  wFSM_next = sIdle;
                
      sPushUp:  if (iPushUp == 1)
                  wFSM_next = sPushUp;
                else
                  wFSM_next = sIdle;
                  
      sPushDown:  if (iPushDown == 1)
                  wFSM_next = sPushDown;
                else
                  wFSM_next = sIdle;
                  
      sPushLeft:  if (iPushLeft == 1)
                  wFSM_next = sPushLeft;
                else
                  wFSM_next = sIdle;
     
      sPushRight:  if (iPushRight == 1)
                  wFSM_next = sPushRight;
                else
                  wFSM_next = sIdle;    
      sReset: wFSM_next = sIdle;  
      sScreensaver:  if (iScreensaver == 0)
                  wFSM_next = sReset;
                else
                  wFSM_next = sScreensaver;      
      default:  wFSM_next = sReset;
    endcase
  end
  
  //Speed control
  always @(posedge iClk) 
  begin
    if(iScreensaver == 1)
        begin
            speedX_current <= speedX_next;
            speedY_current <= speedY_next;
        end
    else 
        begin
            speedX_current <= 1;
            speedY_current <= 1;
        end
  end
  
  always @(*)
  begin
    speedX_next = speedX_current;
    speedY_next = speedY_current;
    if(iScreensaver == 1)
        begin
            if (rShapeX_out >= 580) speedX_next = 0;
            if (rShapeX_out == 0) speedX_next = 1;
            if (rShapeY_out >= 420) speedY_next = 0;
            if (rShapeY_out == 0) speedY_next = 1;
            speedX_next = speedX_next;
            speedY_next = speedY_next;
        end
    else
        begin
            speedX_next = 1;
            speedY_next = 1;
        end
  end
  
  
  // 3. Output logic
  // In this case, we need a register to keep track of the toggling
 //toggle disabled!
  assign oLEDUp = (rFSM_current == sPushUp || rFSM_current == sScreensaver) ? 1 : 0;
  assign oLEDDown = (rFSM_current == sPushDown || rFSM_current == sScreensaver) ? 1 : 0;
  assign oLEDLeft = (rFSM_current == sPushLeft || rFSM_current == sScreensaver) ? 1 : 0;
  assign oLEDRight = (rFSM_current == sPushRight || rFSM_current == sScreensaver) ? 1 : 0;
  assign oShapeSize = shapeSize; // NEW
  assign oShapeX = rShapeX_out; //(rShapeX <= 0) ? 0 : rShapeX ;// NEW CHECKS IF SHAPE IS WITHIN BOUNDARIES?
  assign oShapeY = rShapeY_out;// NEW, ALSO CHECK LIMITS BUT PROBABLY LATER IN CODE.
  
endmodule
