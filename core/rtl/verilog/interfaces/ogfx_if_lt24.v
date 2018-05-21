//----------------------------------------------------------------------------
// Copyright (C) 2018 Authors
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
// *File Name: ogfx_if_lt24.v
//
// *Module Description:
//                      Interface to the LT24 LCD display.
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

module  ogfx_if_lt24 (

// Clock & Reset
    mclk                                           ,    // Main system clock
    puc_rst                                        ,    // Main system reset

// Peripheral Interface
    per_addr_i                                     ,    // Peripheral address
    per_en_i                                       ,    // Peripheral enable (high active)
    per_we_i                                       ,    // Peripheral write enable (high active)
    per_din_i                                      ,    // Peripheral data input
    per_dout_o                                     ,    // Peripheral data output

    irq_lt24_lcd_o                                 ,    // LT24 LCD interface interrupt
    irq_lt24_adc_o                                 ,    // LT24 ADC interface interrupt

// LT24 LCD Interface
    lt24_lcd_d_i                                   ,    // LT24 LCD Data input
    lt24_lcd_cs_n_o                                ,    // LT24 LCD Chip select (Active low)
    lt24_lcd_rd_n_o                                ,    // LT24 LCD Read strobe (Active low)
    lt24_lcd_wr_n_o                                ,    // LT24 LCD Write strobe (Active low)
    lt24_lcd_rs_o                                  ,    // LT24 LCD Command/Param selection (Cmd=0/Param=1)
    lt24_lcd_d_o                                   ,    // LT24 LCD Data output
    lt24_lcd_d_en_o                                ,    // LT24 LCD Data output enable
    lt24_lcd_reset_n_o                             ,    // LT24 LCD Reset (Active Low)
    lt24_lcd_on_o                                  ,    // LT24 LCD on/off

// LT24 ADC Interface
    lt24_adc_busy_i                                ,    // LT24 ADC Busy
    lt24_adc_dout_i                                ,    // LT24 ADC Data Out
    lt24_adc_penirq_n_i                            ,    // LT24 ADC Pen Interrupt
    lt24_adc_cs_n_o                                ,    // LT24 ADC Chip Select
    lt24_adc_dclk_o                                ,    // LT24 ADC Clock
    lt24_adc_din_o                                 ,    // LT24 ADC Data In

// openGFX430 Interface
    screen_display_size_i                          ,    // Display size configuration (number of pixels)
    screen_refresh_data_i                          ,    // Display refresh data
    screen_refresh_data_ready_i                    ,    // Display refresh new data is ready
    screen_refresh_data_request_o                  ,    // Display refresh new data request
    screen_refresh_active_o                             // Display refresh on going
);

// PARAMETERs
parameter     [14:0] BASE_ADDR = 15'h0280          ;    // Register base address
                                                        //  - 5 LSBs must stay cleared: 0x0020, 0x0040,
                                                        //                              0x0060, 0x0080,
                                                        //                              0x00A0, ...

// Clock & Reset
input                mclk                          ;    // Main system clock
input                puc_rst                       ;    // Main system reset

// Peripheral Interface
input         [13:0] per_addr_i                    ;    // Peripheral address
input         [15:0] per_din_i                     ;    // Peripheral data input
input                per_en_i                      ;    // Peripheral enable (high active)
input          [1:0] per_we_i                      ;    // Peripheral write enable (high active)
output        [15:0] per_dout_o                    ;    // Peripheral data output

output               irq_lt24_lcd_o                ;    // LT24 LCD interface interrupt
output               irq_lt24_adc_o                ;    // LT24 ADC interface interrupt

// LT24 Interface
input         [15:0] lt24_lcd_d_i                  ;    // LT24 LCD Data input
output               lt24_lcd_cs_n_o               ;    // LT24 LCD Chip select (Active low)
output               lt24_lcd_rd_n_o               ;    // LT24 LCD Read strobe (Active low)
output               lt24_lcd_wr_n_o               ;    // LT24 LCD Write strobe (Active low)
output               lt24_lcd_rs_o                 ;    // LT24 LCD Command/Param selection (Cmd=0/Param=1)
output        [15:0] lt24_lcd_d_o                  ;    // LT24 LCD Data output
output               lt24_lcd_d_en_o               ;    // LT24 LCD Data output enable
output               lt24_lcd_reset_n_o            ;    // LT24 LCD Reset (Active Low)
output               lt24_lcd_on_o                 ;    // LT24 LCD on/off

// LT24 ADC Interface
input                lt24_adc_busy_i               ;    // LT24 ADC Busy
input                lt24_adc_dout_i               ;    // LT24 ADC Data Out
input                lt24_adc_penirq_n_i           ;    // LT24 ADC Pen Interrupt
output               lt24_adc_cs_n_o               ;    // LT24 ADC Chip Select
output               lt24_adc_dclk_o               ;    // LT24 ADC Clock
output               lt24_adc_din_o                ;    // LT24 ADC Data In

