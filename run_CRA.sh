#!/bin/bash
source /opt/Xilinx/14.7/ISE_DS/settings64.sh > /dev/null
xst -ifn design_CRA.xst > /dev/null
ngdbuild CRA.ngc > /dev/null
map CRA.ngd > /dev/null
xpwr CRA.ncd > /dev/null
