//----------------------------------------------------------------------------
// Copyright (C) 2015 Authors
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
// *File Name: ogfx_if_lt24_reg.v
//
// *Module Description:
//                      Registers for LT24 interface.
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev$
// $LastChangedBy$
// $LastChangedDate$
//----------------------------------------------------------------------------
`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_defines.v"
`endif

module  ogfx_if_lt24_reg (

// OUTPUTs
    irq_adc_o,                                 // LT24 ADC interface interrupt
    irq_lcd_o,                                 // LT24 LCD interface interrupt

    lcd_reset_n_o,                             // LT24 LCD Reset (Active Low)
    lcd_on_o,                                  // LT24 LCD on/off
    lcd_cfg_clk_o,                             // LT24 LCD Interface clock configuration
    lcd_cfg_refr_o,                            // LT24 LCD Interface refresh configuration
    lcd_cfg_refr_sync_en_o,                    // LT24 LCD Interface refresh sync enable configuration
    lcd_cfg_refr_sync_val_o,                   // LT24 LCD Interface refresh sync value configuration
    lcd_cmd_refr_o,                            // LT24 LCD Interface refresh command
    lcd_cmd_val_o,                             // LT24 LCD Generic command value
    lcd_cmd_has_param_o,                       // LT24 LCD Generic command has parameters
    lcd_cmd_param_o,                           // LT24 LCD Generic command parameter value
    lcd_cmd_param_rdy_o,                       // LT24 LCD Generic command trigger
    lcd_cmd_dfill_o,                           // LT24 LCD Data fill value
    lcd_cmd_dfill_wr_o,                        // LT24 LCD Data fill trigger

    adc_enabled_o,                             // LT24 ADC Enabled
    adc_cfg_clk_o,                             // LT24 ADC Clock configuration
    adc_coord_y_swap_o,                        // LT24 Coordinates: swap Y axis (horizontal symmetry)
    adc_coord_x_swap_o,                        // LT24 Coordinates: swap X axis (vertical symmetry)
    adc_coord_cl_swap_o,                       // LT24 Coordinates: swap column/lines

    per_dout_o,                                // Peripheral data output

// INPUTs
    mclk,                                      // Main system clock
    puc_rst,                                   // Main system reset

    lcd_status_i,                              // LT24 LCD FSM Status
    lcd_start_evt_i,                           // LT24 LCD FSM is starting
    lcd_done_evt_i,                            // LT24 LCD FSM is done
    lcd_uflow_evt_i,                           // LT24 LCD refresh underfow

    adc_done_evt_i,                            // LT24 ADC FSM is done
    adc_x_data_i,                              // LT24 ADC X sampled data
    adc_y_data_i,                              // LT24 ADC Y sampled data
    adc_x_coord_i,                             // LT24 ADC X coordinate
    adc_y_coord_i,                             // LT24 ADC Y coordinate

    per_addr_i,                                // Peripheral address
    per_din_i,                                 // Peripheral data input
    per_en_i,                                  // Peripheral enable (high active)
    per_we_i                                   // Peripheral write enable (high active)
);

// PARAMETERs
//============

parameter     [14:0] BASE_ADDR = 15'h0280;     // Register base address
                                               //  - 5 LSBs must stay cleared: 0x0020, 0x0040,
                                               //                              0x0060, 0x0080,
                                               //                              0x00A0, ...
// OUTPUTs
//============
output               irq_adc_o;                // LT24 ADC interface interrupt
output               irq_lcd_o;                // LT24 LCD interface interrupt

