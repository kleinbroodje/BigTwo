extends Node
class_name Game

@onready var hand: Hand = get_node("Hand")
@onready var playing_field: Control = get_node("PlayingField")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)

func _on_vsync_toggle_toggled(toggled_off: bool) -> void:
	if toggled_off:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_node("VsyncToggle").text = "Vsync: Off"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		get_node("VsyncToggle").text = "Vsync: On"

func _on_play_cards_button_pressed() -> void:
	var selected_cards_data: Array[Dictionary] = []
	for card in hand.selected_cards:
		selected_cards_data.append({
			"value": card.value,
			"suit": card.suit
		})
		hand.remove_child(card)
	hand.update_hand_positions()
	rpc("play_cards", get_tree().get_multiplayer().get_unique_id(), selected_cards_data)

@rpc("any_peer", "call_local")
func play_cards(player_id: int, cards_data: Array[Dictionary]) -> void:
	for card_data in cards_data:
		var new_card := Card.create_new_card(
			card_data["value"],
			card_data["suit"]
		)
		playing_field.add_child(new_card)
	print(player_id, cards_data)
