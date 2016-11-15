<a name="top"></a>
# openGFX430 core

#### Table of content

*   [1. Introduction](#1_introduction)
*   [2. Core](#2_core)
    *   [2.1 Design structure](#2_1_design_structure)
    *   [2.2 RTL configuration](#2_2_rtl_configuration)
    *   [2.3 Pinout](#2_3_pinout)
    *   [2.4 Register overview](#2_4_register_overview)
    *   [2.5 GPU commands](#2_5_gpu_commands)

<a name="1_introduction"></a>
## 1. Introduction

The openGFX430 is a 16-bit graphic controller peripheral tailored for the [openMSP430](https://github.com/olgirard/openmsp430) core and designed to directly interface with the [LT24](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=892) daughter board from Terasic.  

The video memory can be indirectly accessed by the CPU with the help of an hardware address generator, releasing the CPU from address calculation tasks.  

In addition, the controller also provides a GPU to accelerate rendering of:

*   Vertical and horizontal lines.
*   Rectangles.
*   Copying of rectangular area between different video memory locations.

The GPU is controlled through a command FIFO. Once initiated, the hardware performs the rendering while freeing up the CPU for other tasks. Software can either poll the status or use interrupts to continue rendering further shapes.  

It is to be noted that this IP doesn't contain the LUT and Video memory blocks internally (these are technology dependent hard macros which are connected to the IP during chip integration). However the core is fully configurable in regard to the supported RAM sizes.  

<a name="2_core"></a>
## 2. Core

<a name="2_1_design_structure"></a>
### 2.1 Design structure

The following diagram shows the openGFX430 design structure:  

![GFX controller structure](http://opencores.org/usercontent,img,1473711243 "GFX controller tructure")  

*   **Registers**: this module contains all the configuration, control, status and interrupt registers that can be accessed by the CPU (i.e. the openMSP430).  
    It also includes two indirect video memory interfaces as well as the GPU command fifo.  

*   **GPU**: fetches commands from the fifo in order to accelerate the rendering of vertical and horizontal lines, rectangles, and copying of rectangular area between different video memory locations.  

*   **Backend**: this block reads the video memory during the screen refresh. For resolutions smaller than 16bpp, it also fetches the corresponding pixels colors from the LUT memory.  

*   **Screen interface**: the screen interface (or display controller) is responsible for the screen refresh and reads the pixel values from the backend to forward them to the screen according to the interface protocol.  

*   **Arbiters**: arbitration between the different ressources accessing the LUT and Video memories.

<a name="2_2_rtl_configuration"></a>
### 2.2 RTL Configuration

It is possible to configure the openGFX430 core through the **_openGFX430\_defines.v_** file located in the **_rtl_** directory (see [here](https://github.com/olgirard/opengfx430/blob/master/core/rtl/verilog/openGFX430_defines.v)).  

The basic system can be adjusted with the following set of defines in order to match the target system requirements:  

~~~~
//============================================================================
// GRAPHIC CONTROLLER USER CONFIGURATION
//============================================================================

//-----------------------------------------------------  
// Video display maximum pixel height/width  
//-----------------------------------------------------  
//`define MAX_DISPLAY_PIXEL_LENGTH_4096  
//`define MAX_DISPLAY_PIXEL_LENGTH_2048  
//`define MAX_DISPLAY_PIXEL_LENGTH_1024  
`define MAX_DISPLAY_PIXEL_LENGTH_512  
//`define MAX_DISPLAY_PIXEL_LENGTH_256  
//`define MAX_DISPLAY_PIXEL_LENGTH_128  
//`define MAX_DISPLAY_PIXEL_LENGTH_64  
//`define MAX_DISPLAY_PIXEL_LENGTH_32  

//-----------------------------------------------------  
// Video memory address width  
//-----------------------------------------------------  
`define VRAM_AWIDTH 17  

//-----------------------------------------------------  
// Define if the Video memory is bigger than 4k Words  
// (should be defined if VRAM_AWIDTH is bigger than 12)  
//-----------------------------------------------------  
`define VRAM_BIGGER_4_KW  

//-----------------------------------------------------  
// Include/Exclude Frame buffer pointers from the  
// register map  
// (Frame pointer 0 is always included)  
//-----------------------------------------------------  
`define WITH_FRAME1_POINTER  
//`define WITH_FRAME2_POINTER  
//`define WITH_FRAME3_POINTER  

//-----------------------------------------------------  
// LUT Configuration  
//-----------------------------------------------------  
`define WITH_PROGRAMMABLE_LUT  
`define WITH_EXTRA_LUT_BANK  
~~~~

<a name="2_3_pinout"></a>
### 2.3 Pinout

The full pinout of the openGFX430 core is provided in the following table:  

<table border="0">
  <tbody>
    <tr>
        <td align="center" bgcolor="#B0B0B0"><b>Port Name</b></td>
        <td align="center" bgcolor="#B0B0B0"><b>Direction</b></td>
        <td align="center" bgcolor="#B0B0B0"><b>Width</b></td>
        <td align="center" bgcolor="#B0B0B0"><b>Clock<br>Domain</b></td>
        <td align="center" bgcolor="#B0B0B0"><b>Description</b></td>
    </tr>

    <tr><td colspan="5" align="center" bgcolor="#E0E0E0"><b><i>Clocks &amp; Reset</i></b></td></tr>

    <tr>
        <td style="vertical-align: top;">mclk</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">-</td>
        <td style="vertical-align: top;">Main system clock</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">puc_rst</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Main system reset</td>
    </tr>

    <tr><td colspan="5" align="center" bgcolor="#E0E0E0"><b><i>Peripheral interface</i></b></td></tr>

    <tr>
        <td style="vertical-align: top;">per_addr_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">14</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Peripheral address</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">per_din_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Peripheral data input</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">per_dout_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Peripheral data output</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">per_en_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Peripheral enable (high active)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">per_wen_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">2</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Peripheral write enable (high active)</td>
    </tr>

    <tr><td colspan="5" align="center" bgcolor="#E0E0E0"><b><i>Video Memory interface</i></b></td></tr>

    <tr>
        <td style="vertical-align: top;">vid_ram_dout_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Video-RAM data output</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">vid_ram_din_i</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Video-RAM data input</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">vid_ram_addr_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;"><small>`VRAM_AWIDTH</small><b><sup><font color="#ff0000">1</font></sup></b></td>
        <td style="vertical-align: top; text-align: center;"><br></td>
        <td style="vertical-align: top;">Video-RAM address</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">vid_ram_cen_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Video-RAM enable (active low)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">vid_ram_wen_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Video-RAM write enable (active low)</td>
    </tr>

    <tr><td colspan="5" align="center" bgcolor="#E0E0E0"><b><i>LUT Memory interface<sup><font color="#ff0000"> 2</font></sup></i></b></td></tr>

    <tr>
        <td style="vertical-align: top;">lut_ram_dout_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LUT-RAM data output</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lut_ram_din_i</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LUT-RAM data input</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lut_ram_addr_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">8 or 9<b><sup><font color="#ff0000"> 3</font></sup></b></td>
        <td style="vertical-align: top; text-align: center;"><br></td>
        <td style="vertical-align: top;">LUT-RAM address</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lut_ram_cen_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LUT-RAM enable (active low)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lut_ram_wen_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LUT-RAM write enable (active low)</td>
    </tr>

    <tr><td colspan="5" align="center" bgcolor="#E0E0E0"><b><i>LT24 Screen Interface</i></b></td></tr>

    <tr>
        <td style="vertical-align: top;">lt24_d_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Data input</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_d_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">16</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Data output</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_d_en_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Data output enable</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_cs_n_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Chip select (Active low)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_rd_n_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Read strobe (Active low)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_wr_n_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Write strobe (Active low)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_rs_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Command/Param selection (Cmd=0/Param=1)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_reset_n_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 Reset (Active Low)</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">lt24_on_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">LT24 on/off</td>
    </tr>

    <tr><td colspan="5" align="center" bgcolor="#E0E0E0"><b><i>Others</i></b></td></tr>

    <tr>
        <td style="vertical-align: top;">dbg_freeze_i</td>
        <td style="vertical-align: top;">input</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Freeze address auto-incr on read</td>
    </tr>
    <tr>
        <td style="vertical-align: top;">irq_gfx_o</td>
        <td style="vertical-align: top;">output</td>
        <td style="vertical-align: top;">1</td>
        <td style="vertical-align: top; text-align: center;">mclk</td>
        <td style="vertical-align: top;">Graphic Controller interrupt</td>
    </tr>
  </tbody>
</table>

**<sup><font color="#ff0000">1</font></sup>**: This parameter is declared in the [_openGFX430\_defines.v_](https://github.com/olgirard/opengfx430/blob/master/core/rtl/verilog/openGFX430_defines.v) file and defines the video memory address width.  
**<sup><font color="#ff0000">2</font></sup>**: LUT memory interface is available if the **WITH\_PROGRAMMABLE\_LUT** macro is uncommented in the [_openGFX430\_defines.v_](https://github.com/olgirard/opengfx430/blob/master/core/rtl/verilog/openGFX430_defines.v) file.  
**<sup><font color="#ff0000">3</font></sup>**: A single LUT bank needs 256 entries to support the 8bpp mode (thus 8 bit address bus). 9 bits of addresses are required if an extra LUT bank is added by uncommenting the **WITH\_EXTRA\_LUT\_BANK** macro in the [_openGFX430\_defines.v_](https://github.com/olgirard/opengfx430/blob/master/core/rtl/verilog/openGFX430_defines.v) file.  

<a name="2_4_register_overview"></a>
### 2.4 Register overview

The following table provide the register overview of the openGFX430:  

<table border="0">
  <tbody>
    <tr><td align="center" bgcolor="#B0B0B0"><b>Register Name </b></td><td align="center" bgcolor="#B0B0B0"><b>Address offset</b></td><td align="center" bgcolor="#B0B0B0"><b>Description</b></td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i><a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/global_control.md#top">Global control / status / irq</a></i></b></td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/global_control.md#2_1_GFX_CTRL">            GFX_CTRL</a>          &nbsp;</td><td align="center">   0x00   </td><td align="left" rowspan=1>&nbsp;Global control register</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/global_control.md#2_2_GFX_STATUS">          GFX_STATUS</a>        &nbsp;</td><td align="center">   0x08   </td><td align="left" rowspan=1>&nbsp;Global status register</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/global_control.md#2_3_GFX_IRQ">             GFX_IRQ</a>           &nbsp;</td><td align="center">   0x0A   </td><td align="left" rowspan=1>&nbsp;Global IRQ flag register</td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i><a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#top">Display configuration</a></i></b></td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#2_1_DISPLAY_WIDTH">       DISPLAY_WIDTH</a>     &nbsp;</td><td align="center">   0x10   </td><td align="left" rowspan=1>&nbsp;Display pixel width</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#2_2_DISPLAY_HEIGHT">      DISPLAY_HEIGHT</a>    &nbsp;</td><td align="center">   0x12   </td><td align="left" rowspan=1>&nbsp;Display pixel height</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#2_3_DISPLAY_SIZE_LO_HI">  DISPLAY_SIZE_LO</a>   &nbsp;</td><td align="center">   0x14   </td><td align="left" rowspan=2>&nbsp;Display size (i.e. number of pixels)</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#2_3_DISPLAY_SIZE_LO_HI">  DISPLAY_SIZE_HI</a>   &nbsp;</td><td align="center">   0x16   </td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#2_4_DISPLAY_CFG">         DISPLAY_CFG</a>       &nbsp;</td><td align="center">   0x18   </td><td align="left" rowspan=1>&nbsp;Display refresh read configuration</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#2_5_DISPLAY_REFR_CNT">    DISPLAY_REFR_CNT</a>  &nbsp;</td><td align="center">   0x1A   </td><td align="left" rowspan=1>&nbsp;Display refresh counter</td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i><a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#top">LT24 configuration</a></i></b></td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#2_1_LT24_CFG">               LT24_CFG</a>          &nbsp;</td><td align="center">   0x20   </td><td align="left" rowspan=1>&nbsp;LT24 screen control</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#2_2_LT24_REFRESH">           LT24_REFRESH</a>      &nbsp;</td><td align="center">   0x22   </td><td align="left" rowspan=1>&nbsp;LT24 refresh timing configuration</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#2_3_LT24_REFRESH_SYNC">      LT24_REFRESH_SYNC</a> &nbsp;</td><td align="center">   0x24   </td><td align="left" rowspan=1>&nbsp;LT24 refresh synchronization configuration</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#2_4_LT24_CMD">               LT24_CMD</a>          &nbsp;</td><td align="center">   0x26   </td><td align="left" rowspan=1>&nbsp;LT24 command</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#2_5_LT24_CMD_PARAM">         LT24_CMD_PARAM</a>    &nbsp;</td><td align="center">   0x28   </td><td align="left" rowspan=1>&nbsp;LT24 command parameter</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#2_6_LT24_CMD_DFILL">         LT24_CMD_DFILL</a>    &nbsp;</td><td align="center">   0x2A   </td><td align="left" rowspan=1>&nbsp;LT24 command data fill</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/lt24_config.md#2_7_LT24_STATUS">            LT24_STATUS</a>       &nbsp;</td><td align="center">   0x2C   </td><td align="left" rowspan=1>&nbsp;LT24 status</td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i><a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/color_lut.md#top">Color LUT Configuration & Memory Access Gate</a></i></b></td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/color_lut.md#4_1_LUT_CFG">                  LUT_CFG</a>           &nbsp;</td><td align="center">   0x30   </td><td align="left" rowspan=1>&nbsp;LUT Configuration</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/color_lut.md#4_2_LUT_RAM_ADDR">             LUT_RAM_ADDR</a>      &nbsp;</td><td align="center">   0x32   </td><td align="left" rowspan=1>&nbsp;LUT-RAM address</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/color_lut.md#4_3_LUT_RAM_DATA">             LUT_RAM_DATA</a>      &nbsp;</td><td align="center">   0x34   </td><td align="left" rowspan=1>&nbsp;LUT-RAM data</td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i><a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#top">Frame pointers and selection</a></i></b></td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_1_FRAME_SELECT">        FRAME_SELECT</a>      &nbsp;</td><td align="center">   0x3E   </td><td align="left" rowspan=1>&nbsp;Frame pointer selections</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME0_PTR_LO</a>     &nbsp;</td><td align="center">   0x40   </td><td align="left" rowspan=2>&nbsp;Frame address pointer 0</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME0_PTR_HI</a>     &nbsp;</td><td align="center">   0x42   </td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME1_PTR_LO</a>     &nbsp;</td><td align="center">   0x44   </td><td align="left" rowspan=2>&nbsp;Frame address pointer 1</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME1_PTR_HI</a>     &nbsp;</td><td align="center">   0x46   </td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME2_PTR_LO</a>     &nbsp;</td><td align="center">   0x48   </td><td align="left" rowspan=2>&nbsp;Frame address pointer 2</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME2_PTR_HI</a>     &nbsp;</td><td align="center">   0x4A   </td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME3_PTR_LO</a>     &nbsp;</td><td align="center">   0x4C   </td><td align="left" rowspan=2>&nbsp;Frame address pointer 3</td></tr>
    <tr><td align="left">&nbsp;<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/frame_pointers.md#2_2_FRAMEx_PTR">          FRAME3_PTR_HI</a>     &nbsp;</td><td align="center">   0x4E   </td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i>First Video Memory Access Gate</i></b></td></tr>
    <tr><td align="left">&nbsp;VID_RAM0_CFG      &nbsp;</td><td align="center">   0x50   </td><td align="left">&nbsp;Video-RAM address generator configuration&nbsp;&nbsp;</td></tr>
    <tr><td align="left">&nbsp;VID_RAM0_WIDTH    &nbsp;</td><td align="center">   0x52   </td><td align="left">&nbsp;Window mode width configuration</td></tr>
    <tr><td align="left">&nbsp;VID_RAM0_ADDR_LO  &nbsp;</td><td align="center">   0x54   </td><td align="left" rowspan=2>&nbsp;Video-RAM address</td></tr>
    <tr><td align="left">&nbsp;VID_RAM0_ADDR_HI  &nbsp;</td><td align="center">   0x56   </td></tr>
    <tr><td align="left">&nbsp;VID_RAM0_DATA     &nbsp;</td><td align="center">   0x58   </td><td align="left">&nbsp;Video-RAM data</td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i>Second Video Memory Access Gate</i></b></td></tr>
    <tr><td align="left">&nbsp;VID_RAM1_CFG      &nbsp;</td><td align="center">   0x60   </td><td align="left">&nbsp;Video-RAM address generator configuration</td></tr>
    <tr><td align="left">&nbsp;VID_RAM1_WIDTH    &nbsp;</td><td align="center">   0x62   </td><td align="left">&nbsp;Window mode width configuration</td></tr>
    <tr><td align="left">&nbsp;VID_RAM1_ADDR_LO  &nbsp;</td><td align="center">   0x64   </td><td align="left" rowspan=2>&nbsp;Video-RAM address</td></tr>
    <tr><td align="left">&nbsp;VID_RAM1_ADDR_HI  &nbsp;</td><td align="center">   0x66   </td></tr>
    <tr><td align="left">&nbsp;VID_RAM1_DATA     &nbsp;</td><td align="center">   0x68   </td><td align="left">&nbsp;Video-RAM data</td></tr>

    <tr><td colspan=3 align="center" bgcolor="#E0E0E0"><b><i>Graphic Processing Unit</i></b></td></tr>
    <tr><td align="left">&nbsp;GPU_CMD_LO        &nbsp;</td><td align="center">   0x70   </td><td align="left" rowspan=2>&nbsp;GPU command FIFO</td></tr>
    <tr><td align="left">&nbsp;GPU_CMD_HI        &nbsp;</td><td align="center">   0x72   </td></tr>
    <tr><td align="left">&nbsp;GPU_STAT          &nbsp;</td><td align="center">   0x74   </td><td align="left">&nbsp;GPU status</td></tr>
  </tbody>
</table>

<a name="2_5_gpu_commands"></a>
### 2.5 GPU commands

The following commands are supported by the GPU:  

<table border="0">
  <tbody>
    <tr><td align="center" bgcolor="#B0B0B0"><b>GPU Command name </b></td><td align="center" bgcolor="#B0B0B0"><b>Description</b></td><td align="center" bgcolor="#B0B0B0"><b>Opcode(s)</b></td></tr>

    <tr><td align="left"><b>&nbsp;EXEC_FILL        &nbsp;</b></td><td align="left">&nbsp;Execute rectangle fill&nbsp;</td>
                                                                  <td align="left"><code>{2'b00, reserved<4:0>,                                     pxop[3:0], dst_offset[1:0], dst_X-Swp, dst_Y-Swp, dst_CL-Swp}
                                                                                     <br>{fill_color[15:0]}</code></td></tr>

    <tr><td align="left"><b>&nbsp;EXEC_COPY        &nbsp;</b></td><td align="left">&nbsp;Execute rectangle copy&nbsp;</td>
                                                                  <td align="left"><code>{2'b01, src_offset[1:0], src_X-Swp, src_Y-Swp, src_CL-Swp, pxop[3:0], dst_offset[1:0], dst_X-Swp, dst_Y-Swp, dst_CL-Swp}</code></td></tr>

    <tr><td align="left"><b>&nbsp;EXEC_COPY_TRANS  &nbsp;</b></td><td align="left">&nbsp;Execute rectangle copy&nbsp;<br>&nbsp;(with transparency)&nbsp;</td>
                                                                  <td align="left"><code>{2'b10, src_offset[1:0], src_X-Swp, src_Y-Swp, src_CL-Swp, pxop[3:0], dst_offset[1:0], dst_X-Swp, dst_Y-Swp, dst_CL-Swp}</code></td></tr>

    <tr><td align="left"><b>&nbsp;REC_WIDTH        &nbsp;</b></td><td align="left">&nbsp;Set rectangle width&nbsp;</td>
                                                                  <td align="left"><code>{4'b1100, width[11:0]}</code></td></tr>

    <tr><td align="left"><b>&nbsp;REC_HEIGHT       &nbsp;</b></td><td align="left">&nbsp;Set rectangle height&nbsp;</td>
                                                                  <td align="left"><code>{4'b1101, height[11:0]}</code></td></tr>

    <tr><td align="left"><b>&nbsp;SRC_PX_ADDR      &nbsp;</b></td><td align="left">&nbsp;Set source address&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b10, 10'b0000000000}
                                                                                     <br>{addr[15:0]                    }
                                                                                     <br>{addr[31:16]                   }</code></td></tr>

    <tr><td align="left"><b>&nbsp;DST_PX_ADDR      &nbsp;</b></td><td align="left">&nbsp;Set destination address&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b10, 10'b0000000001}
                                                                                     <br>{addr[15:0]                    }
                                                                                     <br>{addr[31:16]                   }</code></td></tr>

    <tr><td align="left"><b>&nbsp;OF0_ADDR         &nbsp;</b></td><td align="left">&nbsp;Set address offset 0&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b10, 10'b0000010000}
                                                                                     <br>{addr[15:0]                    }
                                                                                     <br>{addr[31:16]                   }</code></td></tr>

    <tr><td align="left"><b>&nbsp;OF1_ADDR         &nbsp;</b></td><td align="left">&nbsp;Set address offset 1&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b10, 10'b0000010001}
                                                                                     <br>{addr[15:0]                    }
                                                                                     <br>{addr[31:16]                   }</code></td></tr>

    <tr><td align="left"><b>&nbsp;OF2_ADDR         &nbsp;</b></td><td align="left">&nbsp;Set address offset 2&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b10, 10'b0000010010}
                                                                                     <br>{addr[15:0]                    }
                                                                                     <br>{addr[31:16]                   }</code></td></tr>

    <tr><td align="left"><b>&nbsp;OF3_ADDR         &nbsp;</b></td><td align="left">&nbsp;Set address offset 3&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b10, 10'b0000010011}
                                                                                     <br>{addr[15:0]                    }
                                                                                     <br>{addr[31:16]                   }</code></td></tr>

    <tr><td align="left"><b>&nbsp;SET_FILL         &nbsp;</b></td><td align="left">&nbsp;Set fill color&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b01, 10'b0000100000}
                                                                                     <br>{fill_color[15:0]              }</code></td></tr>

    <tr><td align="left"><b>&nbsp;SET_TRANSPARENT  &nbsp;</b></td><td align="left">&nbsp;Set transparent color&nbsp;</td>
                                                                  <td align="left"><code>{4'b1111, 2'b01, 10'b0000100001}
                                                                                     <br>{transparent_color[15:0]       }</code></td></tr>
  </tbody>
</table>