// openGFX430 Interface
input  [`SPIX_MSB:0] screen_display_size_i         ;    // Display size configuration (number of pixels)
input         [15:0] screen_refresh_data_i         ;    // Display refresh data
input                screen_refresh_data_ready_i   ;    // Display refresh new data is ready
output               screen_refresh_data_request_o ;    // Display refresh new data request
output               screen_refresh_active_o       ;    // Display refresh on going


//=============================================================================
// 1)  WIRE, REGISTERS AND PARAMETER DECLARATION
//=============================================================================

// Configuration, control and status registers
wire           [2:0] lcd_cfg_clk                   ;           
wire          [14:0] lcd_cfg_refr                  ;          
wire                 lcd_cfg_refr_sync_en          ;  
wire           [9:0] lcd_cfg_refr_sync_val         ; 
wire                 lcd_cmd_refresh               ;          
wire           [7:0] lcd_cmd_val                   ;           
wire                 lcd_cmd_has_param             ;     
wire          [15:0] lcd_cmd_param_val             ;         
wire                 lcd_cmd_param_trig            ;     
wire          [15:0] lcd_cmd_dfill                 ;         
wire                 lcd_cmd_dfill_trig            ;      
wire           [4:0] lcd_status                    ;            
wire                 lcd_start_evt                 ;         
wire                 lcd_done_evt                  ;          

// State machine registers
reg            [4:0] lcd_state                     ;
reg            [4:0] lcd_state_nxt                 ;
reg            [2:0] adc_state_nxt                 ;
reg            [2:0] adc_state                     ;

// Others
reg                  refresh_trigger               ;
wire                 status_gts_match              ;
wire                 unused_lt24_adc_busy          ;
wire                 adc_penirq_detect             ;
wire                 trigger_adc_get_coordinate_set;
wire                 trigger_adc_get_coordinate_clr;
wire                 adc_penirq_sync               ;
reg                  adc_penirq_sync_dly           ;
reg                  trigger_adc_get_coordinate    ;
wire                 adc_enabled                   ;
wire           [7:0] adc_cfg_clk                   ;
wire                 adc_coord_y_swap              ;
wire                 adc_coord_x_swap              ;
wire                 adc_coord_cl_swap             ;
wire                 adc_cmd_done                  ;
wire                 adc_data_done                 ;
reg                  adc_done_evt                  ;
reg           [11:0] adc_x_data                    ;
reg           [11:0] adc_y_data                    ;
reg            [8:0] adc_clk_cnt                   ;
reg           [15:0] adc_bit_cnt                   ;
wire                 init_adc_bit_cnt_8bit         ;
wire                 init_adc_bit_cnt_16bit        ;
wire                 adc_x_data_ready              ;
wire                 adc_y_data_ready              ;
wire           [8:0] adc_clk_cnt_dec               ;
wire          [11:0] adc_data_nxt                  ;
reg                  lt24_adc_cs_n_o               ;
reg                  lt24_adc_dclk_o               ;
reg           [15:0] lt24_adc_data_shifter         ;
wire          [20:0] adc_x_coord_full_res          ;
wire           [8:0] adc_x_coord_round             ;
wire           [8:0] adc_x_coord_swapped           ;
wire           [8:0] adc_x_coord_pre               ;
wire           [8:0] adc_x_coord                   ;
wire          [20:0] adc_y_coord_full_res          ;
wire           [8:0] adc_y_coord_round             ;
wire           [8:0] adc_y_coord_swapped           ;
wire           [8:0] adc_y_coord_pre               ;
wire           [8:0] adc_y_coord                   ;


// LCD State definition
parameter            LCD_IDLE                =   0 ,    // IDLE state

                     LCD_CMD_LO              =   1 ,    // Generic command to LT24
                     LCD_CMD_HI              =   2 ,
                     LCD_CMD_PARAM_LO        =   3 ,
                     LCD_CMD_PARAM_HI        =   4 ,
                     LCD_CMD_PARAM_WAIT      =   5 ,

                     LCD_RAMWR_INIT_CMD_LO   =   6 ,    // Initialize display buffer with data
                     LCD_RAMWR_INIT_CMD_HI   =   7 ,
                     LCD_RAMWR_INIT_DATA_LO  =   8 ,
                     LCD_RAMWR_INIT_DATA_HI  =   9 ,

                     LCD_SCANLINE_CMD_LO     =  10 ,    // Wait for right scanline
                     LCD_SCANLINE_CMD_HI     =  11 ,
                     LCD_SCANLINE_DUMMY_LO   =  12 ,
                     LCD_SCANLINE_DUMMY_HI   =  13 ,
                     LCD_SCANLINE_GTS1_LO    =  14 ,
                     LCD_SCANLINE_GTS1_HI    =  15 ,
                     LCD_SCANLINE_GTS2_LO    =  16 ,
                     LCD_SCANLINE_GTS2_HI    =  17 ,

                     LCD_RAMWR_REFR_CMD_LO   =  18 ,    // Refresh display buffer
                     LCD_RAMWR_REFR_CMD_HI   =  19 ,
                     LCD_RAMWR_REFR_WAIT     =  20 ,
                     LCD_RAMWR_REFR_DATA_LO  =  21 ,
                     LCD_RAMWR_REFR_DATA_HI  =  22 ;

// ADC State definition
parameter            ADC_IDLE                =   0 ,    // IDLE state

                     ADC_WAIT_PENIRQ         =   1 ,    // Pen IRQ detection

                     ADC_X_COORD_CMD         =   2 ,    // X-coordinate
                     ADC_X_COORD_DATA        =   3 ,

                     ADC_Y_COORD_CMD         =   4 ,    // Y-coordinate
                     ADC_Y_COORD_DATA        =   5 ;


//============================================================================
// 2) REGISTER INTERFACE
//============================================================================

ogfx_if_lt24_reg #(.BASE_ADDR(BASE_ADDR)) ogfx_if_lt24_reg_inst (

// OUTPUTs
    .irq_adc_o                ( irq_lt24_adc_o         ),  // LT24 ADC interface interrupt
    .irq_lcd_o                ( irq_lt24_lcd_o         ),  // LT24 LCD interface interrupt

    .lcd_reset_n_o            ( lt24_lcd_reset_n_o     ),  // LT24 LCD Reset (Active Low)
    .lcd_on_o                 ( lt24_lcd_on_o          ),  // LT24 LCD on/off
    .lcd_cfg_clk_o            ( lcd_cfg_clk            ),  // LT24 LCD Interface clock configuration
    .lcd_cfg_refr_o           ( lcd_cfg_refr           ),  // LT24 LCD Interface refresh configuration
    .lcd_cfg_refr_sync_en_o   ( lcd_cfg_refr_sync_en   ),  // LT24 LCD Interface refresh sync enable configuration
    .lcd_cfg_refr_sync_val_o  ( lcd_cfg_refr_sync_val  ),  // LT24 LCD Interface refresh sync value configuration
    .lcd_cmd_refr_o           ( lcd_cmd_refresh        ),  // LT24 LCD Interface refresh command
    .lcd_cmd_val_o            ( lcd_cmd_val            ),  // LT24 LCD Generic command value
    .lcd_cmd_has_param_o      ( lcd_cmd_has_param      ),  // LT24 LCD Generic command has parameters
    .lcd_cmd_param_o          ( lcd_cmd_param_val      ),  // LT24 LCD Generic command parameter value
    .lcd_cmd_param_rdy_o      ( lcd_cmd_param_trig     ),  // LT24 LCD Generic command trigger
    .lcd_cmd_dfill_o          ( lcd_cmd_dfill          ),  // LT24 LCD Data fill value
    .lcd_cmd_dfill_wr_o       ( lcd_cmd_dfill_trig     ),  // LT24 LCD Data fill trigger

    .adc_enabled_o            ( adc_enabled            ),  // LT24 ADC Enabled
    .adc_cfg_clk_o            ( adc_cfg_clk            ),  // LT24 ADC Clock configuration
    .adc_coord_y_swap_o       ( adc_coord_y_swap       ),  // LT24 Coordinates: swap Y axis (horizontal symmetry)
    .adc_coord_x_swap_o       ( adc_coord_x_swap       ),  // LT24 Coordinates: swap X axis (vertical symmetry)
    .adc_coord_cl_swap_o      ( adc_coord_cl_swap      ),  // LT24 Coordinates: swap column/lines

    .per_dout_o               ( per_dout_o             ),  // Peripheral data output

// INPUTs
    .mclk                     ( mclk                   ),  // Main system clock
    .puc_rst                  ( puc_rst                ),  // Main system reset

    .lcd_status_i             ( lcd_status             ),  // LT24 LCD FSM Status
    .lcd_start_evt_i          ( lcd_start_evt          ),  // LT24 LCD FSM is starting
    .lcd_done_evt_i           ( lcd_done_evt           ),  // LT24 LCD FSM is done
    .lcd_uflow_evt_i          ( 1'b0                   ),  // LT24 LCD refresh underfow

    .adc_done_evt_i           ( adc_done_evt           ),  // LT24 ADC FSM is done
    .adc_x_data_i             ( adc_x_data             ),  // LT24 ADC X sampled data
    .adc_y_data_i             ( adc_y_data             ),  // LT24 ADC Y sampled data
    .adc_x_coord_i            ( adc_x_coord            ),  // LT24 ADC X coordinate
    .adc_y_coord_i            ( adc_y_coord            ),  // LT24 ADC Y coordinate

    .per_addr_i               ( per_addr_i             ),  // Peripheral address
    .per_din_i                ( per_din_i              ),  // Peripheral data input
    .per_en_i                 ( per_en_i               ),  // Peripheral enable (high active)
    .per_we_i                 ( per_we_i               )   // Peripheral write enable (high active)
);


//============================================================================
// 3) STATE MACHINE INTERFACING WITH LCD INTERFACE
//============================================================================

//--------------------------------
// LT24 Controller Clock Timer
//--------------------------------
reg [3:0] lcd_timer;

wire      lcd_timer_done = lt24_lcd_d_en_o ? (lcd_timer == {1'b0, lcd_cfg_clk}) :
                                             (lcd_timer == {lcd_cfg_clk, 1'b0}) ; // Use slower timing for read accesses

wire      lcd_timer_run  = (lcd_state     != LCD_IDLE)            &
                           (lcd_state     != LCD_CMD_PARAM_WAIT)  &
                           (lcd_state     != LCD_RAMWR_REFR_WAIT) &
                           ~lcd_timer_done;

wire      lcd_timer_init =   (lcd_timer_done                       &                                             // Init if counter reaches limit:
                           !((lcd_state    == LCD_CMD_PARAM_HI)    & lcd_cmd_has_param)  &                       //    -> if not moving to STATE_CMD_PARAM_WAIT
                           !((lcd_state    == LCD_CMD_PARAM_WAIT)))                      |                       //    -> if not in STATE_CMD_PARAM_WAIT
                            ((lcd_state    == LCD_CMD_PARAM_WAIT)  & (lcd_cmd_param_trig | ~lcd_cmd_has_param)); // Init when leaving the STATE_CMD_PARAM_WAIT state

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)             lcd_timer <= 4'h0;
  else if (lcd_timer_init) lcd_timer <= 4'h0;
  else if (lcd_timer_run)  lcd_timer <= lcd_timer+4'h1;


//--------------------------------
// Pixel counter
//--------------------------------
reg [`SPIX_MSB:0] lcd_pixel_cnt;