output               lcd_reset_n_o;            // LT24 LCD Reset (Active Low)
output               lcd_on_o;                 // LT24 LCD on/off
output         [2:0] lcd_cfg_clk_o;            // LT24 LCD Interface clock configuration
output        [14:0] lcd_cfg_refr_o;           // LT24 LCD Interface refresh configuration
output               lcd_cfg_refr_sync_en_o;   // LT24 LCD Interface refresh sync configuration
output         [9:0] lcd_cfg_refr_sync_val_o;  // LT24 LCD Interface refresh sync value configuration
output               lcd_cmd_refr_o;           // LT24 LCD Interface refresh command
output         [7:0] lcd_cmd_val_o;            // LT24 LCD Generic command value
output               lcd_cmd_has_param_o;      // LT24 LCD Generic command has parameters
output        [15:0] lcd_cmd_param_o;          // LT24 LCD Generic command parameter value
output               lcd_cmd_param_rdy_o;      // LT24 LCD Generic command trigger
output        [15:0] lcd_cmd_dfill_o;          // LT24 LCD Data fill value
output               lcd_cmd_dfill_wr_o;       // LT24 LCD Data fill trigger

output               adc_enabled_o;            // LT24 ADC Enabled
output         [7:0] adc_cfg_clk_o;            // LT24 ADC Clock configuration
output               adc_coord_y_swap_o;       // LT24 Coordinates: swap Y axis (horizontal symmetry)
output               adc_coord_x_swap_o;       // LT24 Coordinates: swap X axis (vertical symmetry)
output               adc_coord_cl_swap_o;      // LT24 Coordinates: swap column/lines

output        [15:0] per_dout_o;               // Peripheral data output

// INPUTs
//============
input                mclk;                     // Main system clock
input                puc_rst;                  // Main system reset

input          [4:0] lcd_status_i;             // LT24 LCD FSM Status
input                lcd_start_evt_i;          // LT24 LCD FSM is starting
input                lcd_done_evt_i;           // LT24 LCD FSM is done
input                lcd_uflow_evt_i;          // LT24 LCD refresh underfow

input                adc_done_evt_i;           // LT24 ADC FSM is done
input         [11:0] adc_x_data_i;             // LT24 ADC X sampled data
input         [11:0] adc_y_data_i;             // LT24 ADC Y sampled data
input          [8:0] adc_x_coord_i;            // LT24 ADC X coordinate
input          [8:0] adc_y_coord_i;            // LT24 ADC Y coordinate

input         [13:0] per_addr_i;               // Peripheral address
input         [15:0] per_din_i;                // Peripheral data input
input                per_en_i;                 // Peripheral enable (high active)
input          [1:0] per_we_i;                 // Peripheral write enable (high active)


//=============================================================================
// 1)  PARAMETER DECLARATION
//=============================================================================

// Decoder bit width (defines how many bits are considered for address decoding)
parameter              DEC_WD                  =  5;

// Register addresses offset
parameter [DEC_WD-1:0] LT24_LCD_CFG            = 'h00,  // LT24 configuration and Generic command sending
                       LT24_LCD_REFRESH        = 'h02,
                       LT24_LCD_REFRESH_SYNC   = 'h04,
                       LT24_LCD_CMD            = 'h06,
                       LT24_LCD_CMD_PARAM      = 'h08,
                       LT24_LCD_CMD_DFILL      = 'h0A,
                       LT24_LCD_STATUS         = 'h0C,
                       LT24_LCD_IRQ            = 'h0E,

                       LT24_ADC_CFG            = 'h10,
                       LT24_ADC_IRQ            = 'h12,
                       LT24_ADC_DATA_X         = 'h14,
                       LT24_ADC_DATA_Y         = 'h16,
                       LT24_ADC_COORD_X        = 'h18,
                       LT24_ADC_COORD_Y        = 'h1A;


