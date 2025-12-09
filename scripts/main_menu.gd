extends Control
class_name MainMenu

func _on_host_game_button_pressed() -> void:
	NetworkHandler.start_server()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_join_game_button_pressed() -> void:
	NetworkHandler.start_client()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
