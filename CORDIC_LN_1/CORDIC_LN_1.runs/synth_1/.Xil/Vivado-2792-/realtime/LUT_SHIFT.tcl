# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    set ::env(RT_TMP) "C:/Users/Adri�n/Desktop/CORDIC_LN_1/CORDIC_LN_1.runs/synth_1/.Xil/Vivado-2792-/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xa7a15tcpg236-2I
    source $::env(HRT_TCL_PATH)/rtSynthParallelPrep.tcl

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog C:/Users/Adri�n/Desktop/CORDIC_LN_1/CORDIC_LN_1.srcs/sources_1/new/LUT_SHIFT.v
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top LUT_SHIFT
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops true
    rt::set_parameter webTalkPath {C:/Users/Adri�n/Desktop/CORDIC_LN_1/CORDIC_LN_1.cache/wt}
    rt::set_parameter enableSplitFlowPath "C:/Users/Adri�n/Desktop/CORDIC_LN_1/CORDIC_LN_1.runs/synth_1/.Xil/Vivado-2792-/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
      rt::run_synthesis -module $rt::top
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    if { $rt::flowresult == 1 } { return -code error }

    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }


    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  if { [info exists rt::helper_shm_key] && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] && [info exists rt::doParallel] && $rt::doParallel} { 
     $rt::db killSynthHelper $rt::helper_shm_key
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
