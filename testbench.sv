//`timescale 1ns/100ps

module keypad_lock_testbench();
  
  //declare inputs (reg) and outputs (wire)
  reg clk, rst, key;
  reg [3:0] number;
  reg [2:0] count;
  
  wire doorUnlocked;
  wire doorLocked;
  wire [3:0] stateOut;
  wire [3:0] correctCount;
  wire keyNeeded;
  
  
  
  //instantiate design
  keypad_lock myLock (count, clk, rst, number, key, doorUnlocked, doorLocked, stateOut, correctCount, keyNeeded);
  
  //creates and handles clock
  initial
    begin
      clk = 0;
      rst = 0;
      key = 0;
      count = 0;
      #1 rst = 1;
      #50 rst = 0;
    end
  
  //inverts clock every 50
  always #50 clk = ~clk;
  
  
  //when a new number is entered, increment count
  always @(number)
    begin
      $display("Input: %d\n", number);
      if(count == 0)
        begin
          count = 1;
        end
      else if(count == 1)
        count = 2;
      else if(count == 2)
        count = 3;
      else if(count == 3)
        begin
          count = 4;
        end
      else if(count == 4)
        begin
          count = 1;
        end
    end
  
  
  //if 4 digits entered and aren't correct, output & reset
  always @(count)
    begin
      if(count == 4)
        begin
          if(correctCount != 5 && doorUnlocked == 0 && keyNeeded == 0)
            $display("Invalid code entered; door locked\n");
          else if(correctCount != 4 && doorUnlocked == 0 && keyNeeded == 1)
            $display("Invalid code entered; door locked\n");
          else if(correctCount == 4 && keyNeeded == 1)
            if(key == 0)
              $display("Invalid code entered; door locked\n");
        end
    end
  
  //displays when door is unlocked/locked
  always @(doorUnlocked)
    begin
      if(doorUnlocked == 1 && count == 4)
        begin
          $display("Correct code entered; door unlocked\n");
          $display("--Resetting...door locked--\n");
          count = 0;
        end
    end
  
  always @(doorLocked)
    begin
      if(doorLocked == 1 && rst == 0 && count == 4)
        begin
          $display("Invalid code entered; door locked\n");
          $display("--Resetting...door locked--\n");
          count = 0;
        end
    end
  
  //displays when key is entered or removed
  always @(key)
    begin
      if(key == 1)
        $display("--Key inserted--");
      else if(key == 0)
        $display("--Key removed--");
    end
        
  
  always @(rst)
    begin
      if(rst == 1)
        $display("--Reset pressed; resetting...--\n");
      count = 0;
      rst = 0;
    end
  
  always @(number or doorUnlocked)
    $display("State: %d, Door Locked: %d, Door Unlocked: %d, Key: %d",stateOut, doorLocked, doorUnlocked, key, rst);
  
  
  //input test cases
  initial begin
    rst = 0;
    key = 0;
    count = 0;
    
    
    #1
    #100
    key = 0;
    number = 1;
    
    
    
    #100
    key = 0;
    number = 3;
    
    
    
    //**********************************************************
    //Notice here that I manually implement count; this is because
    //it does not detect a change in number because we are setting
    //it to the same value as before (3).
    #100
    key = 0;
    number = 3;
    count += 1;
    $display("State: %d, Door Locked: %d, Door Unlocked: %d, Key: %d",stateOut, doorLocked, doorUnlocked, key, rst);
    $display("Input:  3\n");
    
    //***********************************************************
    
    #100
    key = 0;
    number = 7;
    
    
    #100
    
    
    #100
    key = 1;
    number = 4;
    
    
    
    #100
    number = 9;
    
    
    
    #100
    number = 2;
    
    
    
    #100
    number = 3;
    

    
    #100
    
	#100
    number = 5;
    
    
    #100
    number = 2;
    
    
    #100
    number = 5;
    
    
    #100
    number = 0;
    
    
    
    #100
    
    #100
    key = 0;
    number = 3;
    
    
    #100
    number = 2;
    
    
    #100
    number = 6;
    
    
    #100
    number = 5;
    
    
    #100
    number = 0;
    
    
    #100
    number = 2;
    
    
    #100
    number = 4;
    
    
    #100
    number = 2;
    
    
    #100
    
    #100
    number = 4;
    
    
    #100
    number = 9;
    
    
    #100
    number = 2;
    
    
    #100
    number = 3;
    
    
    #100
    
    #100
    number = 3;
    
    
    #100
    number = 9;
    
    
    #100
    rst = 1;
    
    
    #100
    rst = 0;
    number = 1;
    
    
    #100
    number = 5;
    
    
    #100
    number = 3;
    
    
    #100
    number = 8;
    
    
    #100
    
    //to produce waveforms
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    
    $finish;
  end
  
  //to monitor outputs, uncomment
  //initial begin
    //$monitor("Input: %d, State: %d, Door Locked: %d, Door Unlocked: %d, Key: %d, Reset: %d, Digits Entered: %d, Clock: %d, Time: %t\n", number, stateOut, doorLocked, doorUnlocked, key, rst, count, clk, $time);
  //end
endmodule
