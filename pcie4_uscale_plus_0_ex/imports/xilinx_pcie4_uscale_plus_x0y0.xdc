##-----------------------------------------------------------------------------
##
## (c) Copyright 1995, 2007, 2023 Advanced Micro Devices, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of AMD, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## AMD, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) AMD shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or AMD had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## AMD products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of AMD products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
##-----------------------------------------------------------------------------
##
## Project    : UltraScale+ FPGA PCI Express v4.0 Integrated Block
## File       : xilinx_pcie4_uscale_plus_x0y0.xdc
## Version    : 1.3 
##-----------------------------------------------------------------------------
#
###############################################################################
# Vivado - PCIe GUI / User Configuration 
###############################################################################
#
# Family              # zynquplus
# Part                # xczu7ev
# Package             # ffvc1156
# Speed grade         # -2
# PCIe Block          # X0Y0
# Xilinx BNo          # 4
#
# Link Speed          # Gen3 - 8.0 Gb/s
# Link Width          # X4
# AXIST Width         # 128-bit
# AXIST Frequ         # 250 MHz = User Clock
# Core Clock          # 250 MHz
# Pipe Clock          # 125 MHz (Gen1) : 250 MHz (Gen2/Gen3/Gen4)
# PLL TYPE            # QPLL1
# MSI-X TYPE          # HARD
#
# master_gt_quad_inx  # 3
# master_gt_container # 1
# gt_type             # gthe4
#
# Xilinx Reference Board is ZCU106
#
###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -name sys_clk -period 10 [get_ports sys_clk_p]
# False path constraint on sys_rst_n is now moved to IP level *_impl_*.xdc file. Please check design source/* area for reference.
# set_false_path -from [get_ports sys_rst_n]
set_property PULLUP true [get_ports sys_rst_n]

set_property IOSTANDARD LVCMOS18 [get_ports sys_rst_n]
#
#set_property PACKAGE_PIN L8 [get_ports sys_rst_n]

#
set_property PACKAGE_PIN AB7 [get_ports sys_clk_n]
set_property PACKAGE_PIN AB8 [get_ports sys_clk_p]
#

# LEDs for ZCU106
set_property PACKAGE_PIN AL11 [get_ports led_0]
# user_link_up
set_property PACKAGE_PIN AL13 [get_ports led_1]
# Clock Up/Heart Beat(HB)
set_property PACKAGE_PIN AK13 [get_ports led_2]
# cfg_current_speed[0] => 00: Gen1; 01: Gen2; 10:Gen3; 11:Gen4
set_property PACKAGE_PIN AE15 [get_ports led_3]
# cfg_current_speed[1]
set_property PACKAGE_PIN AM8 [get_ports led_4]
# cfg_negotiated_width[0] => 000: x1; 001: x2; 010: x4; 011: x8; 100: x16 
set_property PACKAGE_PIN AM9 [get_ports led_5]
# cfg_negotiated_width[1]
set_property PACKAGE_PIN AM10 [get_ports led_6]
# cfg_negotiated_width[2]
set_property PACKAGE_PIN AM11 [get_ports led_7]
#

set_property IOSTANDARD LVCMOS12 [get_ports led_0]
set_property IOSTANDARD LVCMOS12 [get_ports led_1]
set_property IOSTANDARD LVCMOS12 [get_ports led_2]
set_property IOSTANDARD LVCMOS12 [get_ports led_3]
set_property IOSTANDARD LVCMOS12 [get_ports led_4]
set_property IOSTANDARD LVCMOS12 [get_ports led_5]
set_property IOSTANDARD LVCMOS12 [get_ports led_6]
set_property IOSTANDARD LVCMOS12 [get_ports led_7]
#
set_property DRIVE 8 [get_ports led_0]
set_property DRIVE 8 [get_ports led_1]
set_property DRIVE 8 [get_ports led_2]
set_property DRIVE 8 [get_ports led_3]
set_property DRIVE 8 [get_ports led_4]
set_property DRIVE 8 [get_ports led_5]
set_property DRIVE 8 [get_ports led_6]
set_property DRIVE 8 [get_ports led_7]

