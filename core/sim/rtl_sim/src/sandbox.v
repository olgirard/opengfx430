/*===========================================================================*/
/* Copyright (C) 2018 Authors                                                */
/*                                                                           */
/* This source file may be used and distributed without restriction provided */
/* that this copyright statement is not removed from the file and that any   */
/* derivative work contains the original copyright notice and the associated */
/* disclaimer.                                                               */
/*                                                                           */
/* This source file is free software; you can redistribute it and/or modify  */
/* it under the terms of the GNU Lesser General Public License as published  */
/* by the Free Software Foundation; either version 2.1 of the License, or    */
/* (at your option) any later version.                                       */
/*                                                                           */
/* This source is distributed in the hope that it will be useful, but WITHOUT*/
/* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or     */
/* FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public       */
/* License for more details.                                                 */
/*                                                                           */
/* You should have received a copy of the GNU Lesser General Public License  */
/* along with this source; if not, write to the Free Software Foundation,    */
/* Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA        */
/*                                                                           */
/*===========================================================================*/
/*                                SANDBOX                                    */
/*---------------------------------------------------------------------------*/
/* Sandbox test                                                              */
/*                                                                           */
/* Author(s):                                                                */
/*             - Olivier Girard,    olgirard@gmail.com                       */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* $Rev: 19 $                                                                */
/* $LastChangedBy: olivier.girard $                                          */
/* $LastChangedDate: 2009-08-04 23:47:15 +0200 (Tue, 04 Aug 2009) $          */
/*===========================================================================*/

`define LONG_TIMEOUT

integer    wait_wr;
integer    wait_rd;
integer    size   ;
reg [15:0] width, height;

initial
   begin
      $display(" ===============================================");
      $display("|                 START SIMULATION              |");
      $display(" ===============================================");

      repeat(5) @(posedge mclk);

      stimulus_done =  0;

      width         = 50;
      height        = 40;
      size          = width * height;

      // Init video memory
      for (tb_idx=0; tb_idx < (1<<`VRAM_AWIDTH); tb_idx=tb_idx+1)
        vid_ram_0.mem[tb_idx] = tb_idx;

      field_write  (`F_LT24_RESET      , 'h1                );
      field_write  (`F_LT24_ON         , 'h1                );
      field_write  (`F_LT24_CLK        , `V_LT24_CLK_DIV2   );
      field_write  (`F_LT24_RESET      , 'h0                );

      reg_write_16b(`R_DISPLAY_WIDTH   , width              );
      reg_write_16b(`R_DISPLAY_HEIGHT  , height             );
      reg_write_16b(`R_DISPLAY_SIZE_LO , size[15:0]         );
      reg_write_16b(`R_DISPLAY_SIZE_HI , size[31:16]        );

      field_write  (`F_DISPLAY_CL_SWAP , 'h0                );
      field_write  (`F_DISPLAY_Y_SWAP  , 'h0                );
      field_write  (`F_DISPLAY_X_SWAP  , 'h0                );

      field_write  (`F_GFX_MODE        , `V_GFX_16_BPP      );

      field_write  (`F_LT24_REFR       , `V_LT24_REFR_500US );
      field_write  (`F_LT24_REFR_START , 'h1                );

      //field_write  (`F_GFX_GPU_EN      , 'h1              );

      repeat(5)  @(posedge mclk);
      #(2ms);
      repeat(50) @(posedge mclk);

      stimulus_done = 1;
   end
