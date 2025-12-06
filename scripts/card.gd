extends Node2D

signal card_dragged
signal card_released

@export var value: CardDefs.CardValue
@export var suit: CardDefs.CardSuit

@onready var card_image: Sprite2D = $CardImage
@onready var click_timer: Timer = $ClickTimer

var suit_names: Array = ["diamonds", "clubs", "hearts", "spades"]
var value_names: Array = ["03", "04", "05", "06", "07", "08", "09", 
"10", "jack", "queen", "king", "ace", "02"]

var pressed: bool = false
var selected: bool = false
var dragged: bool = false
var click_time: float = 0.1
var tween_position: Tween

func _ready() -> void:
	card_image.texture = load("res://assets/images/cards/%s_%s.png" % [suit_names[suit], value_names[value]])
	click_timer.one_shot = true
	
func _process(delta: float) -> void:
	if not dragged and pressed and 	click_timer.time_left == 0:
		dragged = true
		card_dragged.emit(self)
	elif dragged and not pressed:
		dragged = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and pressed:
		pressed = false
		card_released.emit(self)
		
func _on_card_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pressed = true
			click_timer.start(click_time)
			
func move(pos: Vector2) -> void:
	if tween_position and tween_position.is_running():
		tween_position.kill()
	tween_position = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween_position.tween_property(self, "global_position", pos, 0.5)
