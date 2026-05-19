extends Control
class_name UIManager
	
@onready var vsync_toggle: Button = get_node("VsyncToggle")
@onready var play_cards_button: Button = get_node("PlayCardsButton")


func _ready() -> void:
	toggle_play_cards_button()
	
	
func _on_vsync_toggle_toggled(toggled_off: bool) -> void:
	if toggled_off:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		vsync_toggle.text = "Vsync: Off"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		vsync_toggle.text = "Vsync: On"


func toggle_play_cards_button() -> void:
	play_cards_button.disabled = !play_cards_button.disabled


func is_play_cards_button_disabled() -> bool:
	return play_cards_button.disabled
