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

var template_card_info: TemplateCardInfo


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
	
	sentence_label.text = template_card_info.sentence


func _show_info_description_display():
	print("!")
	information_description_display.visible = true


func _hide_info_description_display():
	print("?")
	information_description_display.visible = false
