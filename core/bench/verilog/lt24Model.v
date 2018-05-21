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
    lt24_lcd_d_o,                        // LT24 LCD Data input
    lt24_adc_busy_o,                     // LT24 ADC Busy
    lt24_adc_dout_o,                     // LT24 ADC Data Out
    lt24_adc_penirq_n_o,                 // LT24 ADC Pen Interrupt

// INPUTs
    lt24_lcd_cs_n_i,                     // LT24 LCD Chip select (Active low)
    lt24_lcd_rd_n_i,                     // LT24 LCD Read strobe (Active low)
    lt24_lcd_wr_n_i,                     // LT24 LCD Write strobe (Active low)
    lt24_lcd_rs_i,                       // LT24 LCD Command/Param selection (Cmd=0/Param=1)
    lt24_lcd_d_i,                        // LT24 LCD Data output
    lt24_lcd_d_en_i,                     // LT24 LCD Data output enable
    lt24_lcd_reset_n_i,                  // LT24 LCD Reset (Active Low)
    lt24_lcd_on_i,                       // LT24 LCD on/off
    lt24_adc_cs_n_i,                     // LT24 ADC Chip Select
    lt24_adc_dclk_i,                     // LT24 ADC Clock
    lt24_adc_din_i                       // LT24 ADC Data In
);

// OUTPUTs
//============
output      [15:0] lt24_lcd_d_o;         // LT24 LCD Data input
output             lt24_adc_busy_o;      // LT24 ADC Busy
output             lt24_adc_dout_o;      // LT24 ADC Data Out
output             lt24_adc_penirq_n_o;  // LT24 ADC Pen Interrupt

// INPUTs
//============
input              lt24_lcd_cs_n_i;      // LT24 LCD Chip select (Active low)
input              lt24_lcd_rd_n_i;      // LT24 LCD Read strobe (Active low)
input              lt24_lcd_wr_n_i;      // LT24 LCD Write strobe (Active low)
input              lt24_lcd_rs_i;        // LT24 LCD Command/Param selection (Cmd=0/Param=1)
input       [15:0] lt24_lcd_d_i;         // LT24 LCD Data output
input              lt24_lcd_d_en_i;      // LT24 LCD Data output enable
input              lt24_lcd_reset_n_i;   // LT24 LCD Reset (Active Low)
input              lt24_lcd_on_i;        // LT24 LCD on/off
input              lt24_adc_cs_n_i;      // LT24 ADC Chip Select
input              lt24_adc_dclk_i;      // LT24 ADC Clock
input              lt24_adc_din_i;       // LT24 ADC Data In


//----------------------------------------------------------------------------
// LCD
//----------------------------------------------------------------------------

// PARAMETERs
//============

// Screen
parameter LCD_WIDTH   = 320;
parameter LCD_HEIGHT  = 240;
parameter LCD_SIZE    = LCD_WIDTH * LCD_HEIGHT;

// Command
parameter CMD_LCD_NOP                       =  16'h0000;
parameter CMD_LCD_SOFTWARE_RESET            =  16'h0001;
parameter CMD_LCD_READ_DISPLAY_ID           =  16'h0004;
parameter CMD_LCD_READ_DISPLAY_STATUS       =  16'h0009;
parameter CMD_LCD_READ_DISPLAY_POWER_MODE   =  16'h000A;
parameter CMD_LCD_READ_DISPLAY_MADCTL       =  16'h000B;
parameter CMD_LCD_READ_DISPLAY_PIXEL_FORMAT =  16'h000C;
parameter CMD_LCD_READ_DISPLAY_IMAGE_FORMAT =  16'h000D;
parameter CMD_LCD_READ_DISPLAY_SIGNAL_MODE  =  16'h000E;
parameter CMD_LCD_READ_DISPLAY_SELF_DIAG    =  16'h000F;
parameter CMD_LCD_ENTER_SLEEP_MODE          =  16'h0010;
parameter CMD_LCD_SLEEP_OUT                 =  16'h0011;
parameter CMD_LCD_PARTIAL_MODE_ON           =  16'h0012;
parameter CMD_LCD_NORMAL_DISPLAY_MODE_ON    =  16'h0013;
parameter CMD_LCD_DISPLAY_INVERSION_OFF     =  16'h0020;
parameter CMD_LCD_DISPLAY_INVERSION_ON      =  16'h0021;
parameter CMD_LCD_GAMMA_SET                 =  16'h0026;
parameter CMD_LCD_DISPLAY_OFF               =  16'h0028;
parameter CMD_LCD_DISPLAY_ON                =  16'h0029;
parameter CMD_LCD_COLUMN_ADDRESS_SET        =  16'h002A;
parameter CMD_LCD_PAGE_ADDRESS_SET          =  16'h002B;
parameter CMD_LCD_MEMORY_WRITE              =  16'h002C;
parameter CMD_LCD_COLOR_SET                 =  16'h002D;
parameter CMD_LCD_MEMORY_READ               =  16'h002E;
parameter CMD_LCD_PARTIAL_AREA              =  16'h0030;
parameter CMD_LCD_VERTICAL_SCROLLING_DEF    =  16'h0033;
parameter CMD_LCD_TEARING_EFFECT_LINE_OFF   =  16'h0034;
parameter CMD_LCD_TEARING_EFFECT_LINE_ON    =  16'h0035;
parameter CMD_LCD_MEMORY_ACCESS_CONTROL     =  16'h0036;
parameter CMD_LCD_VERTICAL_SCROL_START_ADDR =  16'h0037;
parameter CMD_LCD_IDLE_MODE_OFF             =  16'h0038;
parameter CMD_LCD_IDLE_MODE_ON              =  16'h0039;
parameter CMD_LCD_PIXEL_FORMAT_SET          =  16'h003A;
parameter CMD_LCD_WRITE_MEMORY_CONTINUE     =  16'h003C;
parameter CMD_LCD_READ_MEMORY_CONTINUE      =  16'h003E;
parameter CMD_LCD_SET_TEAR_SCANLINE         =  16'h0044;
parameter CMD_LCD_GET_SCANLINE              =  16'h0045;
parameter CMD_LCD_WRITE_DISPLAY_BRIGHTNESS  =  16'h0051;
parameter CMD_LCD_READ_DISPLAY_BRIGHTNESS   =  16'h0052;
parameter CMD_LCD_WRITE_CTRL_DISPLAY        =  16'h0053;
parameter CMD_LCD_READ_CTRL_DISPLAY         =  16'h0054;
parameter CMD_LCD_WRITE_CONTENT_ADAPTIVE    =  16'h0055;
parameter CMD_LCD_READ_CONTENT_ADAPTIVE     =  16'h0056;
parameter CMD_LCD_WRITE_CABC_MIN_BRIGHTNESS =  16'h005E;
parameter CMD_LCD_READ_CABC_MIN_BRIGHTNESS  =  16'h005F;
parameter CMD_LCD_READ_ID1                  =  16'h00DA;
parameter CMD_LCD_READ_ID2                  =  16'h00DB;
parameter CMD_LCD_READ_ID3                  =  16'h00DC;

