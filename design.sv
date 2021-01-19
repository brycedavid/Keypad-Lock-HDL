//`timescale 1ns/100ps

module keypad_lock(count, clk, rst, number, key, doorUnlocked, doorLocked, stateOut, correctCount, keyNeeded);
  
  //define inputs/outputs
  input clk, rst;
  input [3:0] number;
  input key;
  input [2:0] count;
  
  output doorLocked;
  output doorUnlocked;
  output [3:0] stateOut;
  output [3:0] correctCount;
  output keyNeeded;
  reg doorLocked;
  reg doorUnlocked;
  reg [3:0] stateOut;
  reg [3:0] correctCount;
  reg keyNeeded;
  
  
  //params
  parameter state0=0, state1=1, state2=2, state3=3, state4=4, state5=5, state6=6, state7=7, state8=8;
  
  reg[3:0] state, nxt_st;
  
  //if doorUnlocked goes high and 4 digits weren't entered, keep door locked
  always @(doorUnlocked)
    begin
      if(doorUnlocked == 1 && count != 4)
        begin
        	doorUnlocked = 0;
       		doorLocked = 1;
        end
    end
  
  
  //next state logic
  always @(state or number or key)
    begin: next_state_logic
      case(state)
        
        state0:
          begin
            keyNeeded = 0;
            correctCount = 0;
            if(number == 4)
              begin
                nxt_st = state5;
                correctCount += 1;
                keyNeeded = 1;
              end
            else if(number == 1)
              begin
                nxt_st = state1;
                correctCount += 1;
              end
            else nxt_st = state0;
          end
        
        state1:
          begin
            if(number == 3)
              begin
                nxt_st = state2;
                correctCount += 1;
              end
            else nxt_st = state0;
          end
        
        state2:
          begin
            if(number == 3)
              begin
                nxt_st = state3;
                correctCount += 1;
              end
            else nxt_st = state0;
          end
        
        state3:
          begin
            if(number == 7 && key == 0)
              begin
                nxt_st = state4;
                correctCount += 2;
              end
            else nxt_st = state0;
          end
        
        state4:
          begin
            nxt_st = state0;
          end
        
        state5:
          begin
            if(number == 9)
              begin
                nxt_st = state6;
                correctCount += 1;
              end
            else nxt_st = state0;
          end
        
        state6:
          begin
            if(number == 2)
              begin
                nxt_st = state7;
                correctCount += 1;
              end
            else nxt_st = state0;
          end
        
        state7:
          begin
            if(number == 3)
              begin
                nxt_st = state8;
                correctCount += 1;
              end
            else nxt_st = state0;
          end
        
        state8:
          begin
            if(key == 1)
              begin
                nxt_st = state4;
                correctCount += 1;
              end
            else nxt_st = state0;
          end
        
        default:
          begin
            nxt_st = state0;
          end
        
      endcase
    end
  
  //causes actual state change & reset
  always @(posedge clk or posedge rst)
    begin: register_generation
      if(rst)
        state = state0;
      else
        state = nxt_st;
    end
  
  //handles output logic
  always @(state) begin: output_logic
    case(state)
      state0:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd0;
        end
      
      state1:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd1;
        end
      
      state2:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd2;
        end
      
      state3:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd3;
        end
      
      state4:
        begin
          doorLocked = 1'b0;
          doorUnlocked = 1'b1;
          stateOut = 4'd4;
        end
      
      state5:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd5;
        end
      
      state6:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd6;
        end
      
      state7:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd7;
        end
      
      state8:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd8;
        end
      
      default:
        begin
          doorLocked = 1'b1;
          doorUnlocked = 1'b0;
          stateOut = 4'd0;
        end
      
    endcase
    
  end
  
endmodule
      
  
  