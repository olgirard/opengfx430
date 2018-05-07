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
// *File Name: register_def_openGFX430.v
//
// *Module Description:
//                      openGFX430 register and field definition
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 205 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2015-07-15 22:59:52 +0200 (Wed, 15 Jul 2015) $
//----------------------------------------------------------------------------

//----------------------------------------------------------
// GRAPHIC CONTROLLER REGISTERS
//----------------------------------------------------------
`define  R_GFX_CTRL                    16'h0200
`define  R_GFX_STATUS                  16'h0208
`define  R_GFX_IRQ                     16'h020A

`define  R_DISPLAY_WIDTH               16'h0210
`define  R_DISPLAY_HEIGHT              16'h0212
`define  R_DISPLAY_SIZE_LO             16'h0214
`define  R_DISPLAY_SIZE_HI             16'h0216
`define  R_DISPLAY_CFG                 16'h0218
`define  R_DISPLAY_REFR_CNT            16'h021A

`define  R_LT24_CFG                    16'h0220
`define  R_LT24_REFRESH                16'h0222
`define  R_LT24_REFRESH_SYNC           16'h0224
`define  R_LT24_CMD                    16'h0226
`define  R_LT24_CMD_PARAM              16'h0228
`define  R_LT24_CMD_DFILL              16'h022A
`define  R_LT24_STATUS                 16'h022C

`define  R_LUT_CFG                     16'h0230
`define  R_LUT_RAM_ADDR                16'h0232
`define  R_LUT_RAM_DATA                16'h0234

`define  R_FRAME_SELECT                16'h023E
`define  R_FRAME0_PTR                  16'h0240
`define  R_FRAME1_PTR                  16'h0244
`define  R_FRAME2_PTR                  16'h0248
`define  R_FRAME3_PTR                  16'h024C

`define  R_VID_RAM0_CFG                16'h0250
`define  R_VID_RAM0_WIDTH              16'h0252
`define  R_VID_RAM0_ADDR               16'h0254
`define  R_VID_RAM0_DATA               16'h0258

`define  R_VID_RAM1_CFG                16'h0260
`define  R_VID_RAM1_WIDTH              16'h0262
`define  R_VID_RAM1_ADDR               16'h0264
`define  R_VID_RAM1_DATA               16'h0268

`define  R_GPU_CMD                     16'h0270
`define  R_GPU_STAT                    16'h0274


//----------------------------------------------------------
// GRAPHIC CONTROLLER REGISTER FIELD MAPPING
//----------------------------------------------------------

// GFX_CTRL Register
`define  F_GFX_IRQ_EN_REFR_DONE        `R_GFX_CTRL          ,  0 , 16'h0001
`define  F_GFX_IRQ_EN_REFR_START       `R_GFX_CTRL          ,  1 , 16'h0002
`define  F_GFX_IRQ_EN_REFR_CNT_DONE    `R_GFX_CTRL          ,  2 , 16'h0004
`define  F_GFX_IRQ_EN_GPU_FIFO_DONE    `R_GFX_CTRL          ,  4 , 16'h0010
`define  F_GFX_IRQ_EN_GPU_FIFO_OVFL    `R_GFX_CTRL          ,  5 , 16'h0020
`define  F_GFX_IRQ_EN_GPU_CMD_DONE     `R_GFX_CTRL          ,  6 , 16'h0040
`define  F_GFX_IRQ_EN_GPU_CMD_ERROR    `R_GFX_CTRL          ,  7 , 16'h0080
`define  F_GFX_MODE                    `R_GFX_CTRL          ,  8 , 16'h0700
`define  F_GFX_GPU_EN                  `R_GFX_CTRL          , 12 , 16'h1000

// GFX_STATUS Register
`define  F_STATUS_REFRESH_BUSY         `R_GFX_STATUS        ,  0 , 16'h0001
`define  F_STATUS_GPU_FIFO             `R_GFX_STATUS        ,  4 , 16'h0010
`define  F_STATUS_GPU_BUSY             `R_GFX_STATUS        ,  6 , 16'h0040

// GFX_IRQ Register
`define  F_GFX_IRQ_REFRESH_DONE        `R_GFX_IRQ           ,  0 , 16'h0001
`define  F_GFX_IRQ_REFRESH_START       `R_GFX_IRQ           ,  1 , 16'h0002
`define  F_GFX_IRQ_REFRESH_CNT_DONE    `R_GFX_IRQ           ,  2 , 16'h0004
`define  F_GFX_IRQ_GPU_FIFO_DONE       `R_GFX_IRQ           ,  4 , 16'h0010
`define  F_GFX_IRQ_GPU_FIFO_OVFL       `R_GFX_IRQ           ,  5 , 16'h0020
`define  F_GFX_IRQ_GPU_CMD_DONE        `R_GFX_IRQ           ,  6 , 16'h0040
`define  F_GFX_IRQ_GPU_CMD_ERROR       `R_GFX_IRQ           ,  7 , 16'h0080

