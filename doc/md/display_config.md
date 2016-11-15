<a name="top"></a>
# Display configuration registers

#### Table of content

*   [1. Introduction](#1_introduction)
*   [2. Registers](#2_registers)
    *   [2.1 DISPLAY_WIDTH](#2_1_DISPLAY_WIDTH)
    *   [2.2 DISPLAY_HEIGHT](#2_2_DISPLAY_HEIGHT)
    *   [2.3 DISPLAY_SIZE (LO/HI)](#2_3_DISPLAY_SIZE_LO_HI)
    *   [2.4 DISPLAY_CFG](#2_4_DISPLAY_CFG)
    *   [2.5 DISPLAY_REFR_CNT](#2_5_DISPLAY_REFR_CNT)

<a name="1_introduction"></a>
## 1. Introduction

This section describes the display configuration registers.  
These registers allow to configure the width, height and size of the screen as well as the order pixels are read during a screen refresh.  

<a name="2_registers"></a>
## 2. Registers

<a name="2_1_DISPLAY_WIDTH"></a>
### 2.1 DISPLAY_WIDTH

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x10</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Display pixel width</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_WIDTH[15:8]</td>        <!-- 15 ... 8 -->
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_WIDTH[7:0]</td>        <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>D_WIDTH</b></td><td style="width:100%;">Display pixel width</td></tr>
</tbody>
</table>

<a name="2_2_DISPLAY_HEIGHT"></a>
### 2.2 DISPLAY_HEIGHT

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x12</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Display pixel height</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_HEIGHT[15:8]</td>        <!-- 15 ... 8 -->
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_HEIGHT[7:0]</td>        <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>D_HEIGHT</b></td><td style="width:100%;">Display pixel height</td></tr>
</tbody>
</table>

<a name="2_3_DISPLAY_SIZE_LO_HI"></a>
### 2.3 DISPLAY_SIZE (LO/HI)

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x14</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>DISPLAY_SIZE_LO<br>&nbsp;Display pixel size low (bits 0 to 15)</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_SIZE[15:8]</td>        <!-- 15 ... 8 -->
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_SIZE[7:0]</td>        <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x16</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>DISPLAY_SIZE_HI<br>&nbsp;Display pixel size high (bits 16 to 31)</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_SIZE[31:24]</td>        <!-- 15 ... 8 -->
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_SIZE[23:16]</td>        <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>D_SIZE</b></td><td style="width:100%;">Display pixel size (must be equal to D_WIDTH*D_HEIGHT )</td></tr>
</tbody>
</table>

<a name="2_4_DISPLAY_CFG"></a>
### 2.4 DISPLAY_CFG

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x18</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Display configuration register</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">res.</td>        <!-- 15 ... 8 -->
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
        <td colspan=5  align="center" style="word-wrap:break-word;">res.</td>         <!-- 7 ... 3 -->
        <td colspan=1  align="center" style="word-wrap:break-word;">D_X_SWAP</td>     <!-- 2       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">D_Y_SWAP</td>     <!-- 1       -->
        <td colspan=1  align="center" style="word-wrap:break-word;">D_CL_SWAP</td>    <!-- 0       -->
    </tr>
  </tbody>
</table>
The D_*_SWAP configuration registers allow to control in which order the frame buffer pixels are read during a screen refresh:

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>D_X_SWAP  </b></td><td style="width:100%;">X-axis address generation for the frame buffer read during screen refresh<br>
                                                       &emsp;&emsp;<code>0 = scan rows from left to right</code><br>
                                                       &emsp;&emsp;<code>1 = scan rows from right to left</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>D_Y_SWAP  </b></td><td>Y-axis address generation for the frame buffer read during screen refresh<br>
                                                       &emsp;&emsp;<code>0 = scan columns from top to bottom</code><br>
                                                       &emsp;&emsp;<code>1 = scan columns from bottom to top</code></td></tr>
    <tr><td valign="top">&#8226;&emsp;<b>D_CL_SWAP </b></td><td>Swap Columns and lines for the address generation of the frame buffer read during screen refresh<br>
                                                       &emsp;&emsp;<code>0 = horizontal scan (i.e. read along the rows)</code><br>
                                                       &emsp;&emsp;<code>1 = vertical scan (i.e. read along the columns)</code></td></tr>
</tbody>
</table>

The following picture illustrates how the frame buffer is read according to the different configurations, and how the picture will look like on the screen, depending on how the screen is refreshed.

![Frame buffer read refresh config](https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/display_cfg.png "Frame buffer read refresh config")  
_(open in a new tab to zoom in)_

<a name="2_5_DISPLAY_REFR_CNT"></a>
### 2.5 DISPLAY_REFR_CNT

<table border="1" style="table-layout:fixed; width:100%; font-size:.8em">
  <tbody>
    <tr>
        <td colspan=2 bgcolor="#B0B0B0">&nbsp;<b>Address: 0x1A</b></td>
        <td colspan=6 bgcolor="#B0B0B0">&nbsp;<b>Display refresh counter</b></td>
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_REFR_CNT[15:8]</td>        <!-- 15 ... 8 -->
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
        <td colspan=8  align="center" style="word-wrap:break-word;">D_REFR_CNT[7:0]</td>        <!-- 7 ... 0 -->
    </tr>
  </tbody>
</table>

<table border="0">
<tbody>
    <tr><td valign="top">&#8226;&emsp;<b>D_REFR_CNT  </b></td><td style="width:100%;">The display refresh counter can be initialized to 
                                                                  any value by software and is automaticaly decremented after each
                                                                  screen refresh until it reaches 0x0000.<br>
                                                                  The <a href="https://github.com/olgirard/opengfx430/blob/master/doc/md/global_control.md#2_3_GFX_IRQ">GFX_IRQ.IF_RCDONE</a> interrupt flag is set when the counter reaches zero. </td></tr>
</tbody>
</table>

