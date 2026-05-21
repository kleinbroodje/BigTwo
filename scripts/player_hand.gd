extends Hand
class_name PlayerHand

signal cards_played
signal card_selected

var dragged_card: PlayerCard
var selected_cards: Array[Card] = []


func _process(_delta: float) -> void:
	if dragged_card:
		update_dragging()


func _pre_card_move(card: Node, x: float, y: float) -> Vector2:
	var new_y: float = y
	if card in selected_cards:
		new_y -= 50
	return Vector2(x, new_y)
	 

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


func _on_card_released(card: PlayerCard) -> void:
	if card != dragged_card:
		if card in selected_cards:
			selected_cards.erase(card)
		else:
			selected_cards.append(card)
			
		card_selected.emit(selected_cards)
			
	dragged_card = null
	update_hand_positions()


func _on_card_dragged(card: PlayerCard) -> void:
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
	var new_card := PlayerCard.from_dict(card_data)
	new_card.connect("card_dragged", _on_card_dragged)
	new_card.connect("card_released", _on_card_released)
	add_child(new_card)