// DISPLAY_CFG Register
`define  F_DISPLAY_CL_SWAP             `R_DISPLAY_CFG       ,  0 , 16'h0001
`define  F_DISPLAY_Y_SWAP              `R_DISPLAY_CFG       ,  1 , 16'h0002
`define  F_DISPLAY_X_SWAP              `R_DISPLAY_CFG       ,  2 , 16'h0004

// LT24_CFG Register
`define  F_LT24_ON                     `R_LT24_CFG          ,  0 , 16'h0001
`define  F_LT24_RESET                  `R_LT24_CFG          ,  1 , 16'h0002
`define  F_LT24_CLK                    `R_LT24_CFG          ,  4 , 16'h0070

// LT24_REFRESH Register
`define  F_LT24_REFR_START             `R_LT24_REFRESH      ,  0 , 16'h0001
`define  F_LT24_REFR                   `R_LT24_REFRESH      ,  4 , 16'hFFF0

// LT24_REFRESH_SYNC Register
`define  F_LT24_REFR_SYNC              `R_LT24_REFRESH_SYNC ,  0 , 16'h03FF
`define  F_LT24_REFR_SYNC_EN           `R_LT24_REFRESH_SYNC , 15 , 16'h8000

// LT24_CMD Register
`define  F_LT24_CMD_MSK                `R_LT24_CMD          ,  0 , 16'h00FF
`define  F_LT24_CMD_HAS_PARAM          `R_LT24_CMD          ,  8 , 16'h0100

// LT24_STATUS Register
`define  F_LT24_STATUS_FSM_BUSY        `R_LT24_STATUS       ,  0 , 16'h0001
`define  F_LT24_STATUS_WAIT_PARAM      `R_LT24_STATUS       ,  1 , 16'h0002
`define  F_LT24_STATUS_REFRESH_BUSY    `R_LT24_STATUS       ,  2 , 16'h0004
`define  F_LT24_STATUS_REFRESH_WAIT    `R_LT24_STATUS       ,  3 , 16'h0008
`define  F_LT24_STATUS_DFILL_BUSY      `R_LT24_STATUS       ,  4 , 16'h0010

// LUT_CFG Register
`define  F_SW_LUT_ENABLE               `R_LUT_CFG           ,  0 , 16'h0001
`define  F_SW_LUT_RAM_RMW_MODE         `R_LUT_CFG           ,  1 , 16'h0002
`define  F_SW_LUT_BANK_SELECT          `R_LUT_CFG           ,  2 , 16'h0004
`define  F_HW_LUT_PALETTE              `R_LUT_CFG           ,  4 , 16'h0070
`define  F_HW_LUT_BGCOLOR              `R_LUT_CFG           ,  8 , 16'h0F00
`define  F_HW_LUT_FGCOLOR              `R_LUT_CFG           , 12 , 16'hF000

// FRAME_SELECT Register
`define  F_REFRESH_FRAME               `R_FRAME_SELECT      ,  0 , 16'h0003
`define  F_VID_RAM0_FRAME              `R_FRAME_SELECT      ,  8 , 16'h0300
`define  F_VID_RAM1_FRAME              `R_FRAME_SELECT      , 12 , 16'h3000

// VID_RAMx_CFG Register
`define  F_VID_RAM0_WIN_CL_SWAP        `R_VID_RAM0_CFG      ,  0 , 16'h0001
`define  F_VID_RAM0_WIN_Y_SWAP         `R_VID_RAM0_CFG      ,  1 , 16'h0002
`define  F_VID_RAM0_WIN_X_SWAP         `R_VID_RAM0_CFG      ,  2 , 16'h0004
`define  F_VID_RAM0_RMW_MODE           `R_VID_RAM0_CFG      ,  4 , 16'h0010
`define  F_VID_RAM0_MSK_MODE           `R_VID_RAM0_CFG      ,  5 , 16'h0020
`define  F_VID_RAM0_WIN_MODE           `R_VID_RAM0_CFG      ,  6 , 16'h0040

