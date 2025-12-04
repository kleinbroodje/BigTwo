extends Node2D

@export var value: CardDefs.CardValue
@export var suit: CardDefs.CardSuit

var suit_names = ["diamonds", "clubs", "hearts", "spades"]
var value_names = ["03", "04", "05", "06", "07", "08", "09", 
"10", "jack", "queen", "king", "ace", "02"]

var touching = false
var tween_hover: Tween

func _ready() -> void:
	$CardImage.texture = load("res://assets/images/cards/%s_%s.png" 
	% [suit_names[suit], value_names[value]])

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and touching:
		position = get_global_mouse_position()
		get_parent().move_child(self, -1)

func _on_card_area_mouse_entered() -> void:
	touching = true
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)

func _on_card_area_mouse_exited() -> void:
	touching = false
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)
