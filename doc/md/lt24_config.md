<a name="top"></a>
# LT24 screen configuration register

#### Table of content

*   [1. Introduction](#1_introduction)
*   [2. Registers](#2_registers)
    *   [2.1 LT24_CFG](#2_1_LT24_CFG)
    *   [2.2 LT24_REFRESH](#2_2_LT24_REFRESH)
    *   [2.3 LT24_REFRESH_SYNC](#2_3_LT24_REFRESH_SYNC)
    *   [2.4 LT24_CMD](#2_4_LT24_CMD)
    *   [2.5 LT24_CMD_PARAM](#2_5_LT24_CMD_PARAM)
    *   [2.6 LT24_CMD_DFILL](#2_6_LT24_CMD_DFILL)
    *   [2.7 LT24_STATUS](#2_7_LT24_STATUS)
    *   [2.8 LT24_IRQ](#2_8_LT24_IRQ)

<a name="1_introduction"></a>
## 1. Introduction

This section describes the LT24 screen configuration registers.  
These allow to configure the [LT24 daughter board](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=892) from Terasic and in particular manually send commands to the LCD controller, the ILI9341.  

The LT24 LCD features 240(H) x 320(V) pixel resolution and the ILI9341 LCD driver is used to drive the LCD display.
The 8080-system 16-bit parallel bus interface of the ILI9341 allows to refresh the screen with a 16bpp resolution (65K-Color, RGB 5-6-5 bits per pixel).  

Further information about the particular commands that can be sent to the controller can be found in the *"8\. Command"* section of the [ILI9341 datasheet](https://github.com/olgirard/openmsp430/blob/master/fpga/altera_de0_nano_soc/doc/Terasic/LT24/ILI9341.pdf).  

<a name="2_registers"></a>
## 2. Registers

<a name="2_1_LT24_CFG"></a>
### 2.1 LT24_CFG

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x20</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 screen control</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_IRQ_EN_REFR_DONE</td>    <!-- 15       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_IRQ_EN_REFR_START</td>   <!-- 14       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_IRQ_EN_REFR_UFLOW</td>   <!-- 13       -->
        <td colspan=5  align="center" style="word-wrap:break-word;">res.</td>                     <!-- 12 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=1  align="center" style="word-wrap:break-word;">res.</td>             <!-- 7       -->
        <td colspan=3  align="center" style="word-wrap:break-word;">LT24_CLK_CFG</td>     <!-- 6 ... 4 -->
        <td colspan=2  align="center" style="word-wrap:break-word;">res.</td>             <!-- 3 ... 2 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_RESET</td>       <!-- 1       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_ON</td>          <!-- 0       -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_IRQ_EN_REFR_DONE</b></td><td>Screen refresh start interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable REFR start interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable REFR start interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_IRQ_EN_REFR_START</b></td><td>Screen refresh done interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable REFR done interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable REFR done interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_IRQ_EN_REFR_UFLOW</b></td><td>Screen refresh underflow interrupt enable bit<br>
                                                       &emsp;&emsp;<code>0 = disable UFLOW done interrupt</code><br>
                                                       &emsp;&emsp;<code>1 = enable UFLOW done interrupt</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_CLK_CFG  </b></td><td style="width:100%;">Clock Divider configuration for the WRX strobe generation of the LT24 interface.<br>
                                                       &emsp;&emsp;<code>0  = WRX period is <b>2*T<sub>system-clock</sub></b> (system clock period).</code><br>
                                                       &emsp;&emsp;<code>1  = WRX period is <b>4*T<sub>system-clock</sub></b>.</code><br>
                                                       &emsp;&emsp;<code><b><i>n</i></b>  = WRX period is <b>2*(n+1)*T<sub>system-clock</sub></b>.</code><br>
                                                       &emsp;&emsp;<code>7  = WRX period is <b>16*T<sub>system-clock</sub></b>.</code><br><br>
                                                       Note that the time required to refresh the complete screen is calculated with the following formula:<br>
                                                       &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<b>t<sub>refresh</sub></b> = 2*(<b><i>n</i></b>+1)*T<sub>system-clock</sub>*<a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/display_config.md#2_3_DISPLAY_SIZE_LO_HI">D_SIZE</a></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_RESET    </b></td><td>Reset the LT24 module.<br>
                                                       &emsp;&emsp;<code>0  = Reset released</code><br>
                                                       &emsp;&emsp;<code>1  = Reset asserted</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_ON       </b></td><td>Turn the LT24 module ON or OFF.<br>
                                                       &emsp;&emsp;<code>0  = OFF</code><br>
                                                       &emsp;&emsp;<code>1  = ON</code></td></tr>
  </tbody>
</table>

<a name="2_2_LT24_REFRESH"></a>
### 2.2 LT24_REFRESH

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x22</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 refresh timing configuration</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LT24_CFG_REFR[14:7]</td>        <!-- 15 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=7  align="center" style="word-wrap:break-word;">LT24_CFG_REFR[6:0]</td>     <!-- 7 ... 1 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_REFR_START</td>        <!-- 0       -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_CFG_REFR  </b></td><td style="width:100%;">LT24 screen refresh period configuration<br>
                                                       &emsp;&emsp;<code>0x0000 = Manual refresh mode</code><br>
                                                       &emsp;&emsp;<code>&nbsp;&nbsp;<b><i>n</i></b>&nbsp;&nbsp;  = Automatic refresh mode:</code><br>
                                                       &emsp;&emsp;<code>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<b>T<sub>refresh</sub></b> = (<b>n</b>*2<sup>9</sup>+1)*T<sub>system-clock</sub></code><br><br>
                                                       For example, with a 50MHz system clock (i.e. T<sub>system-clock</sub>=20ns) and <b><i>n</i></b> being set to 1625, the screen is refreshed every 16.6ms (i.e. 60.1 Frame-Per-Seconds).
                                                       <br><br>
                                                       Note that it is not possible to have a refresh period (<b>T<sub>refresh</sub></b>) smaller than the time it takes to refresh a single frame (<b>t<sub>refresh</sub></b>).<br>
                                                       In such a scenario, <b>T<sub>refresh</sub></b> is clamped and becomes equal to <b>t<sub>refresh</sub></b>.
                                                       </td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_CFG_START </b></td><td>Enable/Disable screen refresh<br>
                                                       &emsp;&emsp;<code>0  = Stop screen refresh.</code><br>
                                                       &emsp;&emsp;<code>1  = Enable screen refresh:</code><br>
                                                       &emsp;&emsp;<code>&emsp;&emsp;&emsp;&emsp;&middot; in manual refresh mode,
                                                                        this bit is automatically cleared after the refresh is complete.</code><br>
                                                       &emsp;&emsp;<code>&emsp;&emsp;&emsp;&emsp;&middot; in automatic refresh mode,
                                                                        this bit stays set until cleared by software.</code></td></tr>
  </tbody>
</table>

<a name="2_3_LT24_REFRESH_SYNC"></a>
### 2.3 LT24_REFRESH_SYNC

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x24</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 refresh synchronization configuration</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_REFR_SYNC_EN</td>        <!-- 15       -->
        <td colspan=5  align="center" style="word-wrap:break-word;">res.</td>                     <!-- 14 ... 8 -->
        <td colspan=2  align="center" style="word-wrap:break-word;">LT24_REFR_SYNC_VAL[9:8]</td>  <!-- 14 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LT24_REFR_SYNC_VAL[7:0]</td>     <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_REFR_SYNC_EN </b></td><td style="width:100%;">LT24 scanline synchronization control<br>
                                                       &emsp;&emsp;<code> 0 = Disabled</code><br>
                                                       &emsp;&emsp;<code> 1 = Enabled</code><br>
                                                       <br>
                                                       When enabled, the start of each screen refresh is sychronized with the scanline/GTS value read using the <b><i>Get_Scanline (45h)</i></b> command of the ILI9341 controller (<a href="https://github.com/olgirard/openmsp430/blob/master/fpga/altera_de0_nano_soc/doc/Terasic/LT24/ILI9341.pdf">see 8.2.37. datasheet section</a>).
                                                       </td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_REFR_SYNC_VAL </b></td><td>LT24 scanline/GTS synchronization value<br>
                                                       &emsp;&emsp;<code>&nbsp;&nbsp;<b><i>n</i></b>&nbsp;&nbsp;  = Scanline value to be synchronized with.</code></td></tr>
  </tbody>
</table>

<a name="2_4_LT24_CMD"></a>
### 2.4 LT24_CMD

Both <b><i>LT24_CMD</i></b> and <b><i>LT24_CMD_PARAM</i></b> registers are used to send custom commands to the ILI9341 controller (see list of commands in the section 8 of the <a href="https://github.com/olgirard/openmsp430/blob/master/fpga/altera_de0_nano_soc/doc/Terasic/LT24/ILI9341.pdf">spec</a>).

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x26</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 command</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=7  align="center" style="word-wrap:break-word;">res.</td>                     <!-- 15 ... 9 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_CMD_HAS_PARAM</td>       <!--  8       -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LT24_CMD_VAL</td>     <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_CMD_HAS_PARAM </b></td><td style="width:100%;">LT24 command has some parameters.<br>
                                                       &emsp;&emsp;<code> 0 = Command expects no parameter</code><br>
                                                       &emsp;&emsp;<code> 1 = Command expects parameters</code><br>
                                                       <br>
                                                       When enabled, the command parameters can be specified by writing to the LT24_CMD_PARAM register. Once all parameters have been specified, software shall clear this bit to terminate the command.
                                                       </td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_CMD_VAL </b></td><td>LT24 command value (see list of commands in the <a href="https://github.com/olgirard/openmsp430/blob/master/fpga/altera_de0_nano_soc/doc/Terasic/LT24/ILI9341.pdf">ILI9341 spec, section 8</a>).</td></tr>
  </tbody>
</table>

<a name="2_5_LT24_CMD_PARAM"></a>
### 2.5 LT24_CMD_PARAM

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x28</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 command parameter</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LT24_CMD_PARAM[15:8]</td>     <!-- 15 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LT24_CMD_PARAM[7:0]</td>      <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_CMD_PARAM </b></td><td style="width:100%;">LT24 parameter value (each write access to this register sends a new parameter to the ILI9343 controller).</td></tr>
  </tbody>
</table>

<a name="2_6_LT24_CMD_DFILL"></a>
### 2.6 LT24_CMD_DFILL

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x2A</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 command data fill</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LT24_CMD_DFILL[15:8]</td>     <!-- 15 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">LT24_CMD_DFILL[7:0]</td>      <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_CMD_DFILL </b></td><td style="width:100%;">Writting to this register fills the screen with the specified color (RGB 5-6-5 format).</td></tr>
  </tbody>
</table>

<a name="2_7_LT24_STATUS"></a>
### 2.7 LT24_STATUS

<tr><td align="left">&nbsp;LT24_STATUS       &nbsp;</td><td align="center">   0x2C   </td><td align="left">&nbsp;LT24 status</td></tr>
<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x2C</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 status</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">res.</td>              <!-- 15 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=3  align="center" style="word-wrap:break-word;">res.</td>               <!-- 7 ... 5 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">DATA_FILL_BUSY</td>     <!-- 4 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">WAIT_FOR_SCANLINE</td>  <!-- 3 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">REFRESH_BUSY</td>       <!-- 2 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">WAIT_PARAM</td>         <!-- 1 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">FSM_BUSY</td>           <!-- 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>DATA_FILL_BUSY </b></td><td style="width:100%;">LT24_CMD_DFILL command execution status<br>
                                                       &emsp;&emsp;<code> 0 = Idle.</code><br>
                                                       &emsp;&emsp;<code> 1 = Screen filling on going.</code><br></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>WAIT_FOR_SCANLINE </b></td><td style="width:100%;">Screen refresh state waiting for scanline synchronization value.<br>
                                                       &emsp;&emsp;<code> 0 = Not waiting.</code><br>
                                                       &emsp;&emsp;<code> 1 = Waiting for scanline sync value.</code><br></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>REFRESH_BUSY </b></td><td style="width:100%;">LT24 screen refresh status<br>
                                                       &emsp;&emsp;<code> 0 = Idle.</code><br>
                                                       &emsp;&emsp;<code> 1 = Screen refresh on going.</code><br></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>WAIT_PARAM </b></td><td style="width:100%;">LT24 command FSM waiting for a parameter<br>
                                                       &emsp;&emsp;<code> 0 = Not waiting</code><br>
                                                       &emsp;&emsp;<code> 1 = Waiting</code><br></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>FSM_BUSY </b></td><td style="width:100%;">LT24 interface FSM status<br>
                                                       &emsp;&emsp;<code> 0 = Idle</code><br>
                                                       &emsp;&emsp;<code> 1 = Busy</code><br></td></tr>
  </tbody>
</table>

<a name="2_8_LT24_IRQ"></a>
### 2.8 LT24_IRQ

<tr><td align="left">&nbsp;LT24_IRQ       &nbsp;</td><td align="center">   0x2E   </td><td align="left">&nbsp;LT24 interrupts</td></tr>
<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x2E</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>LT24 interrupts</b></td>
    </tr>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>15</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>14</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>13</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>12</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>11</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>10</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>9</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>8</b></td>
    </tr>
    <tr>
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_IRQ_REFRESH_DONE</td>   <!-- 15 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_IRQ_REFRESH_START</td>  <!-- 14 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">LT24_IRQ_REFRESH_UFLOW</td>  <!-- 13 -->
        <td colspan=5  align="center" style="word-wrap:break-word;">res.</td>                    <!-- 12 ... 8 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>7</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>6</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>5</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>4</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>3</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>2</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>1</b></td>
        <td align="center" width="12.5%" bgcolor="#E0E0E0"><b>0</b></td>
    </tr>
    <tr>
        <td colspan=8  align="center" style="word-wrap:break-word;">res.</td>              <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
  <tbody>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_IRQ_REFRESH_UFLOW</b></td><td>Screen refresh underflow interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = Screen refresh rate is respected</code><br>
                                                       &emsp;&emsp;<code>1 = Screen refresh rate is slower than configured (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_IRQ_REFRESH_START</b></td><td>Screen refresh start interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = no new screen refresh started</code><br>
                                                       &emsp;&emsp;<code>1 = a new screen refresh started (write '1' to clear)</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>LT24_IRQ_REFRESH_DONE</b></td><td>Screen refresh done interrupt flag bit<br>
                                                       &emsp;&emsp;<code>0 = no screen refresh has completed</code><br>
                                                       &emsp;&emsp;<code>1 = screen refresh completed (write '1' to clear)</code></td></tr>
  </tbody>
</table>
