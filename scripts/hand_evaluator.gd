extends Node
class_name HandEvaluator 

enum HAND_TYPE {
	INVALID,
	SINGLE,
	PAIR,
	TRIPLE,
	STRAIGHT,
	FLUSH,
	FULL_HOUSE,
	FOUR_OF_A_KIND,
	STRAIGHT_FLUSH,
}
	
	
static func can_play(
	last_played_cards: Array[Card], 
	curr_cards: Array[Card]
) -> bool:
	
	var curr_cards_type := get_hand_type(curr_cards)
	var last_played_cards_type := get_hand_type(last_played_cards)
	
	if (
		(curr_cards.size() != last_played_cards.size() and not last_played_cards.is_empty())
		or curr_cards_type == HAND_TYPE.INVALID
		or curr_cards.size() > 5 
	):
		return false
	
	if last_played_cards.is_empty():
		return true
			
	return beats(curr_cards, curr_cards_type, last_played_cards, last_played_cards_type)
	
	
static func get_hand_type(cards: Array[Card]) -> HAND_TYPE:
	match cards.size():
		1: return HAND_TYPE.SINGLE
		2: return HAND_TYPE.PAIR if has_one_value(cards) else HAND_TYPE.INVALID
		3: return HAND_TYPE.TRIPLE if has_one_value(cards) else HAND_TYPE.INVALID
		5: return evaluate_five_cards(cards)
	return HAND_TYPE.INVALID	


static func evaluate_five_cards(cards: Array[Card]) -> HAND_TYPE:
	assert(cards.size() == 5, "evaluate_five_cards: expected 5 cards")
	var flush := is_flush(cards)
	var straight := is_straight(cards)

	if flush and straight: return HAND_TYPE.STRAIGHT_FLUSH
	if is_four_of_a_kind(cards): return HAND_TYPE.FOUR_OF_A_KIND
	if is_full_house(cards): return HAND_TYPE.FULL_HOUSE
	if flush: return HAND_TYPE.FLUSH
	if straight: return HAND_TYPE.STRAIGHT
	return HAND_TYPE.INVALID


static func is_four_of_a_kind(cards: Array[Card]) -> bool:
	var counts : Dictionary[CardDefs.CardValue, int] = get_value_counts(cards)
	var values := counts.values()
	return values.has(4)


static func is_full_house(cards: Array[Card]) -> bool:
	var counts : Dictionary[CardDefs.CardValue, int] = get_value_counts(cards)
	var values := counts.values()
	return values.has(2) and values.has(3)


static func is_straight(cards: Array[Card]) -> bool:
	var sorted_cards: Array[Card] = cards.duplicate()
	sorted_cards.sort_custom(func(a: Card, b: Card) -> bool: return a.value < b.value)
	var sorted_values := sorted_cards.map(func(c: Card) -> CardDefs.CardValue: return c.value)
	
	var unique_straights: Array[Array] = [
		[
			CardDefs.CardValue.THREE, CardDefs.CardValue.FOUR, CardDefs.CardValue.FIVE, 
			CardDefs.CardValue.SIX, CardDefs.CardValue.TWO
		],
		[
			CardDefs.CardValue.THREE, CardDefs.CardValue.FOUR, CardDefs.CardValue.FIVE, 
			CardDefs.CardValue.ACE, CardDefs.CardValue.TWO
		]
	]
	
	var unique_invalid: Array[CardDefs.CardValue] = [
		CardDefs.CardValue.JACK, CardDefs.CardValue.QUEEN, CardDefs.CardValue.KING, 
		CardDefs.CardValue.ACE, CardDefs.CardValue.TWO
	]
	
	if sorted_values in unique_straights:
		return true
	if sorted_values == unique_invalid:
		return false
	
	for i in range(sorted_values.size()-1):
		if sorted_values[i+1]-1 != sorted_values[i]:
			return false
	return true
	

static func is_flush(cards: Array[Card]) -> bool:
	for card in cards:
		if cards[0].suit != card.suit:
			return false
	return true


static func beats(
	curr_cards: Array[Card], 
	curr_cards_type: HAND_TYPE,
	last_cards: Array[Card],
	last_cards_type: HAND_TYPE,
) -> bool:
	assert(not curr_cards.is_empty(), "curr_cards must not be empty")
	assert(not last_cards.is_empty(), "last_cards must not be empty")
	assert(curr_cards.size() == last_cards.size(), "hands must be same size")
	
	if curr_cards_type != last_cards_type and curr_cards.size() == 5:
		return curr_cards_type > last_cards_type
	if curr_cards_type == HAND_TYPE.FULL_HOUSE:
		return get_full_house_value(curr_cards) > get_full_house_value(last_cards)
	if curr_cards_type == HAND_TYPE.FOUR_OF_A_KIND:
		return get_four_of_a_kind_value(curr_cards) > get_four_of_a_kind_value(last_cards)
	return get_high_card(curr_cards).beats(get_high_card(last_cards))


static func get_full_house_value(cards: Array[Card]) -> int:
	var counts := get_value_counts(cards)
	for value in counts:
		if counts[value] == 3:
			return value
	return -1


static func get_four_of_a_kind_value(cards: Array[Card]) -> int:
	var counts := get_value_counts(cards)
	for value in counts:
		if counts[value] == 4:
			return value
	return -1


static func get_value_counts(cards: Array[Card]) -> Dictionary[CardDefs.CardValue, int]:
	var counts: Dictionary[CardDefs.CardValue, int] = {}
	for card in cards:
		counts[card.value] = counts.get(card.value, 0) + 1
	return counts


static func has_one_value(cards: Array[Card]) -> bool:
	for card in cards:
		if cards[0].value != card.value:
			return false
	return true
	
	
static func get_high_card(cards: Array[Card]) -> Card:
	return cards.reduce(func(a: Card, b: Card) -> Card: return a if a.beats(b) else b)
	
