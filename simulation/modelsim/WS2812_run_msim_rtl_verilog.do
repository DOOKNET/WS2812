transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Workspace/Quartues_16.1/Learning/2017_12_5_WS2812/Design/Code {E:/Workspace/Quartues_16.1/Learning/2017_12_5_WS2812/Design/Code/RZ_Code.v}
vlog -vlog01compat -work work +incdir+E:/Workspace/Quartues_16.1/Learning/2017_12_5_WS2812/Design/Code {E:/Workspace/Quartues_16.1/Learning/2017_12_5_WS2812/Design/Code/RGB_Control.v}

vlog -vlog01compat -work work +incdir+E:/Workspace/Quartues_16.1/Learning/2017_12_5_WS2812/TestBeach {E:/Workspace/Quartues_16.1/Learning/2017_12_5_WS2812/TestBeach/tb_RZ.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_RZ

add wave *
view structure
view signals
run -all
