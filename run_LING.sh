#!/bin/bash
source /opt/Xilinx/14.7/ISE_DS/settings64.sh > /dev/null
xst -ifn design_LING.xst > /dev/null
ngdbuild LING.ngc > /dev/null
map LING.ngd > /dev/null
xpwr LING.ncd > /dev/null
