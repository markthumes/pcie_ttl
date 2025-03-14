#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/mark/software/amd/installed/Vitis/2024.2/bin:/home/mark/software/amd/installed/Vivado/2024.2/ids_lite/ISE/bin/lin64:/home/mark/software/amd/installed/Vivado/2024.2/bin
else
  PATH=/home/mark/software/amd/installed/Vitis/2024.2/bin:/home/mark/software/amd/installed/Vivado/2024.2/ids_lite/ISE/bin/lin64:/home/mark/software/amd/installed/Vivado/2024.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/mark/fpga/src/zcu106/pcie_led_ex_design/pcie4_uscale_plus_0_ex/pcie4_uscale_plus_0_ex.runs/clk_wiz_0_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log clk_wiz_0.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source clk_wiz_0.tcl
