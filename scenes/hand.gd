extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_SPACING_X = 110
const HAND_WIDTH = 1210
const CARD_SPACING_Y = 10
const CARD_ROTATION = deg_to_rad(1)

@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve

const CARD_SCENE  = preload(CARD_SCENE_PATH)

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	for idx in range(get_child_count()):
		var current_card = get_child(idx)
		
		#calculate x position
		var cards_width = CARD_SPACING_X * get_child_count()
		var card_spacing_x_offset = 0
		if cards_width > HAND_WIDTH:
			card_spacing_x_offset = (HAND_WIDTH - CARD_SPACING_X * get_child_count()) / (get_child_count() - 1)
			cards_width = HAND_WIDTH
		var final_card_spacing_x = CARD_SPACING_X + card_spacing_x_offset
		current_card.global_position.x = global_position.x + (idx-float(get_child_count())/2+0.5) * final_card_spacing_x
		
		#calculate y position and rotation
		#var hand_ratio = float(idx)/float(get_child_count() - 1) #give number between 0-1 depending on index
		#current_card.global_position.y = global_position.y + height_curve.sample(hand_ratio) * CARD_SPACING_Y
		#current_card.rotation = rotation_curve.sample(hand_ratio) * CARD_ROTATION

func _on_remove_card_button_pressed() -> void:
	var child = get_child(0)
	remove_child(child)

func _on_add_card_button_pressed() -> void:
	var new_card = CARD_SCENE.instantiate()
	new_card.suit = CardDefs.CardSuit.SPADES
	new_card.value = CardDefs.CardValue.TWO
	add_child(new_card)
	print(get_child_count())
