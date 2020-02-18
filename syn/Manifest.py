action = "synthesis"

syn_device = "xc7a35ti"
syn_grade = "-1L"
syn_package = "csg324"
syn_top = "top"
syn_project = "top"
syn_tool = "vivado"
syn_properties = [
    ["steps.write_bitstream.args.bin_file", "1"] # Generate a bin file for flash programming in addition to the bitstream file
]

# Produce a timing report after synthesis and implementation
syn_post_synthesize_cmd = "$(TCL_INTERPRETER) vivado_syn_timing_report.tcl"
syn_post_par_cmd        = "$(TCL_INTERPRETER) vivado_impl_timing_report.tcl"

modules = {
  "local" : [ "../top" ],
}
