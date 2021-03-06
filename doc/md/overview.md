<a name="top"></a>
# openGFX430 Overview

## 1. Introduction

The openGFX430 is a synthesizable Graphic controller written in Verilog and tailored for the [openMSP430](https://github.com/olgirard/openmsp430) core.

![GFX Design Structure](https://raw.githubusercontent.com/olgirard/opengfx430/master/doc/images/gfx_structure.png "GFX Design Structure")

An example implementation based on the [DE0-Nano-SoC](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=941) and [LT24 daughter board](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=892) from Terasic can be found in the openMSP430 FPGA section ([see here](https://github.com/olgirard/openmsp430/tree/master/fpga/altera_de0_nano_soc)).

## 2. Features & TODOs

### Features

*   Support of the following graphic modes:
    *   16bpp
    *   8bpp
    *   4bpp
    *   2bpp
    *   1bpp
*   Smart address generation unit for fast indirect memory access.
*   GPU allowing hardware FILL, COPY and COPY_TRANSPARENT operations.
*   Supports the [LT24](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=65&No=892) Terasic daughter card.

### TODOs

In no particular priority order:

*   RTL:
    *   Add support popular video interfaces (i.e. probably SPI and VGA in addition to LT24).
    *   Character processing unit.
    *   Hardware cursor.
*   Others:
    *   Add proper block level verification environment.
    *   Documentation.

## 3. Download

### Design

* The project's official releases are available on [OpenCores](http://opencores.org/project,opengfx430).

The complete tar archive of the project is downloadable [here](http://www.opencores.org/download,opengfx430) (OpenCores account required) and the SVN repository can be exported with the following command:

`svn export http://opencores.org/ocsvn/opengfx430/opengfx430/trunk/ opengfx430`

* The project's working environment is hosted here on [GitHub](https://github.com/olgirard/opengfx430).

The complete zip archive of the project is downloadable [here](https://github.com/olgirard/opengfx430/archive/master.zip) and the GIT repository can be clonned with the following command:

 `git clone https://github.com/olgirard/opengfx430.git`


### ChangeLog

*   The [Core's ChangeLog](http://opencores.org/websvn,filedetails?repname=opengfx430&path=/opengfx430/trunk/ChangeLog_core.txt) lists the Video Controller updates.
*   Subscribe to the following [RSS](http://opencores.org/websvn,rss?repname=opengfx430&path=/opengfx430/&isdir=1) feed to keep yourself informed about ALL updates.