wire              lcd_pixel_cnt_run  = (lcd_state==LCD_RAMWR_INIT_DATA_HI) |
                                       (lcd_state==LCD_RAMWR_REFR_DATA_HI);

wire              lcd_pixel_cnt_done = (lcd_pixel_cnt==1) | (lcd_pixel_cnt==0);

wire              lcd_pixel_cnt_init = (lcd_state==LCD_RAMWR_INIT_CMD_HI) |
                                       (lcd_state==LCD_RAMWR_REFR_CMD_HI) |
                                       (lcd_pixel_cnt_done & lcd_pixel_cnt_run);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                     lcd_pixel_cnt <= {`SPIX_MSB+1{1'h0}};
  else if (lcd_timer_init)
    begin
       if (lcd_pixel_cnt_init)     lcd_pixel_cnt <= screen_display_size_i;
       else if (lcd_pixel_cnt_run) lcd_pixel_cnt <= lcd_pixel_cnt-{{`SPIX_MSB{1'h0}},1'b1};
    end


//--------------------------------
// States Transitions
//--------------------------------
always @(lcd_state or lcd_cmd_dfill_trig or lcd_cmd_param_trig or refresh_trigger or lcd_cfg_refr_sync_en or status_gts_match or screen_refresh_data_request_o or lcd_cmd_has_param or lcd_timer_done or lcd_pixel_cnt_done)
    case(lcd_state)
      LCD_IDLE               :  lcd_state_nxt =  lcd_cmd_dfill_trig            ? LCD_RAMWR_INIT_CMD_LO  :
                                                 refresh_trigger               ?
                                                (lcd_cfg_refr_sync_en          ? LCD_SCANLINE_CMD_LO    : LCD_RAMWR_REFR_CMD_LO) :
                                                 lcd_cmd_param_trig            ? LCD_CMD_LO             : LCD_IDLE               ;

      // GENERIC COMMANDS
      LCD_CMD_LO             :  lcd_state_nxt = ~lcd_timer_done                ? LCD_CMD_LO             : LCD_CMD_HI             ;
      LCD_CMD_HI             :  lcd_state_nxt = ~lcd_timer_done                ? LCD_CMD_HI             :
                                                 lcd_cmd_has_param             ? LCD_CMD_PARAM_LO       : LCD_IDLE               ;

      LCD_CMD_PARAM_LO       :  lcd_state_nxt = ~lcd_timer_done                ? LCD_CMD_PARAM_LO       : LCD_CMD_PARAM_HI       ;
      LCD_CMD_PARAM_HI       :  lcd_state_nxt = ~lcd_timer_done                ? LCD_CMD_PARAM_HI       :
                                                 lcd_cmd_has_param             ? LCD_CMD_PARAM_WAIT     : LCD_IDLE               ;

      LCD_CMD_PARAM_WAIT     :  lcd_state_nxt =  lcd_cmd_param_trig            ? LCD_CMD_PARAM_LO       :
                                                 lcd_cmd_has_param             ? LCD_CMD_PARAM_WAIT     : LCD_IDLE               ;

      // MEMORY INITIALIZATION
      LCD_RAMWR_INIT_CMD_LO  :  lcd_state_nxt = ~lcd_timer_done                ? LCD_RAMWR_INIT_CMD_LO  : LCD_RAMWR_INIT_CMD_HI  ;
      LCD_RAMWR_INIT_CMD_HI  :  lcd_state_nxt = ~lcd_timer_done                ? LCD_RAMWR_INIT_CMD_HI  : LCD_RAMWR_INIT_DATA_LO ;

      LCD_RAMWR_INIT_DATA_LO :  lcd_state_nxt = ~lcd_timer_done                ? LCD_RAMWR_INIT_DATA_LO : LCD_RAMWR_INIT_DATA_HI ;
      LCD_RAMWR_INIT_DATA_HI :  lcd_state_nxt = (lcd_timer_done     &
                                                 lcd_pixel_cnt_done)           ? LCD_IDLE               :
                                                ~lcd_timer_done                ? LCD_RAMWR_INIT_DATA_HI : LCD_RAMWR_INIT_DATA_LO ;

      // WAIT FOR RIGHT SCANLINE BEFORE REFRESH
      LCD_SCANLINE_CMD_LO    :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_CMD_LO    : LCD_SCANLINE_CMD_HI    ;
      LCD_SCANLINE_CMD_HI    :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_CMD_HI    : LCD_SCANLINE_DUMMY_LO  ;

      LCD_SCANLINE_DUMMY_LO  :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_DUMMY_LO  : LCD_SCANLINE_DUMMY_HI  ;
      LCD_SCANLINE_DUMMY_HI  :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_DUMMY_HI  : LCD_SCANLINE_GTS1_LO   ;

      LCD_SCANLINE_GTS1_LO   :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_GTS1_LO   : LCD_SCANLINE_GTS1_HI   ;
      LCD_SCANLINE_GTS1_HI   :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_GTS1_HI   : LCD_SCANLINE_GTS2_LO   ;

      LCD_SCANLINE_GTS2_LO   :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_GTS2_LO   : LCD_SCANLINE_GTS2_HI   ;
      LCD_SCANLINE_GTS2_HI   :  lcd_state_nxt = ~lcd_timer_done                ? LCD_SCANLINE_GTS2_HI   :
                                                (status_gts_match |
                                                ~lcd_cfg_refr_sync_en)         ? LCD_RAMWR_REFR_CMD_LO  : LCD_SCANLINE_CMD_LO    ;

      // FRAME REFRESH
      LCD_RAMWR_REFR_CMD_LO  :  lcd_state_nxt = ~lcd_timer_done                ? LCD_RAMWR_REFR_CMD_LO  : LCD_RAMWR_REFR_CMD_HI  ;
      LCD_RAMWR_REFR_CMD_HI  :  lcd_state_nxt = ~lcd_timer_done                ? LCD_RAMWR_REFR_CMD_HI  :
                                                ~screen_refresh_data_request_o ? LCD_RAMWR_REFR_DATA_LO : LCD_RAMWR_REFR_WAIT    ;

      LCD_RAMWR_REFR_WAIT    :  lcd_state_nxt = ~screen_refresh_data_request_o ? LCD_RAMWR_REFR_DATA_LO : LCD_RAMWR_REFR_WAIT    ;

      LCD_RAMWR_REFR_DATA_LO :  lcd_state_nxt = ~lcd_timer_done                ? LCD_RAMWR_REFR_DATA_LO : LCD_RAMWR_REFR_DATA_HI ;
      LCD_RAMWR_REFR_DATA_HI :  lcd_state_nxt = (lcd_timer_done     &
                                                 lcd_pixel_cnt_done)           ? LCD_IDLE               :
                                                ~lcd_timer_done                ? LCD_RAMWR_REFR_DATA_HI :
                                                ~screen_refresh_data_request_o ? LCD_RAMWR_REFR_DATA_LO : LCD_RAMWR_REFR_WAIT    ;

    // pragma coverage off
      default                :  lcd_state_nxt =  LCD_IDLE;
    // pragma coverage on
    endcase

// State machine
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lcd_state  <= LCD_IDLE;
  else         lcd_state  <= lcd_state_nxt;


// Output status
assign   lcd_status[0]            =  (lcd_state != LCD_IDLE);                                                         // LT24 FSM BUSY

assign   lcd_status[1]            =  (lcd_state == LCD_CMD_PARAM_WAIT);                                               // LT24 Waits for command parameter

assign   lcd_status[2]            =  (lcd_state == LCD_RAMWR_REFR_CMD_LO)  | (lcd_state == LCD_RAMWR_REFR_CMD_HI)  |  // LT24 REFRESH BUSY
                                     (lcd_state == LCD_RAMWR_REFR_DATA_LO) | (lcd_state == LCD_RAMWR_REFR_DATA_HI) |
                                     (lcd_state == LCD_RAMWR_REFR_WAIT);

assign   lcd_status[3]            =  (lcd_state == LCD_SCANLINE_CMD_LO)    | (lcd_state == LCD_SCANLINE_CMD_HI)    |  // LT24 WAIT FOR SCANLINE
                                     (lcd_state == LCD_SCANLINE_DUMMY_LO)  | (lcd_state == LCD_SCANLINE_DUMMY_HI)  |
                                     (lcd_state == LCD_SCANLINE_GTS1_LO)   | (lcd_state == LCD_SCANLINE_GTS1_HI)   |
                                     (lcd_state == LCD_SCANLINE_GTS2_LO)   | (lcd_state == LCD_SCANLINE_GTS2_HI);

assign   lcd_status[4]            =  (lcd_state == LCD_RAMWR_INIT_CMD_LO)  | (lcd_state == LCD_RAMWR_INIT_CMD_HI)  |  // LT24 INIT BUSY
                                     (lcd_state == LCD_RAMWR_INIT_DATA_LO) | (lcd_state == LCD_RAMWR_INIT_DATA_HI);

assign   screen_refresh_active_o  =   lcd_status[2];


// Refresh data request
wire     refresh_data_request_set = ((lcd_state == LCD_RAMWR_REFR_CMD_LO)  & (lcd_state_nxt == LCD_RAMWR_REFR_CMD_HI))  |
                                    ((lcd_state == LCD_RAMWR_REFR_DATA_LO) & (lcd_state_nxt == LCD_RAMWR_REFR_DATA_HI)) |
                                     (lcd_state == LCD_RAMWR_REFR_WAIT);
wire     refresh_data_request_clr = screen_refresh_data_ready_i;
reg      refresh_data_request_reg;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) refresh_data_request_reg <= 1'b0;
  else         refresh_data_request_reg <= refresh_data_request_clr ? 1'b0 :
                                           refresh_data_request_set ? 1'b1 : refresh_data_request_reg;

