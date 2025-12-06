extends Node2D

const CARD_SCENE_PATH: String = "res://scenes/card.tscn"
const CARD_SPACING_X: int = 120
const HAND_WIDTH: int = 1200
const CARD_SPACING_Y: int = 10
const CARD_ROTATION: float = deg_to_rad(1)
const CARD_SCENE: PackedScene = preload(CARD_SCENE_PATH)
const HAND_OFFSET_Y = 100

#@export var height_curve: Curve
#@export var rotation_curve: Curve

var tween_position: Tween
var dragged_card: Node2D
var selected_cards: Array = []

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if dragged_card:
		dragged_card.global_position = get_global_mouse_position()
		var idx = dragged_card.get_index()
		if idx != get_child_count()-1 and dragged_card.global_position.x > get_child(idx + 1).global_position.x:
			move_child(dragged_card, idx + 1)
		elif idx != 0 and dragged_card.global_position.x < get_child(idx - 1).global_position.x:
			move_child(dragged_card, idx - 1)
		update_hand_positions()
						
func update_hand_positions():
	for idx in range(get_child_count()):
		var current_card = get_child(idx)
		
		#calculate x position
		var cards_width = CARD_SPACING_X * get_child_count()
		var card_spacing_x_offset = 0
		if cards_width > HAND_WIDTH:
			card_spacing_x_offset = (HAND_WIDTH - CARD_SPACING_X * get_child_count()) / (get_child_count() - 1)
			cards_width = HAND_WIDTH
		var final_card_spacing_x = CARD_SPACING_X + card_spacing_x_offset
		var x_pos = global_position.x + (idx-float(get_child_count())/2+0.5) * final_card_spacing_x
			
		#calculate y position and rotation
		#var hand_ratio = float(idx)/float(get_child_count() - 1) #give number between 0-1 depending on index
		#current_card.global_position.y = global_position.y + height_curve.sample(hand_ratio) * CARD_SPACING_Y
		#current_card.rotation = rotation_curve.sample(hand_ratio) * CARD_ROTATION
		
		var y_pos = global_position.y
		if current_card.selected:
			y_pos -= 50
		
		current_card.move(Vector2(x_pos, y_pos))
			
func _on_card_released(card):
	if not card.dragged:
		if card in selected_cards:
			selected_cards.erase(card)
			card.selected = false
		else:
			selected_cards.append(card)
			card.selected = true
	dragged_card = null
	update_hand_positions()
	
func _on_card_dragged(card):
	dragged_card = card
	
func move(pos: Vector2) -> void:
	if tween_position and tween_position.is_running():
		tween_position.kill()
	tween_position = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween_position.tween_property(self, "global_position", pos, 0.5)

func _on_remove_card_button_pressed() -> void:
	var child = get_child(0)
	remove_child(child)
	update_hand_positions()

func _on_add_card_button_pressed() -> void:
	var new_card = CARD_SCENE.instantiate()
	new_card.suit = CardDefs.CardSuit.SPADES
	new_card.value = CardDefs.CardValue.TWO
	new_card.card_released.connect(_on_card_released)
	new_card.card_dragged.connect(_on_card_dragged)
	add_child(new_card)
	update_hand_positions()
