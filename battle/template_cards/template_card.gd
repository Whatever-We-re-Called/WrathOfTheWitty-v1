class_name TemplateCard extends Control

signal selected_card_added(card: Card)
signal selected_card_removed(card: Card)
signal play_selected_cards
signal selected_previous_template_card
signal selected_next_template_card

@onready var background_glyph = %BackgroundGlyph
@onready var left_player_speaking_glyph = %LeftPlayerSpeakingGlyph
@onready var right_player_speaking_glyph = %RightPlayerSpeakingGlyph
@onready var card_name = %CardName
@onready var information_description_icon = %InformationDescriptionIcon
@onready var sentence_label = %SentenceLabel
@onready var play_button = %PlayButton
@onready var selected_cards_container = %SelectedCardsContainer
@onready var insecurity_icon_container = %InsecurityIconContainer
@onready var top_cards_container = %TopCardsContainer
@onready var button_container = %ButtonContainer
@onready var left_player_speaking_glyph_container = %LeftPlayerSpeakingGlyphContainer
@onready var right_player_speaking_glyph_container = %RightPlayerSpeakingGlyphContainer
@onready var previous_selected_button = %PreviousSelectedButton
@onready var next_selected_button = %NextSelectedButton

var template_card_info: TemplateCardInfo
var max_insults_allowed = 0
var selected_cards: Array[Card]
var saved_deck_container: Control
var insults_grmmar_types: Array[GrammarType]

enum GrammarType { NOUN, ADJECTIVE, VERB, NONE }
var INSULT_PLACEHOLDER_TEXTS = {
	GrammarType.NOUN: "%noun%",
	GrammarType.ADJECTIVE: "%adjective%",
	GrammarType.VERB: "%verb%"
}
const EMPTY_UNDERLINE_TEXT = "__________"


func _ready():
	_init_glyphs()
	_init_info_description()
	_init_identity_visuals()
	_init_execution_visuals()
	
	_init_insult_text()


func _init_glyphs():
	background_glyph.color = template_card_info.background_color
	left_player_speaking_glyph.color = template_card_info.background_color
	right_player_speaking_glyph.color = template_card_info.background_color


func _init_info_description():
	information_description_icon.tooltip_text = template_card_info.description


func _init_identity_visuals():
	card_name.text = template_card_info.name


func _init_execution_visuals():
	for insecurity in template_card_info.insecurities:
		var insecurity_icon = TextureRect.new()
		insecurity_icon.texture = Constants.get_insecurity_icon()
		insecurity_icon.self_modulate = Constants.get_insecurity_color(insecurity)
		insecurity_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		insecurity_icon_container.custom_minimum_size = Vector2(48, 48)
		insecurity_icon_container.add_child(insecurity_icon)
	
	var sentence_label_text = template_card_info.sentence


func _init_insult_text():
	var sentence_label_text = template_card_info.sentence
	while true:
		var grammar_type = _get_earliest_insult_grammar_placeholder(sentence_label_text)
		if grammar_type == GrammarType.NONE:
			break
		else:
			var placeholder_text = INSULT_PLACEHOLDER_TEXTS[grammar_type]
			var i = sentence_label_text.find(placeholder_text)
			sentence_label_text = sentence_label_text.erase(i, placeholder_text.length())
			sentence_label_text = sentence_label_text.insert(i, EMPTY_UNDERLINE_TEXT)
			
			max_insults_allowed += 1
	sentence_label.text = sentence_label_text


func _get_earliest_insult_grammar_placeholder(text: String) -> GrammarType:
	if text.contains(INSULT_PLACEHOLDER_TEXTS[GrammarType.NOUN]):
		return GrammarType.NOUN
	elif text.contains(INSULT_PLACEHOLDER_TEXTS[GrammarType.ADJECTIVE]):
		return GrammarType.ADJECTIVE
	elif text.contains(INSULT_PLACEHOLDER_TEXTS[GrammarType.VERB]):
		return GrammarType.VERB
	else:
		return GrammarType.NONE


func is_full() -> bool:
	return selected_cards.size() >= max_insults_allowed


func add_selected_card(card: Card):
	selected_cards.push_back(card)
	_update_play_button_status()
	
	card.reparent(selected_cards_container)


func remove_selected_card(card: Card):
	for i in range(selected_cards.size()):
		if selected_cards[i] == card:
			selected_cards.remove_at(i)
			break
	_update_play_button_status()


func clear_selected_cards():
	selected_cards.clear()
	_update_play_button_status()


func set_talking_side(side: Constants.PlayerSide):
	left_player_speaking_glyph.visible = side == Constants.PlayerSide.LEFT
	right_player_speaking_glyph.visible = side == Constants.PlayerSide.RIGHT


func _update_play_button_status():
	var current_insults = selected_cards.size()
	var max_insults = max_insults_allowed
	
	play_button.disabled = current_insults != max_insults


func _on_play_button_pressed():
	for card in selected_cards:
		card.free()
	selected_cards.clear()
	_update_play_button_status()
	
	play_selected_cards.emit()


func remove_interactable_ui():
	top_cards_container.queue_free()
	button_container.queue_free()
	left_player_speaking_glyph_container.queue_free()
	right_player_speaking_glyph_container.queue_free()


func update_selected_buttons(index: int, hand_size: int):
	previous_selected_button.visible = index != 0
	next_selected_button.visible = index != hand_size - 1


func _on_previous_selected_button_pressed():
	selected_previous_template_card.emit()


func _on_next_selected_button_pressed():
	selected_next_template_card.emit()
