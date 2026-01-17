extends Control

func _on_hand_cards_played(played_cards: Array[Card]) -> void:
	for card in played_cards:
		add_child(card)
