extends Node2D
class_name Hand

signal cards_played

const CARD_SPACING_X := 120
const HAND_WIDTH := 1200
const CARD_SPACING_Y := 10
const CARD_ROTATION := deg_to_rad(1)
const HAND_OFFSET_Y := 100

#@export var height_curve: Curve
#@export var rotation_curve: Curve

var tween_position: Tween
var dragged_card: Card
var selected_cards: Array[Card] = []

func _process(_delta: float) -> void:
	if dragged_card:
		update_dragging()
						
func update_hand_positions() -> void:
	for idx in range(get_child_count()):
		var current_card := get_child(idx)
		
		#calculate x position
		var cards_width := CARD_SPACING_X * get_child_count()
		var card_spacing_x_offset := 0.0
		if cards_width > HAND_WIDTH:
			card_spacing_x_offset = (HAND_WIDTH - CARD_SPACING_X * get_child_count()) / float(get_child_count() - 1)
			cards_width = HAND_WIDTH
		var final_card_spacing_x := CARD_SPACING_X + card_spacing_x_offset
		var x_pos := global_position.x + (idx - float(get_child_count()) / 2 + 0.5) * final_card_spacing_x
			
		#calculate y position and rotation
		#var hand_ratio = float(idx)/float(get_child_count() - 1) #give number between 0-1 depending on index
		#current_card.global_position.y = global_position.y + height_curve.sample(hand_ratio) * CARD_SPACING_Y
		#current_card.rotation = rotation_curve.sample(hand_ratio) * CARD_ROTATION
		
		var y_pos := global_position.y
		if current_card in selected_cards:
			y_pos -= 50
		
		current_card.move(Vector2(x_pos, y_pos))

func update_dragging() -> void:
	dragged_card.global_position = get_global_mouse_position()
	var idx := dragged_card.get_index()
	if idx != get_child_count() - 1 and dragged_card.global_position.x > get_child(idx + 1).global_position.x:
		move_child(dragged_card, idx + 1)
	elif idx != 0 and dragged_card.global_position.x < get_child(idx - 1).global_position.x:
		move_child(dragged_card, idx - 1)
	update_hand_positions()
	
func move(pos: Vector2) -> void:
	if tween_position and tween_position.is_running():
		tween_position.kill()
	tween_position = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween_position.tween_property(self, "global_position", pos, 0.5)
			
func _on_card_released(card: Card) -> void:
	if card != dragged_card:
		card.toggle_selected()
		if card in selected_cards:
			selected_cards.erase(card)
		else:
			selected_cards.append(card)
	dragged_card = null
	update_hand_positions()
	
func _on_card_dragged(card: Card) -> void:
	dragged_card = card

func _on_add_card_button_pressed() -> void:
	var new_card := Card.new_card(
	CardDefs.CardValue.TWO,
	CardDefs.CardSuit.SPADES,
	)
	new_card.card_dragged.connect(_on_card_dragged)
	new_card.card_released.connect(_on_card_released)
	add_child(new_card)
	update_hand_positions()

func _on_remove_card_button_pressed() -> void:
	var child := get_child(0)
	remove_child(child)
	update_hand_positions()
	
func _on_play_cards_button_pressed() -> void:
	var selected_cards_data: Array[Dictionary] = []
	for card in selected_cards:
		selected_cards_data.append(Card.card_to_dict(card))
		remove_child(card)
	selected_cards.clear()
	update_hand_positions()
	rpc("play_cards", multiplayer.get_unique_id(), selected_cards_data)
	
@rpc("any_peer", "call_local")
func play_cards(player_id: int, cards_data: Array[Dictionary]) -> void:
	var played_cards: Array[Card] = []
	for card_data in cards_data:
		var new_card := Card.dict_to_card(card_data)
		played_cards.append(new_card)
	emit_signal("cards_played", played_cards)
	print(player_id, cards_data)
