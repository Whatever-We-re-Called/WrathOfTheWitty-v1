class_name TemplateCard extends Control

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
@onready var played_cards_container = %PlayedCardsContainer

var template_card_info: TemplateCardInfo
var max_cards_allowed = 0
var played_cards: Array[Card]

const INSULT_PLACEHOLDER_TEXT = "%insult%"
const EMPTY_UNDERLINE_TEXT = "__________"


func _ready():
	_init_glyphs()
	_init_info_description()
	_init_identity_visuals()
	_init_execution_visuals()


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
	while sentence_label_text.contains(INSULT_PLACEHOLDER_TEXT):
		var i = sentence_label_text.find(INSULT_PLACEHOLDER_TEXT)
		sentence_label_text = sentence_label_text.erase(i, INSULT_PLACEHOLDER_TEXT.length())
		
		max_cards_allowed += 1


func _show_info_description_display():
	information_description_display.visible = true


func _hide_info_description_display():
	information_description_display.visible = false


func is_full() -> bool:
	return played_cards.size() >= max_cards_allowed


func add_played_card(card: Card):
	card.reparent(played_cards_container)
	played_cards.push_back(card)


func remove_played_card(card: Card):
	card.queue_free()
	for i in range(played_cards.size()):
		if played_cards[i] == card:
			played_cards.remove_at(i)
			break


func clear_played_cards():
	for card in played_cards_container.get_children():
		card.free()