// Register one-hot decoder utilities
parameter              DEC_SZ                  =  (1 << DEC_WD);
parameter [DEC_SZ-1:0] BASE_REG                =  {{DEC_SZ-1{1'b0}}, 1'b1};

// Register one-hot decoder
parameter [DEC_SZ-1:0] LT24_LCD_CFG_D          = (BASE_REG << LT24_LCD_CFG          ),
                       LT24_LCD_REFRESH_D      = (BASE_REG << LT24_LCD_REFRESH      ),
                       LT24_LCD_REFRESH_SYNC_D = (BASE_REG << LT24_LCD_REFRESH_SYNC ),
                       LT24_LCD_CMD_D          = (BASE_REG << LT24_LCD_CMD          ),
                       LT24_LCD_CMD_PARAM_D    = (BASE_REG << LT24_LCD_CMD_PARAM    ),
                       LT24_LCD_CMD_DFILL_D    = (BASE_REG << LT24_LCD_CMD_DFILL    ),
                       LT24_LCD_STATUS_D       = (BASE_REG << LT24_LCD_STATUS       ),
                       LT24_LCD_IRQ_D          = (BASE_REG << LT24_LCD_IRQ          ),

                       LT24_ADC_CFG_D          = (BASE_REG << LT24_ADC_CFG          ),
                       LT24_ADC_IRQ_D          = (BASE_REG << LT24_ADC_IRQ          ),
                       LT24_ADC_DATA_X_D       = (BASE_REG << LT24_ADC_DATA_X       ),
                       LT24_ADC_DATA_Y_D       = (BASE_REG << LT24_ADC_DATA_Y       ),
                       LT24_ADC_COORD_X_D      = (BASE_REG << LT24_ADC_COORD_X      ),
                       LT24_ADC_COORD_Y_D      = (BASE_REG << LT24_ADC_COORD_Y      );


//============================================================================
// 2)  REGISTER DECODER
//============================================================================

// Local register selection
wire               reg_sel   =  per_en_i & (per_addr_i[13:DEC_WD-1]==BASE_ADDR[14:DEC_WD]);

// Register local address
wire  [DEC_WD-1:0] reg_addr  =  {per_addr_i[DEC_WD-2:0], 1'b0};

// Register address decode
wire  [DEC_SZ-1:0] reg_dec   =  (LT24_LCD_CFG_D          &  {DEC_SZ{(reg_addr == LT24_LCD_CFG          )}})  |
                                (LT24_LCD_REFRESH_D      &  {DEC_SZ{(reg_addr == LT24_LCD_REFRESH      )}})  |
                                (LT24_LCD_REFRESH_SYNC_D &  {DEC_SZ{(reg_addr == LT24_LCD_REFRESH_SYNC )}})  |
                                (LT24_LCD_CMD_D          &  {DEC_SZ{(reg_addr == LT24_LCD_CMD          )}})  |
                                (LT24_LCD_CMD_PARAM_D    &  {DEC_SZ{(reg_addr == LT24_LCD_CMD_PARAM    )}})  |
                                (LT24_LCD_CMD_DFILL_D    &  {DEC_SZ{(reg_addr == LT24_LCD_CMD_DFILL    )}})  |
                                (LT24_LCD_STATUS_D       &  {DEC_SZ{(reg_addr == LT24_LCD_STATUS       )}})  |
                                (LT24_LCD_IRQ_D          &  {DEC_SZ{(reg_addr == LT24_LCD_IRQ          )}})  |

                                (LT24_ADC_CFG_D          &  {DEC_SZ{(reg_addr == LT24_ADC_CFG          )}})  |
                                (LT24_ADC_IRQ_D          &  {DEC_SZ{(reg_addr == LT24_ADC_IRQ          )}})  |
                                (LT24_ADC_DATA_X_D       &  {DEC_SZ{(reg_addr == LT24_ADC_DATA_X       )}})  |
                                (LT24_ADC_DATA_Y_D       &  {DEC_SZ{(reg_addr == LT24_ADC_DATA_Y       )}})  |
                                (LT24_ADC_COORD_X_D      &  {DEC_SZ{(reg_addr == LT24_ADC_COORD_X      )}})  |
                                (LT24_ADC_COORD_Y_D      &  {DEC_SZ{(reg_addr == LT24_ADC_COORD_Y      )}})  ;

// Read/Write probes
wire               reg_write =  |per_we_i & reg_sel;
wire               reg_read  = ~|per_we_i & reg_sel;

// Read/Write vectors
wire  [DEC_SZ-1:0] reg_wr    = reg_dec & {DEC_SZ{reg_write}};
wire  [DEC_SZ-1:0] reg_rd    = reg_dec & {DEC_SZ{reg_read}};


//============================================================================
// 3) REGISTERS
//============================================================================

//------------------------------------------------
// LT24_LCD_CFG Register
//------------------------------------------------
reg  [15:0] lt24_lcd_cfg;

wire        lt24_lcd_cfg_wr = reg_wr[LT24_LCD_CFG];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)              lt24_lcd_cfg  <=  16'h0000;
  else if (lt24_lcd_cfg_wr) lt24_lcd_cfg  <=  per_din_i & 16'hE07F;

// Bitfield assignments
wire        lcd_irq_refr_done_en  =  lt24_lcd_cfg[15];
wire        lcd_irq_refr_start_en =  lt24_lcd_cfg[14];
wire        lcd_irq_refr_uflow_en =  lt24_lcd_cfg[13];
assign      lcd_cfg_clk_o         =  lt24_lcd_cfg[6:4];
assign      lcd_lcd_reset_n_o     = ~lt24_lcd_cfg[1];
assign      lcd_lcd_on_o          =  lt24_lcd_cfg[0];


//------------------------------------------------
// LT24_LCD_REFRESH Register
//------------------------------------------------
reg         lcd_cmd_refr_o;
reg  [14:0] lcd_cfg_refr_o;

wire        lt24_lcd_refresh_wr = reg_wr[LT24_LCD_REFRESH];
wire        lcd_cmd_refr_clr    = lcd_done_evt_i & lcd_status_i[2] & (lcd_cfg_refr_o==15'h0000); // Auto-clear in manual refresh mode when done

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                  lcd_cmd_refr_o  <=  1'h0;
  else if (lt24_lcd_refresh_wr) lcd_cmd_refr_o  <=  per_din_i[0];
  else if (lcd_cmd_refr_clr)    lcd_cmd_refr_o  <=  1'h0;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                  lcd_cfg_refr_o  <=  15'h0000;
  else if (lt24_lcd_refresh_wr) lcd_cfg_refr_o  <=  per_din_i[15:1];

wire [15:0] lt24_lcd_refresh = {lcd_cfg_refr_o, lcd_cmd_refr_o};


//------------------------------------------------
// LT24_LCD_REFRESH_SYNC Register
//------------------------------------------------
reg         lcd_cfg_refr_sync_en_o;
reg   [9:0] lcd_cfg_refr_sync_val_o;

wire        lt24_lcd_refresh_sync_wr = reg_wr[LT24_LCD_REFRESH_SYNC];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                       lcd_cfg_refr_sync_en_o  <=  1'h0;
  else if (lt24_lcd_refresh_sync_wr) lcd_cfg_refr_sync_en_o  <=  per_din_i[15];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                       lcd_cfg_refr_sync_val_o <=  10'h000;
  else if (lt24_lcd_refresh_sync_wr) lcd_cfg_refr_sync_val_o <=  per_din_i[9:0];

wire [15:0] lt24_lcd_refresh_sync = {lcd_cfg_refr_sync_en_o, 5'h00, lcd_cfg_refr_sync_val_o};


//------------------------------------------------
// LT24_LCD_CMD Register
//------------------------------------------------
reg  [15:0] lt24_lcd_cmd;

wire        lt24_lcd_cmd_wr = reg_wr[LT24_LCD_CMD];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)              lt24_lcd_cmd <=  16'h0000;
  else if (lt24_lcd_cmd_wr) lt24_lcd_cmd <=  per_din_i & 16'h01FF;

assign      lcd_cmd_val_o        = lt24_lcd_cmd[7:0];
assign      lcd_cmd_has_param_o  = lt24_lcd_cmd[8];


//------------------------------------------------
// LT24_LCD_CMD_PARAM Register
//------------------------------------------------
reg  [15:0] lcd_cmd_param_o;

wire        lt24_lcd_cmd_param_wr = reg_wr[LT24_LCD_CMD_PARAM];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                    lcd_cmd_param_o <=  16'h0000;
  else if (lt24_lcd_cmd_param_wr) lcd_cmd_param_o <=  per_din_i;

reg lcd_cmd_param_rdy_o;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst) lcd_cmd_param_rdy_o <=  1'b0;
  else         lcd_cmd_param_rdy_o <=  lt24_lcd_cmd_param_wr;


//------------------------------------------------
// LT24_LCD_CMD_DFILL Register
//------------------------------------------------
reg  [15:0] lcd_cmd_dfill_o;

assign      lcd_cmd_dfill_wr_o = reg_wr[LT24_LCD_CMD_DFILL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                 lcd_cmd_dfill_o <=  16'h0000;
  else if (lcd_cmd_dfill_wr_o) lcd_cmd_dfill_o <=  per_din_i;


//------------------------------------------------
// LT24_LCD_STATUS Register
//------------------------------------------------
wire [15:0] lt24_lcd_status;

assign      lt24_lcd_status[0]    = lcd_status_i[0]; // FSM_BUSY
assign      lt24_lcd_status[1]    = lcd_status_i[1]; // WAIT_PARAM
assign      lt24_lcd_status[2]    = lcd_status_i[2]; // REFRESH_BUSY
assign      lt24_lcd_status[3]    = lcd_status_i[3]; // WAIT_FOR_SCANLINE
assign      lt24_lcd_status[4]    = lcd_status_i[4]; // DATA_FILL_BUSY
assign      lt24_lcd_status[15:5] = 11'h000;


//------------------------------------------------
// LT24_LCD_IRQ Register
//------------------------------------------------
wire [15:0] lt24_lcd_irq;

// Clear IRQ when 1 is written. Set IRQ when FSM is done
wire        lcd_irq_refr_done_clr  = per_din_i[15] & reg_wr[LT24_LCD_IRQ];
wire        lcd_irq_refr_done_set  = lcd_done_evt_i;

wire        lcd_irq_refr_start_clr = per_din_i[14] & reg_wr[LT24_LCD_IRQ];
wire        lcd_irq_refr_start_set = lcd_start_evt_i;

wire        lcd_irq_refr_uflow_clr = per_din_i[13] & reg_wr[LT24_LCD_IRQ];
wire        lcd_irq_refr_uflow_set = lcd_uflow_evt_i;

reg         lcd_irq_refr_done;
reg         lcd_irq_refr_start;
reg         lcd_irq_refr_uflow;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)
    begin
       lcd_irq_refr_done  <=  1'b0;
       lcd_irq_refr_start <=  1'b0;
       lcd_irq_refr_uflow <=  1'b0;
    end
  else
    begin
       lcd_irq_refr_done  <=  ( lcd_irq_refr_done_set  | (~lcd_irq_refr_done_clr  & lcd_irq_refr_done ) ); // IRQ set has priority over clear
       lcd_irq_refr_start <=  ( lcd_irq_refr_start_set | (~lcd_irq_refr_start_clr & lcd_irq_refr_start) ); // IRQ set has priority over clear
       lcd_irq_refr_uflow <=  ( lcd_irq_refr_uflow_set | (~lcd_irq_refr_uflow_clr & lcd_irq_refr_uflow) ); // IRQ set has priority over clear
    end

assign  lt24_lcd_irq  =  {lcd_irq_refr_done, lcd_irq_refr_start, lcd_irq_refr_uflow, 13'h0000};

assign  irq_lcd_o     =  (lcd_irq_refr_done     & lcd_irq_refr_done_en)     |
                         (lcd_irq_refr_start    & lcd_irq_refr_start_en)    |
                         (lcd_irq_refr_uflow    & lcd_irq_refr_uflow_en)    ;  // LT24 LCD interrupt

//------------------------------------------------
// LT24_ADC_CFG Register
//------------------------------------------------
reg  [15:0] lt24_adc_cfg;

wire        lt24_adc_cfg_wr = reg_wr[LT24_ADC_CFG];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)              lt24_adc_cfg  <=  16'h0000;
  else if (lt24_adc_cfg_wr) lt24_adc_cfg  <=  per_din_i & 16'h9EFF;

// Bitfield assignments
wire        adc_irq_done_en     =  lt24_adc_cfg[15];
assign      adc_enabled_o       =  lt24_adc_cfg[12];
assign      adc_coord_x_swap_o  =  lt24_adc_cfg[11];
assign      adc_coord_y_swap_o  =  lt24_adc_cfg[10];
assign      adc_coord_cl_swap_o =  lt24_adc_cfg[ 9];
assign      adc_cfg_clk_o       =  lt24_adc_cfg[7:0];

//------------------------------------------------
// LT24_ADC_IRQ Register
//------------------------------------------------
wire [15:0] lt24_adc_irq;

// Clear IRQ when 1 is written. Set IRQ when FSM is done
wire        adc_irq_done_clr  = per_din_i[15] & reg_wr[LT24_ADC_IRQ];
wire        adc_irq_done_set  = adc_done_evt_i;

reg         adc_irq_done;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)
    begin
       adc_irq_done  <=  1'b0;
    end
  else
    begin
       adc_irq_done  <=  ( adc_irq_done_set  | (~adc_irq_done_clr  & adc_irq_done ) ); // IRQ set has priority over clear
    end

assign  lt24_adc_irq  =  {adc_irq_done, 15'h0000};

assign  irq_adc_o     =  (adc_irq_done & adc_irq_done_en);  // LT24 ADC interrupt

//------------------------------------------------
// LT24_ADC_DATA_X/Y Register
//------------------------------------------------

// Mark that new data has been received
reg         lt24_adc_new_data_rdy;
wire        copy_adc_data;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                      lt24_adc_new_data_rdy <=  1'b0;
  else if (adc_done_evt_i)          lt24_adc_new_data_rdy <=  1'b1;
  else if (copy_adc_data)           lt24_adc_new_data_rdy <=  1'b0;

// Latch new data
reg  [23:0] lt24_adc_new_data;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                      lt24_adc_new_data     <=  24'h000000;
  else if (adc_done_evt_i)          lt24_adc_new_data     <=  {adc_y_data_i, adc_x_data_i};


// Detect when both X and Y data have be read so that we can push the new data in
reg  [1:0] lt24_adc_data_empty;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                      lt24_adc_data_empty   <=  2'h3;
  else if (copy_adc_data)           lt24_adc_data_empty   <=  2'h0;
  else if (reg_rd[LT24_ADC_DATA_X]) lt24_adc_data_empty   <=  lt24_adc_data_empty | 2'h1;
  else if (reg_rd[LT24_ADC_DATA_Y]) lt24_adc_data_empty   <=  lt24_adc_data_empty | 2'h2;

assign      copy_adc_data = (lt24_adc_data_empty==2'h3) & lt24_adc_new_data_rdy;

// Push new data into read buffers when these have been read
reg  [15:0] lt24_adc_data_x;
reg  [15:0] lt24_adc_data_y;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)            lt24_adc_data_x  <=  16'h0000;
  else if (copy_adc_data) lt24_adc_data_x  <=  {4'h0, lt24_adc_new_data[11:0]};

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)            lt24_adc_data_y  <=  16'h0000;
  else if (copy_adc_data) lt24_adc_data_y  <=  {4'h0, lt24_adc_new_data[23:12]};

//------------------------------------------------
// LT24_ADC_COORD_X/Y Register
//------------------------------------------------

// Mark that new coordinates has been received
reg         lt24_adc_new_coord_rdy;
wire        copy_adc_coord;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                       lt24_adc_new_coord_rdy <=  1'b0;
  else if (adc_done_evt_i)           lt24_adc_new_coord_rdy <=  1'b1;
  else if (copy_adc_coord)           lt24_adc_new_coord_rdy <=  1'b0;

// Latch new data
reg  [17:0] lt24_adc_new_coord;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                       lt24_adc_new_coord     <=  18'h00000;
  else if (adc_done_evt_i)           lt24_adc_new_coord     <=  {adc_y_coord_i, adc_x_coord_i};


// Detect when both X and Y data have be read so that we can push the new data in
reg  [1:0] lt24_adc_coord_empty;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)                       lt24_adc_coord_empty   <=  2'h3;
  else if (copy_adc_coord)           lt24_adc_coord_empty   <=  2'h0;
  else if (reg_rd[LT24_ADC_COORD_X]) lt24_adc_coord_empty   <=  lt24_adc_coord_empty | 2'h1;
  else if (reg_rd[LT24_ADC_COORD_Y]) lt24_adc_coord_empty   <=  lt24_adc_coord_empty | 2'h2;

assign      copy_adc_coord = (lt24_adc_coord_empty==2'h3) & lt24_adc_new_coord_rdy;

// Push new data into read buffers when these have been read
reg  [15:0] lt24_adc_coord_x;
reg  [15:0] lt24_adc_coord_y;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)             lt24_adc_coord_x <=  16'h0000;
  else if (copy_adc_coord) lt24_adc_coord_x <=  {7'h00, lt24_adc_new_coord[8:0]};

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)             lt24_adc_coord_y <=  16'h0000;
  else if (copy_adc_coord) lt24_adc_coord_y <=  {7'h00, lt24_adc_new_coord[17:9]};


//============================================================================
// 4) DATA OUTPUT GENERATION
//============================================================================

// Data output mux
wire [15:0] lt24_lcd_cfg_read          = lt24_lcd_cfg               & {16{reg_rd[LT24_LCD_CFG         ]}};
wire [15:0] lt24_lcd_refresh_read      = lt24_lcd_refresh           & {16{reg_rd[LT24_LCD_REFRESH     ]}};
wire [15:0] lt24_lcd_refresh_sync_read = lt24_lcd_refresh_sync      & {16{reg_rd[LT24_LCD_REFRESH_SYNC]}};
wire [15:0] lt24_lcd_cmd_read          = lt24_lcd_cmd               & {16{reg_rd[LT24_LCD_CMD         ]}};
wire [15:0] lt24_lcd_cmd_param_read    = lcd_cmd_param_o            & {16{reg_rd[LT24_LCD_CMD_PARAM   ]}};
wire [15:0] lt24_lcd_cmd_dfill_read    = lcd_cmd_dfill_o            & {16{reg_rd[LT24_LCD_CMD_DFILL   ]}};
wire [15:0] lt24_lcd_status_read       = lt24_lcd_status            & {16{reg_rd[LT24_LCD_STATUS      ]}};
wire [15:0] lt24_lcd_irq_read          = lt24_lcd_irq               & {16{reg_rd[LT24_LCD_IRQ         ]}};
wire [15:0] lt24_adc_cfg_read          = lt24_adc_cfg               & {16{reg_rd[LT24_ADC_CFG         ]}};
wire [15:0] lt24_adc_irq_read          = lt24_adc_irq               & {16{reg_rd[LT24_ADC_IRQ         ]}};
wire [15:0] lt24_adc_data_x_read       = lt24_adc_data_x            & {16{reg_rd[LT24_ADC_DATA_X      ]}};
wire [15:0] lt24_adc_data_y_read       = lt24_adc_data_y            & {16{reg_rd[LT24_ADC_DATA_Y      ]}};
wire [15:0] lt24_adc_coord_x_read      = lt24_adc_coord_x           & {16{reg_rd[LT24_ADC_COORD_X     ]}};
wire [15:0] lt24_adc_coord_y_read      = lt24_adc_coord_y           & {16{reg_rd[LT24_ADC_COORD_Y     ]}};

wire [15:0] per_dout_o                 = lt24_lcd_cfg_read          |
                                         lt24_lcd_refresh_read      |
                                         lt24_lcd_refresh_sync_read |
                                         lt24_lcd_cmd_read          |
                                         lt24_lcd_cmd_param_read    |
                                         lt24_lcd_cmd_dfill_read    |
                                         lt24_lcd_status_read       |
                                         lt24_lcd_irq_read          |
                                         lt24_adc_cfg_read          |
                                         lt24_adc_irq_read          |
                                         lt24_adc_data_x_read       |
                                         lt24_adc_data_y_read       |
                                         lt24_adc_coord_x_read      |
                                         lt24_adc_coord_y_read      ;

endmodule // ogfx_if_lt24_reg

`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_undefines.v"
`endif
