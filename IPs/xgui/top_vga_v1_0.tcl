# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "logo_hight" -parent ${Page_0}
  ipgui::add_param $IPINST -name "logo_length" -parent ${Page_0}


}

proc update_PARAM_VALUE.logo_hight { PARAM_VALUE.logo_hight } {
	# Procedure called to update logo_hight when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.logo_hight { PARAM_VALUE.logo_hight } {
	# Procedure called to validate logo_hight
	return true
}

proc update_PARAM_VALUE.logo_length { PARAM_VALUE.logo_length } {
	# Procedure called to update logo_length when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.logo_length { PARAM_VALUE.logo_length } {
	# Procedure called to validate logo_length
	return true
}


proc update_MODELPARAM_VALUE.logo_length { MODELPARAM_VALUE.logo_length PARAM_VALUE.logo_length } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.logo_length}] ${MODELPARAM_VALUE.logo_length}
}

proc update_MODELPARAM_VALUE.logo_hight { MODELPARAM_VALUE.logo_hight PARAM_VALUE.logo_hight } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.logo_hight}] ${MODELPARAM_VALUE.logo_hight}
}

