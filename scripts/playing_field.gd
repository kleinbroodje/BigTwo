extends Control
class_name PlayingField

func show_cards(cards: Array[Card]) -> void:
	for card in cards:
		add_child(card)
