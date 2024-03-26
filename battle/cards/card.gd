class_name Card extends CenterContainer

signal toggle_selected
signal reroll
signal throw

@onready var insult_label = %InsultLabel
@onready var button = $Button
@onready var info_background_button = %InfoBackgroundButton
@onready var info_container = $Button/InfoContainer
@onready var action_type_label = %ActionTypeLabel
@onready var strength_icon = %StrengthIcon
@onready var insecurity_icon = %InsecurityIcon
@onready var corner_rects = [
	$Button/CornerColorRect,
	$Button/CornerColorRect2,
	$Button/CornerColorRect3
]
@onready var highlighted_ui = %HighlightedUI

var card_info: CardInfo

const CARD_TEXTURES = preload("res://battle/cards/textures/card_textures.tres")


func _ready():
	init()


func init():
	_init_action_texture()
	_init_insecurity_texture()
	_init_strength_texture()
	_init_insult_lavel()


func _init_action_texture():
	var color = CARD_TEXTURES.get_action_color(card_info.action_type)
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = color
	button.add_theme_stylebox_override("normal", style_box)
	button.add_theme_stylebox_override("hover", style_box)
	button.add_theme_stylebox_override("pressed", style_box)
	button.add_theme_stylebox_override("disabled", style_box)
	button.add_theme_stylebox_override("focus", style_box)
	info_background_button.add_theme_stylebox_override("normal", style_box)
	info_background_button.add_theme_stylebox_override("hover", style_box)
	info_background_button.add_theme_stylebox_override("pressed", style_box)
	info_background_button.add_theme_stylebox_override("disabled", style_box)
	info_background_button.add_theme_stylebox_override("focus", style_box)
	
	action_type_label.text = CARD_TEXTURES.get_action_as_string(card_info.action_type)
	
	var corner_color_gradient = Gradient.new()
	corner_color_gradient.add_point(0, color)
	corner_color_gradient.add_point(1, Color.WHITE)
	var corner_color = corner_color_gradient.sample(0.025)
	for corner_rect in corner_rects:
		corner_rect.color = corner_color


func _init_insecurity_texture():
	insecurity_icon.texture = Constants.get_insecurity_icon()
	insecurity_icon.self_modulate = Constants.get_insecurity_color(card_info.insecurity_type)


func _init_strength_texture():
	strength_icon.texture = CARD_TEXTURES.strength_icon
	strength_icon.self_modulate = CARD_TEXTURES.get_strength_color(card_info.strength_type)


func _init_insult_lavel():
	insult_label.text = card_info.insult_text
	#print(insult_label.get_


func _on_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.get_button_index() == 1:
			toggle_selected.emit()
		elif event.get_button_index() == 2:
			reroll.emit()
		elif event.get_button_index() == 3:
			throw.emit()