assign   screen_refresh_data_request_o = refresh_data_request_reg & ~screen_refresh_data_ready_i;

assign   lcd_start_evt                 = (lcd_state_nxt != LCD_IDLE) & (lcd_state     == LCD_IDLE);
assign   lcd_done_evt                  = (lcd_state     != LCD_IDLE) & (lcd_state_nxt == LCD_IDLE);


//============================================================================
// 4) LT24 LCD CONTROLLER OUTPUT ASSIGNMENT
//============================================================================

// LT24 Chip select (active low)
reg  lt24_lcd_cs_n_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_lcd_cs_n_o <= 1'b1;
  else         lt24_lcd_cs_n_o <= (lcd_state_nxt==LCD_IDLE);

// Command (0) or Data (1)
reg  lt24_lcd_rs_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_lcd_rs_o   <= 1'b1;
  else         lt24_lcd_rs_o   <= ~((lcd_state_nxt==LCD_CMD_LO)            | (lcd_state_nxt==LCD_CMD_HI)            |
                                    (lcd_state_nxt==LCD_SCANLINE_CMD_LO)   | (lcd_state_nxt==LCD_SCANLINE_CMD_HI)   |
                                    (lcd_state_nxt==LCD_RAMWR_INIT_CMD_LO) | (lcd_state_nxt==LCD_RAMWR_INIT_CMD_HI) |
                                    (lcd_state_nxt==LCD_RAMWR_REFR_CMD_LO) | (lcd_state_nxt==LCD_RAMWR_REFR_CMD_HI));

