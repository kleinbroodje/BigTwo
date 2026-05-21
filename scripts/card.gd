extends Node2D
class_name Card

const CARD_SCENE_PATH := "res://scenes/card.tscn"
const CARD_SCENE := preload(CARD_SCENE_PATH)
const BACK_TEXTURE := preload("res://assets/images/cards/back01.png")

const SUIT_NAMES: Array = [
	"diamonds",
	"clubs",
	"hearts",
	"spades",
]

const VALUE_NAMES: Array = [
	"03",
	"04",
	"05",
	"06",
	"07",
	"08",
	"09",
	"10",
	"jack",
	"queen",
	"king",
	"ace",
	"02",
]

@export var value: CardDefs.CardValue
@export var suit: CardDefs.CardSuit
@export var face_up: bool = true

@onready var card_image: Sprite2D = get_node("CardImage")

var tween_position: Tween


static func new_card(
	v: CardDefs.CardValue,
	s: CardDefs.CardSuit,
) -> Card:
	var card := CARD_SCENE.instantiate()
	card.value = v
	card.suit = s
	return card
	

func to_dict() -> Dictionary:
	return {
		"value": value,
		"suit": suit,
	}
	
func beats(card: Card) -> bool:
	if value < card.value:
		return false
	if suit < card.suit:
		return false
	return true


static func from_dict(dict: Dictionary) -> Card:
	assert(dict.has("value"), "dict missing key value") 
	assert(dict.has("suit"), "dict missing key suit") 
	assert(dict.size() == 2, "dict has incorrect amount of elements")
		
	var card := new_card(
		dict["value"],
		dict["suit"],
	)
	return card


func _ready() -> void:
	if face_up:
		card_image.texture = load(
			"res://assets/images/cards/%s_%s.png"
			% [SUIT_NAMES[suit], VALUE_NAMES[value]]
		)
	else: 
		card_image.texture = BACK_TEXTURE


func move(pos: Vector2) -> void:
	if tween_position and tween_position.is_running():
		tween_position.kill()
		
	tween_position = (
		create_tween()
			.set_ease(Tween.EASE_OUT)
			.set_trans(Tween.TRANS_QUART)
	)

	tween_position.tween_property(
		self,
		"position",
		pos,
		0.5,
	)
