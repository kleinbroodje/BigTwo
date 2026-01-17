extends Node

var all_cards: Array[Card]
@onready var hand: Hand = get_node("Hand")

func _ready() -> void:
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)
	if multiplayer.is_server():
		all_cards = generate_cards()
		NetworkHandler.connect("start_game", _on_start_game)

func generate_cards() -> Array[Card]:
	var cards: Array[Card] = []
	for suit in CardDefs.CardSuit.size():
		for value in CardDefs.CardValue.size():
			var card := Card.new_card(value, suit)
			cards.append(card)
	return cards

@rpc("authority", "call_local")
func deal_cards(dealt_cards_data: Array[Dictionary]) -> void:
	for dealt_card_data in dealt_cards_data:
		var new_card := Card.dict_to_card(dealt_card_data)
		hand.add_child(new_card)
	hand.update_hand_positions()
		
func _on_start_game() -> void:
	var all_ids := multiplayer.get_peers()
	all_ids.append(multiplayer.get_unique_id())
	for peer_id in all_ids:
		var cards: Array[Dictionary] = []
		for i in range(13):
			var random_card: Card = all_cards.pick_random()
			cards.append(Card.card_to_dict(random_card))
			all_cards.erase(random_card)
		rpc_id(peer_id, "deal_cards", cards)
