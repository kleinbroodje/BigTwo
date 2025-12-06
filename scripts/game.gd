extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)

func _on_vsync_toggle_toggled(toggled_off: bool) -> void:
	if toggled_off:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		$VsyncToggle.text = "Vsync: Off"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		$VsyncToggle.text = "Vsync: On"
