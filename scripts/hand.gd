extends Node2D
class_name Hand

signal cards_played
signal card_selected

const MAX_CARDS := 13
const CARD_SPACING_X := 120
const HAND_WIDTH := 1200

var dragged_card: Card
var selected_cards: Array[Card] = []


func _process(_delta: float) -> void:
	if dragged_card:
		update_dragging()


func update_hand_positions() -> void:
	# Calculate x spacing between cards
	var cards_width := CARD_SPACING_X * get_child_count()
	var card_spacing_x_offset := 0.0

	if cards_width > HAND_WIDTH:
		card_spacing_x_offset = (HAND_WIDTH - CARD_SPACING_X
			* get_child_count()) / float(get_child_count() - 1)
		cards_width = HAND_WIDTH

	var final_card_spacing_x := CARD_SPACING_X + card_spacing_x_offset
	
	# Calculate x and y pos per card
	for idx in range(get_child_count()):
		var current_card := get_child(idx)

		var x_pos := global_position.x + (idx - float(get_child_count())
			/ 2 + 0.5) * final_card_spacing_x
		var y_pos := global_position.y
		
		if current_card in selected_cards:
			y_pos -= 50

		current_card.move(Vector2(x_pos, y_pos))


func update_dragging() -> void:
	dragged_card.global_position = get_global_mouse_position()
	var idx := dragged_card.get_index()
	
	if (
		idx != get_child_count() - 1
		and dragged_card.global_position.x
		> get_child(idx + 1).global_position.x
	):
		move_child(dragged_card, idx + 1)
	elif (
		idx != 0
		and dragged_card.global_position.x
		< get_child(idx - 1).global_position.x
	):
		move_child(dragged_card, idx - 1)
		
	update_hand_positions()


func _on_card_released(card: Card) -> void:
	if card != dragged_card:
		if card in selected_cards:
			selected_cards.erase(card)
		else:
			selected_cards.append(card)
			
		card_selected.emit(selected_cards)
			
	dragged_card = null
	update_hand_positions()


func _on_card_dragged(card: Card) -> void:
	dragged_card = card


func _on_play_cards_button_pressed() -> void:
	var cards_data: Array[Dictionary] = []
	for card in selected_cards:
		cards_data.append(card.to_dict())
		remove_child(card)
		card.free()
		
	selected_cards.clear()
	cards_played.emit(cards_data)  
	update_hand_positions()


func add_card(card_data: Dictionary) -> void:
	var new_card := Card.from_dict(card_data)
	new_card.connect("card_dragged", _on_card_dragged)
	new_card.connect("card_released", _on_card_released)
	add_child(new_card)
