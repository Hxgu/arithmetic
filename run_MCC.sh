#!/bin/bash
source /opt/Xilinx/14.7/ISE_DS/settings64.sh > /dev/null
xst -ifn design_MCC.xst > /dev/null
ngdbuild MCC.ngc > /dev/null
map MCC.ngd > /dev/null
xpwr MCC.ncd > /dev/null
