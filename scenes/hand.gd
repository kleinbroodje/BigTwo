extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"

var hand = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		new_card.suit = CardDefs.CardSuit.DIAMONDS
		new_card.value = CardDefs.CardValue.THREE
		add_child(new_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