// LT24 Write strobe (Active low)
reg  lt24_lcd_wr_n_o;

wire lt24_lcd_wr_n_clr = (lcd_state_nxt==LCD_CMD_LO)            | (lcd_state_nxt==LCD_CMD_PARAM_LO)       | (lcd_state_nxt==LCD_SCANLINE_CMD_LO) |
                         (lcd_state_nxt==LCD_RAMWR_INIT_CMD_LO) | (lcd_state_nxt==LCD_RAMWR_INIT_DATA_LO) |
                         (lcd_state_nxt==LCD_RAMWR_REFR_CMD_LO) | (lcd_state_nxt==LCD_RAMWR_REFR_DATA_LO);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                 lt24_lcd_wr_n_o <= 1'b1;
  else if (lt24_lcd_wr_n_clr)  lt24_lcd_wr_n_o <= 1'b0;
  else                         lt24_lcd_wr_n_o <= 1'b1;

// LT24 Read strobe (active low)
reg  lt24_lcd_rd_n_o;

wire lt24_lcd_rd_n_clr = (lcd_state_nxt==LCD_SCANLINE_DUMMY_LO) |
                         (lcd_state_nxt==LCD_SCANLINE_GTS1_LO)  | (lcd_state_nxt==LCD_SCANLINE_GTS2_LO);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                 lt24_lcd_rd_n_o <= 1'b1;
  else if (lt24_lcd_rd_n_clr)  lt24_lcd_rd_n_o <= 1'b0;
  else                         lt24_lcd_rd_n_o <= 1'b1;


