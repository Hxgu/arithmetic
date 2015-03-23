#!/bin/bash
source /opt/Xilinx/14.7/ISE_DS/settings64.sh > /dev/null
xst -ifn design_CSA.xst > /dev/null
ngdbuild CSA.ngc > /dev/null
map CSA.ngd > /dev/null
xpwr CSA.ncd > /dev/null
