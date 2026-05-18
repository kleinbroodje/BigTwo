extends Node

@onready var hand: Hand = get_node("Hand")
@onready var playing_field: PlayingField = get_node("PlayingField")

var last_played_cards: Array[Card] = []

func _ready() -> void:
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)

	if multiplayer.is_server():
		NetworkHandler.connect("start_game", _on_start_game)


# returns all 52 playing cards in a standard deck
func generate_cards() -> Array[Card]:
	var cards: Array[Card] = []

	for suit in CardDefs.CardSuit.size():
		for value in CardDefs.CardValue.size():
			var card := Card.new_card(value, suit)
			cards.append(card)

	return cards
	
	
func _on_cards_played(cards_data: Array[Dictionary]) -> void:
	rpc("play_cards", multiplayer.get_unique_id(), cards_data)	
	

@rpc("any_peer", "call_local")
func play_cards(_player_id: int, cards_data: Array[Dictionary]) -> void:
	var cards: Array[Card] = []
	for card_data in cards_data:
		cards.append(Card.from_dict(card_data))
	
	playing_field.show_cards(cards)


@rpc("authority", "call_local")
func deal_cards(dealt_cards_data: Array[Dictionary]) -> void:
	for dealt_card_data in dealt_cards_data:
		hand.add_card(dealt_card_data)
	hand.update_hand_positions()
		
		
func _on_start_game() -> void:
	var cards := generate_cards()
	cards.shuffle()
	
	var all_ids := multiplayer.get_peers()
	all_ids.append(multiplayer.get_unique_id())

	# distribute the cards amongst the players 
	for peer_id in all_ids:
		var hand_cards: Array[Dictionary] = []

		for i in range(hand.MAX_CARDS):
			var random_card: Card = cards.pop_back()
			hand_cards.append(random_card.to_dict())
			random_card.queue_free()

		rpc_id(peer_id, "deal_cards", hand_cards)