// LT24 Data
reg [15:0] lt24_lcd_d_nxt;
always @(lcd_state_nxt or lcd_cmd_val or lcd_cmd_param_val or lt24_lcd_d_o or lcd_cmd_dfill or screen_refresh_data_i)
  case(lcd_state_nxt)
    LCD_IDLE               : lt24_lcd_d_nxt = 16'h0000;

    LCD_CMD_LO,
    LCD_CMD_HI             : lt24_lcd_d_nxt = {8'h00, lcd_cmd_val};
    LCD_CMD_PARAM_LO,
    LCD_CMD_PARAM_HI       : lt24_lcd_d_nxt = lcd_cmd_param_val;
    LCD_CMD_PARAM_WAIT     : lt24_lcd_d_nxt = lt24_lcd_d_o;

    LCD_RAMWR_INIT_CMD_LO,
    LCD_RAMWR_INIT_CMD_HI  : lt24_lcd_d_nxt = 16'h002C;
    LCD_RAMWR_INIT_DATA_LO,
    LCD_RAMWR_INIT_DATA_HI : lt24_lcd_d_nxt = lcd_cmd_dfill;

    LCD_SCANLINE_CMD_LO,
    LCD_SCANLINE_CMD_HI    : lt24_lcd_d_nxt = 16'h0045;

    LCD_RAMWR_REFR_CMD_LO,
    LCD_RAMWR_REFR_CMD_HI  : lt24_lcd_d_nxt = 16'h002C;
    LCD_RAMWR_REFR_DATA_LO : lt24_lcd_d_nxt = screen_refresh_data_i;
    LCD_RAMWR_REFR_DATA_HI : lt24_lcd_d_nxt = lt24_lcd_d_o;
    LCD_RAMWR_REFR_WAIT    : lt24_lcd_d_nxt = lt24_lcd_d_o;

    // pragma coverage off
    default                : lt24_lcd_d_nxt = 16'h0000;
    // pragma coverage on
  endcase

reg [15:0] lt24_lcd_d_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_lcd_d_o <= 16'h0000;
  else         lt24_lcd_d_o <= lt24_lcd_d_nxt;

// Output enable
reg lt24_lcd_d_en_o;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) lt24_lcd_d_en_o <= 1'h0;       // Don't drive output during reset
  else         lt24_lcd_d_en_o <= ~((lcd_state_nxt == LCD_SCANLINE_DUMMY_LO) |
                                    (lcd_state_nxt == LCD_SCANLINE_DUMMY_HI) |
                                    (lcd_state_nxt == LCD_SCANLINE_GTS1_LO ) |
                                    (lcd_state_nxt == LCD_SCANLINE_GTS1_HI ) |
                                    (lcd_state_nxt == LCD_SCANLINE_GTS2_LO ) |
                                    (lcd_state_nxt == LCD_SCANLINE_GTS2_HI ));


//============================================================================
// 5) LT24 LCD GTS VALUE (i.e. CURRENT SCAN LINE)
//============================================================================

reg  [1:0] status_gts_msb;
wire       status_gts_msb_wr  = ((lcd_state == LCD_SCANLINE_GTS1_LO) & (lcd_state_nxt == LCD_SCANLINE_GTS1_HI));
always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                status_gts_msb <= 2'h0;
  else if (status_gts_msb_wr) status_gts_msb <= lt24_lcd_d_i[1:0];

reg  [7:0] status_gts_lsb;
wire       status_gts_lsb_wr  = ((lcd_state == LCD_SCANLINE_GTS2_LO) & (lcd_state_nxt == LCD_SCANLINE_GTS2_HI));
always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                status_gts_lsb <= 8'h00;
  else if (status_gts_lsb_wr) status_gts_lsb <= lt24_lcd_d_i[7:0];