#
set_false_path -to [get_ports -filter NAME=~led_*]
#
# Clock for the 300 MHz clock is already created in the Clock Wizard IP.
# 300 MHz clock pin constraints.
set_property IOSTANDARD DIFF_SSTL12 [get_ports clk_300MHz_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports clk_300MHz_n]
set_property PACKAGE_PIN AH12 [get_ports clk_300MHz_p]
set_property PACKAGE_PIN AJ12 [get_ports clk_300MHz_n]
#
#
# CLOCK_ROOT LOCKing to Reduce CLOCK SKEW
# Add/Edit  Clock Routing Option to improve clock path skew
#
# BITFILE/BITSTREAM compress options
# ##############################################################################
# Flash Programming Example Settings: These should be modified to match the target board.
# ##############################################################################
#
#
# sys_clk vs TXOUTCLK
set_clock_groups -name async18 -asynchronous -group [get_clocks {sys_clk}] -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
#
# clk_300MHz vs TXOUTCLK
set_clock_groups -name async22 -asynchronous -group [get_clocks -of_objects [get_ports clk_300MHz_p]] -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
#
#
#
set_clock_groups -name asynco -asynchronous -group [get_clocks -of_objects [get_pins mem_clk_inst/clk_out1]] -group [get_clocks {sys_clk}]
#
#
#
# ASYNC CLOCK GROUPINGS
#
#
# Timing improvement
# Add/Edit Pblock slice constraints for init_ctr module to improve timing
#create_pblock init_ctr_rst; add_cells_to_pblock [get_pblocks init_ctr_rst] [get_cells pcie4_uscale_plus_0_i/inst/pcie4_uscale_plus_0_pcie_4_0_pipe_inst/pcie_4_0_init_ctrl_inst]
# Keep This Logic Left/Right Side Of The PCIe Block (Whichever is near to the FPGA Boundary)
#resize_pblock [get_pblocks init_ctr_rst] -add {SLICE_X100Y0:SLICE_X111Y59}
#
set_clock_groups -name async24 -asynchronous -group [get_clocks -of_objects [get_pins pcie4_uscale_plus_0_i/inst/pcie4_uscale_plus_0_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_intclk/O]] -group [get_clocks {sys_clk}]
#
#create_waiver -type METHODOLOGY -id {LUTAR-1} -user "pcie4_uscale_plus" -desc "user link up is synchroized in the user clk so it is safe to ignore"  -internal -scoped -tags 1024539  -objects [get_cells { pcie_app_uscale_i/PIO_i/len_i[5]_i_4 }] -objects [get_pins { pcie4_uscale_plus_0_i/inst/user_lnk_up_cdc/arststages_ff_reg[0]/CLR pcie4_uscale_plus_0_i/inst/user_lnk_up_cdc/arststages_ff_reg[1]/CLR }] 

#--------------------- Adding waiver --------------------#

create_waiver -type DRC -id {REQP-1839} -tags "1167240" -scope -internal -user "pcie4_uscale_plus" -desc "DRC expects synchronous pins to be provided to BRAM inputs. Since synchronization is present one stage before, it is safe to ignore" -objects [get_cells -hierarchical -filter {NAME =~ {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/ep_xpm_sdpram/*mem_reg_bram_0}}]
create_waiver -type DRC -id {REQP-1840} -tags "1167240" -scope -internal -user "pcie4_uscale_plus" -desc "DRC expects synchronous pins to be provided to BRAM inputs. Since synchronization is present one stage before, it is safe to ignore" -objects [get_cells -hierarchical -filter {NAME =~ {pcie_app_uscale_i/PIO_i/pio_ep/ep_mem/ep_xpm_sdpram/*mem_reg_bram_0}}]

create_waiver -type CDC -id {CDC-1} -tags "1165868" -scope -internal -user "pcie4_uscale_plus" -desc "PCIe reset path -Safe to waive" -from [get_ports sys_rst_n] -to [get_pins -hier -filter {NAME =~ {*/user_clk_heartbeat_reg[*]/R}}]

