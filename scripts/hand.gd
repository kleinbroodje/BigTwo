extends Node2D
class_name Hand

@export var max_cards : int
@export var card_spacing_x : int
@export var hand_width : int


func update_hand_positions() -> void:
	# Calculate x spacing between cards
	var cards_width := card_spacing_x * get_child_count()
	var card_spacing_x_offset := 0.0

	if cards_width > hand_width:
		card_spacing_x_offset = (hand_width - card_spacing_x
			* get_child_count()) / float(get_child_count() - 1)
		cards_width = hand_width

	var final_card_spacing_x := card_spacing_x + card_spacing_x_offset
	
	# Calculate x and y pos per card
	for idx in range(get_child_count()):
		var current_card: Node2D = get_child(idx)

		var x_pos := global_position.x + (idx - float(get_child_count())
			/ 2 + 0.5) * final_card_spacing_x
		var y_pos := global_position.y
		
		var pos: Vector2 = _pre_card_move(current_card, x_pos, y_pos)

		current_card.move(pos)
		
		
# template method: can be used by child class to change position before card is moved
func _pre_card_move(_card: Node, x: float, y: float) -> Vector2:
	return Vector2(x, y)