wire [7:0] unused_lt24_d_15_8 = lt24_lcd_d_i[15:8];
wire [9:0] status_gts         = {status_gts_msb, status_gts_lsb};

assign     status_gts_match   = (status_gts == lcd_cfg_refr_sync_val);


//============================================================================
// 6) LCD REFRESH TIMER & TRIGGER
//============================================================================

// Refresh Timer
reg [23:0] refresh_timer;
wire       refresh_timer_disable = (lcd_cfg_refr==15'h0000) | ~lcd_cmd_refresh;
wire       refresh_timer_done    = (refresh_timer[23:9]==lcd_cfg_refr);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                    refresh_timer <= 24'h000000;
  else if (refresh_timer_disable) refresh_timer <= 24'h000000;
  else if (refresh_timer_done)    refresh_timer <= 24'h000000;
  else                            refresh_timer <= refresh_timer + 24'h1;

// Refresh Trigger
wire       refresh_trigger_set = (lcd_state==LCD_IDLE) & lcd_cmd_refresh & (refresh_timer==24'h000000);
wire       refresh_trigger_clr = (lcd_state==LCD_RAMWR_REFR_CMD_LO);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                  refresh_trigger <= 1'b0;
  else if (refresh_trigger_set) refresh_trigger <= 1'b1;
  else if (refresh_trigger_clr) refresh_trigger <= 1'b0;


//============================================================================
// 7) ADC INTERFACE
//============================================================================

// Unused signals from ADC interface
assign unused_lt24_adc_busy =  lt24_adc_busy_i;

// Pen IRQ synchronizer
ogfx_sync_cell ogfx_sync_cell_inst (
    .data_out  (  adc_penirq_sync                   ),
    .data_in   ( ~lt24_adc_penirq_n_i & adc_enabled ),
    .clk       (  mclk                              ),
    .rst       (  puc_rst                           )
);


// Pen IRQ detection
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) adc_penirq_sync_dly   <= 1'b0;
  else         adc_penirq_sync_dly   <= adc_penirq_sync & adc_enabled;

assign adc_penirq_detect              = (~adc_penirq_sync_dly & adc_penirq_sync & adc_enabled);


// Trigger ADC conversion
assign trigger_adc_get_coordinate_set = adc_penirq_detect;
assign trigger_adc_get_coordinate_clr = (adc_state==ADC_WAIT_PENIRQ) & (adc_state_nxt==ADC_X_COORD_CMD);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                             trigger_adc_get_coordinate <= 1'b0;
  else if (~adc_enabled)                   trigger_adc_get_coordinate <= 1'b0;
  else if (trigger_adc_get_coordinate_set) trigger_adc_get_coordinate <= 1'b1;
  else if (trigger_adc_get_coordinate_clr) trigger_adc_get_coordinate <= 1'b0;


// ADC State machine
always @(adc_state or adc_enabled or trigger_adc_get_coordinate or adc_cmd_done or adc_data_done)
  case(adc_state)
    ADC_IDLE               : adc_state_nxt = ~adc_enabled                ? ADC_IDLE         :
                                                                           ADC_WAIT_PENIRQ  ;

    ADC_WAIT_PENIRQ        : adc_state_nxt = ~adc_enabled                ? ADC_IDLE         :
                                              trigger_adc_get_coordinate ? ADC_X_COORD_CMD  :
                                                                           ADC_WAIT_PENIRQ  ;

    ADC_X_COORD_CMD        : adc_state_nxt =  adc_cmd_done               ? ADC_X_COORD_DATA :
                                                                           ADC_X_COORD_CMD  ;
    ADC_X_COORD_DATA       : adc_state_nxt =  adc_data_done              ? ADC_Y_COORD_CMD  :
                                                                           ADC_X_COORD_DATA ;

    ADC_Y_COORD_CMD        : adc_state_nxt =  adc_cmd_done               ? ADC_Y_COORD_DATA :
                                                                           ADC_Y_COORD_CMD  ;
    ADC_Y_COORD_DATA       : adc_state_nxt = ~adc_data_done              ? ADC_Y_COORD_DATA :
                                             ~adc_enabled                ? ADC_IDLE         :
                                                                           ADC_WAIT_PENIRQ  ;

    // pragma coverage off
    default                : adc_state_nxt =  ADC_IDLE;
    // pragma coverage on
  endcase

always @(posedge mclk or posedge puc_rst)
  if (puc_rst) adc_state  <= ADC_IDLE;
  else         adc_state  <= adc_state_nxt;


// ADC Clock counter
assign     adc_clk_cnt_dec = adc_clk_cnt-9'h001;
always @(posedge mclk or posedge puc_rst)
  if (puc_rst) adc_clk_cnt <= 9'h000;
  else if ((adc_bit_cnt != 16'h0000) | init_adc_bit_cnt_8bit | init_adc_bit_cnt_16bit)
    if (adc_clk_cnt == 9'h000)
      adc_clk_cnt <= {adc_cfg_clk, 1'b1} & {9{adc_bit_cnt != 16'h0001}};
    else
      adc_clk_cnt <= adc_clk_cnt_dec;
  else
      adc_clk_cnt <= 9'h000;


// Shifted Bit counter
assign  init_adc_bit_cnt_8bit  = ((adc_state==ADC_WAIT_PENIRQ)  & (adc_state_nxt==ADC_X_COORD_CMD))  |
                                 ((adc_state==ADC_X_COORD_DATA) & (adc_state_nxt==ADC_Y_COORD_CMD))  ;
assign  init_adc_bit_cnt_16bit = ((adc_state==ADC_X_COORD_CMD)  & (adc_state_nxt==ADC_X_COORD_DATA)) |
                                 ((adc_state==ADC_Y_COORD_CMD)  & (adc_state_nxt==ADC_Y_COORD_DATA)) ;

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                     adc_bit_cnt <= 16'h0000;
  else if (init_adc_bit_cnt_8bit)  adc_bit_cnt <= 16'h0080;
  else if (init_adc_bit_cnt_16bit) adc_bit_cnt <= 16'h8000;
  else if (adc_clk_cnt == 9'h000)  adc_bit_cnt <= {1'b0, adc_bit_cnt[15:1]};

assign  adc_cmd_done  = (adc_bit_cnt == 16'h0000) & ((adc_state==ADC_X_COORD_CMD ) | (adc_state==ADC_Y_COORD_CMD ));
assign  adc_data_done = (adc_bit_cnt == 16'h0000) & ((adc_state==ADC_X_COORD_DATA) | (adc_state==ADC_Y_COORD_DATA));


// LT24 ADC Chip Select
always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                                          lt24_adc_cs_n_o       <= 1'h1;
  else if (init_adc_bit_cnt_8bit)                       lt24_adc_cs_n_o       <= 1'h0;
  else if (adc_data_done & ~trigger_adc_get_coordinate) lt24_adc_cs_n_o       <= 1'h1;


// LT24 ADC Clock
always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                                          lt24_adc_dclk_o       <= 1'h0;
  else if (adc_clk_cnt_dec=={1'b0, adc_cfg_clk[7:0]})   lt24_adc_dclk_o       <= 1'h1;
  else if (adc_clk_cnt==9'h000)                         lt24_adc_dclk_o       <= 1'h0;


// LT24 ADC Data In
always @(posedge mclk or posedge puc_rst)
  if (puc_rst)                                          lt24_adc_data_shifter <= 16'h0000;
  else if (init_adc_bit_cnt_8bit)
    begin                                                                                  //  S A2 A1 A0 MODE SER/DFR PD1 PD0
      if (adc_state_nxt==ADC_X_COORD_CMD)               lt24_adc_data_shifter <= 16'h9200; //  1 0  0  1   0      0     1   0
      else if (adc_state_nxt==ADC_Y_COORD_CMD)          lt24_adc_data_shifter <= 16'hD200; //  1 1  0  1   0      0     1   0
    end
  else if ((adc_clk_cnt==9'h000)        &
           (adc_state!=ADC_IDLE)        &
           (adc_state!=ADC_WAIT_PENIRQ) )               lt24_adc_data_shifter <= {lt24_adc_data_shifter[14] & ((adc_state==ADC_X_COORD_CMD) | (adc_state==ADC_Y_COORD_CMD)),
                                                                                  lt24_adc_data_shifter[13:0],
                                                                                  lt24_adc_dout_i};
assign  lt24_adc_din_o   = lt24_adc_data_shifter[15];
assign  adc_data_nxt     = lt24_adc_data_shifter[14:3];


// LT24 Sampled ADC Data
assign  adc_x_data_ready = (adc_state==ADC_X_COORD_DATA) & (adc_state_nxt==ADC_Y_COORD_CMD);
assign  adc_y_data_ready = (adc_state==ADC_Y_COORD_DATA) & (adc_state_nxt==ADC_WAIT_PENIRQ);

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)               adc_x_data   <= 12'h000;
  else if (adc_x_data_ready) adc_x_data   <= adc_data_nxt;

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)               adc_y_data   <= 12'h000;
  else if (adc_y_data_ready) adc_y_data   <= adc_data_nxt;

always @(posedge mclk or posedge puc_rst)
  if (puc_rst)               adc_done_evt <= 1'b0;
  else                       adc_done_evt <= adc_y_data_ready;


// Coordinates
assign adc_x_coord_full_res = {         adc_x_data, 8'b00000000} +  //   256
                              {2'b00,   adc_x_data, 6'b000000  } ;  // +  64 
                                                                    // = 320
assign adc_x_coord_round    = adc_x_coord_full_res[20:12]+{8'h00, adc_x_coord_full_res[11]};
assign adc_x_coord_swapped  = 9'd319 - adc_x_coord_round;
assign adc_x_coord_pre      = adc_coord_x_swap  ? adc_x_coord_swapped : adc_x_coord_round;
assign adc_x_coord          = adc_coord_cl_swap ? adc_y_coord_pre     : adc_x_coord_pre;

assign adc_y_coord_full_res = {1'b0,    adc_y_data, 7'b0000000 } +  //   128
                              {2'b00,   adc_y_data, 6'b000000  } +  // +  64 
                              {3'b000,  adc_y_data, 5'b00000   } +  // +  32 
                              {4'b0000, adc_y_data, 4'b0000    } ;  // +  16 
                                                                    // = 240
assign adc_y_coord_round    = adc_y_coord_full_res[20:12]+{8'h00, adc_y_coord_full_res[11]};
assign adc_y_coord_swapped  = 9'd239 - adc_y_coord_round;
assign adc_y_coord_pre      = adc_coord_y_swap  ? adc_y_coord_swapped : adc_y_coord_round;
assign adc_y_coord          = adc_coord_cl_swap ? adc_x_coord_pre     : adc_y_coord_pre;


endmodule // ogfx_if_lt24

`ifdef OGFX_NO_INCLUDE
`else
`include "openGFX430_undefines.v"
`endif
