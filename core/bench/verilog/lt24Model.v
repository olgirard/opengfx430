//----------------------------------------------------------------------------
// Copyright (C) 2001 Authors
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
// License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
//----------------------------------------------------------------------------
// 
// *File Name: lt24Model.v
// 
// *Module Description:
//                      LT24 Model
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 103 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2011-03-05 15:44:48 +0100 (Sat, 05 Mar 2011) $
//----------------------------------------------------------------------------

module lt24Model (

// OUTPUTs
    lt24_d_o,                      // LT24 Data input

// INPUTs
    lt24_cs_n_i,                   // LT24 Chip select (Active low)
    lt24_rd_n_i,                   // LT24 Read strobe (Active low)
    lt24_wr_n_i,                   // LT24 Write strobe (Active low)
    lt24_rs_i,                     // LT24 Command/Param selection (Cmd=0/Param=1)
    lt24_d_i,                      // LT24 Data output
    lt24_d_en_i,                   // LT24 Data output enable
    lt24_reset_n_i,                // LT24 Reset (Active Low)
    lt24_on_i                      // LT24 on/off
);

// OUTPUTs
//============
output      [15:0] lt24_d_o;       // LT24 Data input

// INPUTs
//============
input              lt24_cs_n_i;    // LT24 Chip select (Active low)
input              lt24_rd_n_i;    // LT24 Read strobe (Active low)
input              lt24_wr_n_i;    // LT24 Write strobe (Active low)
input              lt24_rs_i;      // LT24 Command/Param selection (Cmd=0/Param=1)
input       [15:0] lt24_d_i;       // LT24 Data output
input              lt24_d_en_i;    // LT24 Data output enable
input              lt24_reset_n_i; // LT24 Reset (Active Low)
input              lt24_on_i;      // LT24 on/off


//----------------------------------------------------------------------------
// 
//----------------------------------------------------------------------------

// PARAMETERs
//============

// Screen
parameter LT24_WIDTH   = 320;
parameter LT24_HEIGHT  = 240;
parameter LT24_SIZE    = LT24_WIDTH * LT24_HEIGHT;

// Command
parameter CMD_NOP                       =  16'h0000;
parameter CMD_SOFTWARE_RESET            =  16'h0001;
parameter CMD_READ_DISPLAY_ID           =  16'h0004;
parameter CMD_READ_DISPLAY_STATUS       =  16'h0009;
parameter CMD_READ_DISPLAY_POWER_MODE   =  16'h000A;
parameter CMD_READ_DISPLAY_MADCTL       =  16'h000B;
parameter CMD_READ_DISPLAY_PIXEL_FORMAT =  16'h000C;
parameter CMD_READ_DISPLAY_IMAGE_FORMAT =  16'h000D;
parameter CMD_READ_DISPLAY_SIGNAL_MODE  =  16'h000E;
parameter CMD_READ_DISPLAY_SELF_DIAG    =  16'h000F;
parameter CMD_ENTER_SLEEP_MODE          =  16'h0010;
parameter CMD_SLEEP_OUT                 =  16'h0011;
parameter CMD_PARTIAL_MODE_ON           =  16'h0012;
parameter CMD_NORMAL_DISPLAY_MODE_ON    =  16'h0013;
parameter CMD_DISPLAY_INVERSION_OFF     =  16'h0020;
parameter CMD_DISPLAY_INVERSION_ON      =  16'h0021;
parameter CMD_GAMMA_SET                 =  16'h0026;
parameter CMD_DISPLAY_OFF               =  16'h0028;
parameter CMD_DISPLAY_ON                =  16'h0029;
parameter CMD_COLUMN_ADDRESS_SET        =  16'h002A;
parameter CMD_PAGE_ADDRESS_SET          =  16'h002B;
parameter CMD_MEMORY_WRITE              =  16'h002C;
parameter CMD_COLOR_SET                 =  16'h002D;
parameter CMD_MEMORY_READ               =  16'h002E;
parameter CMD_PARTIAL_AREA              =  16'h0030;
parameter CMD_VERTICAL_SCROLLING_DEF    =  16'h0033;
parameter CMD_TEARING_EFFECT_LINE_OFF   =  16'h0034;
parameter CMD_TEARING_EFFECT_LINE_ON    =  16'h0035;
parameter CMD_MEMORY_ACCESS_CONTROL     =  16'h0036;
parameter CMD_VERTICAL_SCROL_START_ADDR =  16'h0037;
parameter CMD_IDLE_MODE_OFF             =  16'h0038;
parameter CMD_IDLE_MODE_ON              =  16'h0039;
parameter CMD_PIXEL_FORMAT_SET          =  16'h003A;
parameter CMD_WRITE_MEMORY_CONTINUE     =  16'h003C;
parameter CMD_READ_MEMORY_CONTINUE      =  16'h003E;
parameter CMD_SET_TEAR_SCANLINE         =  16'h0044;
parameter CMD_GET_SCANLINE              =  16'h0045;
parameter CMD_WRITE_DISPLAY_BRIGHTNESS  =  16'h0051;
parameter CMD_READ_DISPLAY_BRIGHTNESS   =  16'h0052;
parameter CMD_WRITE_CTRL_DISPLAY        =  16'h0053;
parameter CMD_READ_CTRL_DISPLAY         =  16'h0054;
parameter CMD_WRITE_CONTENT_ADAPTIVE    =  16'h0055;
parameter CMD_READ_CONTENT_ADAPTIVE     =  16'h0056;
parameter CMD_WRITE_CABC_MIN_BRIGHTNESS =  16'h005E;
parameter CMD_READ_CABC_MIN_BRIGHTNESS  =  16'h005F;
parameter CMD_READ_ID1                  =  16'h00DA;
parameter CMD_READ_ID2                  =  16'h00DB;
parameter CMD_READ_ID3                  =  16'h00DC;

parameter CMD_IDLE                      =  16'hFFFF;

// COMMAND DECODER
//=================
reg  [15:0] lt24_state;
always @(posedge lt24_wr_n_i or posedge lt24_cs_n_i)
  if (lt24_cs_n_i)     lt24_state        <= CMD_IDLE;
  else if (~lt24_rs_i) lt24_state        <= lt24_d_i;

reg         lt24_state_update;
always @(posedge lt24_wr_n_i or posedge lt24_rs_i)
  if (lt24_rs_i)       lt24_state_update <= 1'b0;
  else                 lt24_state_update <= 1'b1;


// MEMORY
//============

integer        mem_addr;
reg     [15:0] mem [0:LT24_SIZE-1];
     
always @(posedge lt24_wr_n_i)
  if     ((lt24_d_i  ==CMD_MEMORY_WRITE) & ~lt24_rs_i)
    begin
      mem_addr      <= 0;
    end
  else if (lt24_state==CMD_MEMORY_WRITE)
    begin
      mem[mem_addr] <= lt24_d_i;
      mem_addr      <= mem_addr+1;
    end

assign lt24_d_o = 16'h0000;


endmodule // lt24Model