`define  F_VID_RAM1_WIN_CL_SWAP        `R_VID_RAM1_CFG      ,  0 , 16'h0001
`define  F_VID_RAM1_WIN_Y_SWAP         `R_VID_RAM1_CFG      ,  1 , 16'h0002
`define  F_VID_RAM1_WIN_X_SWAP         `R_VID_RAM1_CFG      ,  2 , 16'h0004
`define  F_VID_RAM1_RMW_MODE           `R_VID_RAM1_CFG      ,  4 , 16'h0010
`define  F_VID_RAM1_MSK_MODE           `R_VID_RAM1_CFG      ,  5 , 16'h0020
`define  F_VID_RAM1_WIN_MODE           `R_VID_RAM1_CFG      ,  6 , 16'h0040

// GPU_STAT Register
`define  F_GPU_STAT_FIFO_CNT_EMPTY     `R_GPU_STAT          ,  0 , 16'h000F
`define  F_GPU_STAT_FIFO_CNT           `R_GPU_STAT          ,  4 , 16'h00F0
`define  F_GPU_STAT_FIFO_EMPTY         `R_GPU_STAT          ,  8 , 16'h0100
`define  F_GPU_STAT_FIFO_FULL          `R_GPU_STAT          ,  9 , 16'h0200
`define  F_GPU_STAT_DMA_BUSY           `R_GPU_STAT          , 12 , 16'h1000
`define  F_GPU_STAT_BUSY               `R_GPU_STAT          , 15 , 16'h8000


//----------------------------------------------------------
// USEFULL VALUES
//----------------------------------------------------------