parameter CMD_LCD_IDLE                      =  16'hFFFF;

// COMMAND DECODER
//=================
reg  [15:0] lt24_state;
always @(posedge lt24_lcd_wr_n_i or posedge lt24_lcd_cs_n_i)
  if (lt24_lcd_cs_n_i)     lt24_state        <= CMD_LCD_IDLE;
  else if (~lt24_lcd_rs_i) lt24_state        <= lt24_lcd_d_i;

reg         lt24_state_update;
always @(posedge lt24_lcd_wr_n_i or posedge lt24_lcd_rs_i)
  if (lt24_lcd_rs_i)       lt24_state_update <= 1'b0;
  else                     lt24_state_update <= 1'b1;


// MEMORY
//============

integer        mem_addr;
reg     [15:0] mem [0:LCD_SIZE-1];
     
always @(posedge lt24_lcd_wr_n_i)
  if     ((lt24_lcd_d_i  ==CMD_LCD_MEMORY_WRITE) & ~lt24_lcd_rs_i)
    begin
      mem_addr      <= 0;
    end
  else if (lt24_state==CMD_LCD_MEMORY_WRITE)
    begin
      mem[mem_addr] <= lt24_lcd_d_i;
      mem_addr      <= mem_addr+1;
    end

assign lt24_lcd_d_o = 16'h0000;


//----------------------------------------------------------------------------
// ADC
//----------------------------------------------------------------------------
reg        lt24_adc_penirq_n_o;

integer    coord_x;
integer    coord_y;
reg [11:0] adc_coord_x;
reg [11:0] adc_coord_y;

initial
  begin
    coord_x                 =  0;
    coord_y                 =  0;
    adc_coord_x             = 12'h000;
    adc_coord_y             = 12'h000;
    lt24_adc_penirq_n_o     =  1'b1;    // LT24 ADC Pen Interrupt
  end

always @(coord_x)
  adc_coord_x = (coord_x*'hfff)/320;

always @(coord_x)
  adc_coord_y = (coord_y*'hfff)/240;


integer shift_cnt;
always @(posedge lt24_adc_dclk_i or posedge lt24_adc_cs_n_i)
  if (lt24_adc_cs_n_i) shift_cnt <= 0;
  else                 shift_cnt <= shift_cnt+1;

reg [15:0] shift_in;
always @(posedge lt24_adc_dclk_i or posedge lt24_adc_cs_n_i)
  if (lt24_adc_cs_n_i) shift_in  <= 16'h0000;
  else                 shift_in  <= {shift_in[14:0], lt24_adc_din_i};

reg [15:0] shift_out;
always @(negedge lt24_adc_dclk_i or posedge lt24_adc_cs_n_i)
  if (lt24_adc_cs_n_i)                             shift_out <= 16'h0000;
  else if ((shift_cnt==8)  & (shift_in==16'h0092)) shift_out <= {1'b0, adc_coord_x, 3'b000};
  else if ((shift_cnt==32) & (shift_in==16'h00D2)) shift_out <= {1'b0, adc_coord_y, 3'b000};
  else                                             shift_out <= {shift_out[14:0], 1'b0};

assign     lt24_adc_dout_o  =  shift_out[15];    // LT24 ADC Data Out
assign     lt24_adc_busy_o  =  1'b0;    // LT24 ADC Busy


endmodule // lt24Model
