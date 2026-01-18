extends Control
	
	
func _on_vsync_toggle_toggled(toggled_off: bool) -> void:
	if toggled_off:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_node("VsyncToggle").text = "Vsync: Off"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		get_node("VsyncToggle").text = "Vsync: On"
