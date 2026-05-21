extends Card
class_name PlayerCard

signal card_dragged
signal card_released

const PLAYER_CARD_SCENE_PATH := "res://scenes/player_card.tscn"
const PLAYER_CARD_SCENE := preload(PLAYER_CARD_SCENE_PATH)

@onready var click_timer: Timer = get_node("ClickTimer")

var pressed := false
var dragged := false
var click_time := 0.1


static func new_card(
	v: CardDefs.CardValue,
	s: CardDefs.CardSuit,
) -> PlayerCard:
	var card := PLAYER_CARD_SCENE.instantiate()
	card.value = v
	card.suit = s
	return card
	

static func from_dict(dict: Dictionary) -> PlayerCard:
	assert(dict.has("value"), "dict missing key value") 
	assert(dict.has("suit"), "dict missing key suit") 
	assert(dict.size() == 2, "dict has incorrect amount of elements")
		
	var card := new_card(
		dict["value"],
		dict["suit"],
	)
	return card


func _ready() -> void:
	super()
	print(1)
	click_timer.one_shot = true


func _process(_delta: float) -> void:
	if not dragged and pressed and click_timer.time_left == 0:
		dragged = true
		card_dragged.emit(self)
	elif dragged and not pressed:
		dragged = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and pressed:
		pressed = false
		card_released.emit(self)


func _on_card_area_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int,
) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		pressed = true
		click_timer.start(click_time)