`define  V_GFX_16_BPP                  16'h0004
`define  V_GFX_8_BPP                   16'h0003
`define  V_GFX_4_BPP                   16'h0002
`define  V_GFX_2_BPP                   16'h0001
`define  V_GFX_1_BPP                   16'h0000

`define  V_LT24_CLK_DIV1               16'h0000
`define  V_LT24_CLK_DIV2               16'h0001
`define  V_LT24_CLK_DIV3               16'h0002
`define  V_LT24_CLK_DIV4               16'h0003
`define  V_LT24_CLK_DIV5               16'h0004
`define  V_LT24_CLK_DIV6               16'h0005
`define  V_LT24_CLK_DIV7               16'h0006
`define  V_LT24_CLK_DIV8               16'h0007

`define  V_LT24_REFR_MANUAL            16'h0000
`define  V_LT24_REFR_21_FPS            (((48000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_24_FPS            (((40000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_31_FPS            (((32000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_42_FPS            (((24000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_62_FPS            (((16000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_125_FPS           ((( 8000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_250_FPS           ((( 4000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_500_FPS           ((( 2000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_1000_FPS          ((( 1000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_48MS              (((48000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_40MS              (((40000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_32MS              (((32000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_24MS              (((24000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_16MS              (((16000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_8MS               ((( 8000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_4MS               ((( 4000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_2MS               ((( 2000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)
`define  V_LT24_REFR_1MS               ((( 1000000/`DCO_CLK_PERIOD)>>12) & 16'h0FFF)


`define  V_HW_LUT_PALETTE_0_HI         16'h0000
`define  V_HW_LUT_PALETTE_0_LO         16'h0001
`define  V_HW_LUT_PALETTE_1_HI         16'h0002
`define  V_HW_LUT_PALETTE_1_LO         16'h0003
`define  V_HW_LUT_PALETTE_2_HI         16'h0004
`define  V_HW_LUT_PALETTE_2_LO         16'h0005

`define  V_HW_LUT_BLACK                16'h0000
`define  V_HW_LUT_BLUE                 16'h0001
`define  V_HW_LUT_GREEN                16'h0002
`define  V_HW_LUT_CYAN                 16'h0003
`define  V_HW_LUT_RED                  16'h0004
`define  V_HW_LUT_MAGENTA              16'h0005
`define  V_HW_LUT_BROWN                16'h0006
`define  V_HW_LUT_LIGHT_GRAY           16'h0007
`define  V_HW_LUT_GRAY                 16'h0008
`define  V_HW_LUT_LIGHT_BLUE           16'h0009
`define  V_HW_LUT_LIGHT_GREEN          16'h000A
`define  V_HW_LUT_LIGHT_CYAN           16'h000B
`define  V_HW_LUT_LIGHT_RED            16'h000C
`define  V_HW_LUT_LIGHT_MAGENTA        16'h000D
`define  V_HW_LUT_YELLOW               16'h000E
`define  V_HW_LUT_WHITE                16'h000F

`define  V_FRAME0_SELECT               16'h0000
`define  V_FRAME1_SELECT               16'h0001
`define  V_FRAME2_SELECT               16'h0002
`define  V_FRAME3_SELECT               16'h0003


//----------------------------------------------------------
// GPU COMMANDS
//----------------------------------------------------------

// GPU COMMAND
`define  GPU_EXEC_FILL                 16'h0000
`define  GPU_EXEC_COPY                 16'h4000
`define  GPU_EXEC_COPY_TRANS           16'h8000
`define  GPU_REC_WIDTH                 16'hC000
`define  GPU_REC_HEIGHT                16'hD000
`define  GPU_SRC_PX_ADDR               16'hF800
`define  GPU_DST_PX_ADDR               16'hF801
`define  GPU_OF0_ADDR                  16'hF810
`define  GPU_OF1_ADDR                  16'hF811
`define  GPU_OF2_ADDR                  16'hF812
`define  GPU_OF3_ADDR                  16'hF813
`define  GPU_SET_FILL                  16'hF420
`define  GPU_SET_TRANS                 16'hF421

// ADDRESS SOURCE SELECTION
`define  GPU_SRC_OF0                   16'h0000
`define  GPU_SRC_OF1                   16'h1000
`define  GPU_SRC_OF2                   16'h2000
`define  GPU_SRC_OF3                   16'h3000
`define  GPU_DST_OF0                   16'h0000
`define  GPU_DST_OF1                   16'h0008
`define  GPU_DST_OF2                   16'h0010
`define  GPU_DST_OF3                   16'h0018

// DMA CONFIGURATION
`define  GPU_DST_CL_SWP                16'h0001
`define  GPU_DST_Y_SWP                 16'h0002
`define  GPU_DST_X_SWP                 16'h0004
`define  GPU_SRC_CL_SWP                16'h0200
`define  GPU_SRC_Y_SWP                 16'h0400
`define  GPU_SRC_X_SWP                 16'h0800
`define  GPU_DST_NO_CL_SWP             16'h0000
`define  GPU_DST_NO_Y_SWP              16'h0000
`define  GPU_DST_NO_X_SWP              16'h0000
`define  GPU_SRC_NO_CL_SWP             16'h0000
`define  GPU_SRC_NO_Y_SWP              16'h0000
`define  GPU_SRC_NO_X_SWP              16'h0000

`define  DST_SWAP_NONE                 16'h0000
`define  DST_SWAP_CL                   16'h0001
`define  DST_SWAP_Y                    16'h0002
`define  DST_SWAP_Y_CL                 16'h0003
`define  DST_SWAP_X                    16'h0004
`define  DST_SWAP_X_CL                 16'h0005
`define  DST_SWAP_X_Y                  16'h0006
`define  DST_SWAP_X_Y_CL               16'h0007
`define  DST_SWAP_MSK                  16'hFFF8

`define  SRC_SWAP_NONE                 16'h0000
`define  SRC_SWAP_CL                   16'h0200
`define  SRC_SWAP_Y                    16'h0400
`define  SRC_SWAP_Y_CL                 16'h0600
`define  SRC_SWAP_X                    16'h0800
`define  SRC_SWAP_X_CL                 16'h0A00
`define  SRC_SWAP_X_Y                  16'h0C00
`define  SRC_SWAP_X_Y_CL               16'h0E00
`define  SRC_SWAP_MSK                  16'hF1FF

// PIXEL OPERATION
`define  GPU_PXOP_0                    16'h0000  // S
`define  GPU_PXOP_1                    16'h0020  // not S
`define  GPU_PXOP_2                    16'h0040  // not D
`define  GPU_PXOP_3                    16'h0060  // S and D
`define  GPU_PXOP_4                    16'h0080  // S or  D
`define  GPU_PXOP_5                    16'h00A0  // S xor D
`define  GPU_PXOP_6                    16'h00C0  // not (S and D)
`define  GPU_PXOP_7                    16'h00E0  // not (S or  D)
`define  GPU_PXOP_8                    16'h0100  // not (S xor D)
`define  GPU_PXOP_9                    16'h0120  // (not S) and      D
`define  GPU_PXOP_A                    16'h0140  //      S  and (not D)
`define  GPU_PXOP_B                    16'h0160  // (not S) or       D
`define  GPU_PXOP_C                    16'h0180  //      S  or  (not D)
`define  GPU_PXOP_D                    16'h01A0  // Fill 0            if S not transparent (only COPY_TRANSPARENT command)
`define  GPU_PXOP_E                    16'h01C0  // Fill 1            if S not transparent (only COPY_TRANSPARENT command)
`define  GPU_PXOP_F                    16'h01E0  // Fill 'fill_color' if S not transparent (only COPY_TRANSPARENT command)

