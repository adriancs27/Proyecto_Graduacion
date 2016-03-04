@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xsim TB_COUNTER_5B_behav -key {Behavioral:sim_1:Functional:TB_COUNTER_5B} -tclbatch TB_COUNTER_5B.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
