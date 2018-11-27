# 
# Report generation script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config  -ruleid {1}  -id {[BD 41-1306]}  -suppress 
set_msg_config  -ruleid {2}  -id {[BD 41-1271]}  -suppress 

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  open_checkpoint mcs_top_vanilla_routed.dcp
  set_property webtalk.parent_dir C:/Users/runne/Desktop/Soc_FPGA/Bui_Final_Project/Bui_Final/Bui_Final.cache/wt [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files c:/Users/runne/Desktop/Soc_FPGA/Bui_Final_Project/Bui_Final/Bui_Final.srcs/sources_1/ip/cpu/bd_0/ip/ip_0/data/mb_bootloop_le.elf
  set_property SCOPED_TO_REF cpu [get_files -all c:/Users/runne/Desktop/Soc_FPGA/Bui_Final_Project/Bui_Final/Bui_Final.srcs/sources_1/ip/cpu/bd_0/ip/ip_0/data/mb_bootloop_le.elf]
  set_property SCOPED_TO_CELLS U0/microblaze_I [get_files -all c:/Users/runne/Desktop/Soc_FPGA/Bui_Final_Project/Bui_Final/Bui_Final.srcs/sources_1/ip/cpu/bd_0/ip/ip_0/data/mb_bootloop_le.elf]
  catch { write_mem_info -force mcs_top_vanilla.mmi }
  catch { write_bmm -force mcs_top_vanilla_bd.bmm }
  write_bitstream -force mcs_top_vanilla.bit 
  catch { write_sysdef -hwdef mcs_top_vanilla.hwdef -bitfile mcs_top_vanilla.bit -meminfo mcs_top_vanilla.mmi -file mcs_top_vanilla.sysdef }
  catch {write_debug_probes -quiet -force mcs_top_vanilla}
  catch {file copy -force mcs_top_vanilla.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

