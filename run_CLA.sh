#!/bin/bash
source /opt/Xilinx/14.7/ISE_DS/settings64.sh > /dev/null
xst -ifn design_CLA.xst > /dev/null
ngdbuild CLA.ngc > /dev/null
map CLA.ngd > /dev/null
xpwr CLA.ncd > /dev/null
