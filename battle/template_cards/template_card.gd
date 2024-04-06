class_name TemplateCard extends Control

signal selected_card_added(card: Card)
signal selected_card_removed(card: Card)
signal play_selected_cards

@onready var background_glyph = %BackgroundGlyph
@onready var left_player_speaking_glyph = %LeftPlayerSpeakingGlyph
@onready var right_player_speaking_glyph = %RightPlayerSpeakingGlyph
@onready var card_name = %CardName
@onready var information_description_icon = %InformationDescriptionIcon
@onready var information_description_display = %InformationDescriptionDisplay
@onready var info_description_label = %InfoDescriptionLabel
@onready var insecurity_icon = %InsecurityIcon
@onready var sentence_label = %SentenceLabel
@onready var play_button = %PlayButton
@onready var selected_cards_text = %SelectedCardsText
@onready var selected_cards_container = %SelectedCardsContainer

var template_card_info: TemplateCardInfo
var max_insults_allowed = 0
var selected_cards: Array[Card]
var saved_deck_container: Control

const INSULT_PLACEHOLDER_TEXT = "%insult%"
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
	information_description_display.visible = false
	info_description_label.text = template_card_info.info_description
	information_description_icon.mouse_entered.connect(_show_info_description_display)
	information_description_icon.mouse_exited.connect(_hide_info_description_display)


func _init_identity_visuals():
	card_name = template_card_info.name


func _init_execution_visuals():
	insecurity_icon.texture = Constants.get_insecurity_icon()
	insecurity_icon.self_modulate = Constants.get_insecurity_color(template_card_info.insecurity)
	
	var sentence_label_text = template_card_info.sentence
	sentence_label.text = sentence_label_text.replace(INSULT_PLACEHOLDER_TEXT, EMPTY_UNDERLINE_TEXT)


func _init_insult_text():
	var sentence_label_text = template_card_info.sentence
	while sentence_label_text.contains(INSULT_PLACEHOLDER_TEXT):
		var i = sentence_label_text.find(INSULT_PLACEHOLDER_TEXT)
		sentence_label_text = sentence_label_text.erase(i, INSULT_PLACEHOLDER_TEXT.length())
		
		max_insults_allowed += 1


func _show_info_description_display():
	information_description_display.visible = true


func _hide_info_description_display():
	information_description_display.visible = false


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
	
	selected_cards_text.text = str(current_insults) + "/" + str(max_insults)
	play_button.disabled = current_insults != max_insults


func _on_play_button_pressed():
	for card in selected_cards:
		card.free()
	selected_cards.clear()
	_update_play_button_status()
	
	play_selected_cards.emit()
