class_name Card extends CenterContainer

@onready var insult_label = %InsultLabel
@onready var button = $Button
@onready var strength_icon = %StrengthIcon
@onready var insecurity_icon = %InsecurityIcon

var card_info: CardInfo

const CARD_TEXTURES = preload("res://battle/cards/textures/card_textures.tres")


func _ready():
	_init_action_texture()
	_init_insecurity_texture()
	_init_strength_texture()
	_init_insult_lavel()


func _init_action_texture():
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = CARD_TEXTURES.get_action_color(card_info.action_type)
	button.add_theme_stylebox_override("normal", style_box)
	button.add_theme_stylebox_override("hover", style_box)
	button.add_theme_stylebox_override("pressed", style_box)
	button.add_theme_stylebox_override("disabled", style_box)
	button.add_theme_stylebox_override("focus", style_box)


func _init_insecurity_texture():
	insecurity_icon.texture = Constants.get_insecurity_icon()
	insecurity_icon.self_modulate = Constants.get_insecurity_color(card_info.insecurity_type)


func _init_strength_texture():
	strength_icon.texture = CARD_TEXTURES.strength_icon
	strength_icon.self_modulate = CARD_TEXTURES.get_strength_color(card_info.strength_type)


func _init_insult_lavel():
	insult_label.text = card_info.insult_text
	#print(insult_label.get_
