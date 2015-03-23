#!/bin/bash
source /opt/Xilinx/14.7/ISE_DS/settings64.sh > /dev/null
xst -ifn design_CCA.xst > /dev/null
ngdbuild CCA.ngc > /dev/null
map CCA.ngd > /dev/null
xpwr CCA.ncd > /dev/null
