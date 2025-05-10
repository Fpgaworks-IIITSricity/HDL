`timescale 1ns / 1ps
module vga_sync(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
  input [9:0] h_count;
  input [9:0] v_count;
  output h_sync;
  output v_sync;
  output video_on;
  output [9:0] x_loc;
  output [9:0] y_loc;
  
  localparam HD=640;
  localparam HF=48;
  localparam HB=16;
  localparam HR=96;
  
  localparam VD=480;
  localparam VF=10;
  localparam VB=33;
  localparam VR=2;
  
  assign video_on = (h_count < HD) && (v_count <VD);
  assign x_loc = h_count;
  assign y_loc = v_count;
  assign h_sync = (h_count<(HD+HB)) || (h_count>(HD+HB+HR));
  assign v_sync = (v_count<(VD+VB)) || (v_count>(VD+VB+VR));



  endmodule