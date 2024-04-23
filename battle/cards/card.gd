class_name Card extends CenterContainer

signal toggle_selected
signal reroll
signal throw
signal fire_extinguished

@onready var burning_overlay = %BurningOverlay
@onready var burning_label = %BurningLabel
@onready var insult_label = %InsultLabel
@onready var button = $Button
@onready var corner_rects = [
	$Button/CornerColorRect,
]
@onready var highlighted_ui = %HighlightedUI
@onready var enhancement_info = %EnhancementInfo
@onready var enhancement_icon = %EnhancementIcon
@onready var enhancement_label = %EnhancementLabel
@onready var action_type_label = %ActionTypeLabel
@onready var slimed_overlay = %SlimedOverlay
@onready var hidden_overlay = %HiddenOverlay

var card_info: CardInfo
var player: BattlePlayer

var card_enhancement_stack: Array[Constants.CardEnhancement]
var is_burning = false
var is_slimed = false
var is_hidden = false

const CARD_TEXTURES = preload("res://battle/cards/textures/card_textures.tres")
const BATTLE_ACTION_EXECUTION_INFO = preload("res://battle/action_execution/battle_action_execution_info.tres")


func _ready():
	init()


func init():
	_init_action_texture()
	_init_enhancement_texture()
	_init_insult_texture()


func _init_action_texture():
	
	var color = CARD_TEXTURES.get_action_color(card_info.action_type)
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = color
	button.add_theme_stylebox_override("normal", style_box)
	button.add_theme_stylebox_override("hover", style_box)
	button.add_theme_stylebox_override("pressed", style_box)
	button.add_theme_stylebox_override("disabled", style_box)
	button.add_theme_stylebox_override("focus", style_box)
	
	var corner_color_gradient = Gradient.new()
	corner_color_gradient.add_point(0, color)
	corner_color_gradient.add_point(1, Color.WHITE)
	
	var corner_color = corner_color_gradient.sample(0.1)
	for corner_rect in corner_rects:
		corner_rect.color = corner_color
	
	var text_color = corner_color_gradient.sample(0.75)
	action_type_label.text = CARD_TEXTURES.get_action_as_string(card_info.action_type)
	action_type_label.add_theme_color_override("font_color", text_color)


func _init_enhancement_texture():
	if not _can_have_enhancement_ui():
		enhancement_info.visible = false
	else:
		enhancement_info.visible = true
		
		var enhancement = card_info.enhancement
		var enhancement_color_gradient = Gradient.new()
		enhancement_color_gradient.add_point(0, CARD_TEXTURES.get_enhancement_color(enhancement))
		enhancement_color_gradient.add_point(1, Color.WHITE)
		var enhancement_color = enhancement_color_gradient.sample(0.5)
		
		enhancement_icon.texture = CARD_TEXTURES.enhancement_icon
		enhancement_icon.self_modulate = enhancement_color
		enhancement_label.text = CARD_TEXTURES.get_enhancement_as_string(enhancement)
		enhancement_label.add_theme_color_override("font_color", enhancement_color)


func _can_have_enhancement_ui() -> bool:
	# Calculates if it should show Enhancement UI based off
	# Constants.CardEnhancement enum (indexes 0-5 are attack
	# cards).
	var action_type = card_info.action_type
	return action_type >= 0 and action_type <= 5


func _init_insult_texture():
	insult_label.text = card_info.insult_text


func set_on_fire(is_on_fire: bool):
	if is_burning and not is_on_fire:
		fire_extinguished.emit()
	
	self.is_burning = is_on_fire
	burning_overlay.visible = is_on_fire
	
	if is_burning:
		burning_label.text = str(BATTLE_ACTION_EXECUTION_INFO.base_burn_damage_value) + " HP"


func set_as_slimed(slimed: bool):
	self.is_slimed = slimed
	slimed_overlay.visible = slimed


func set_as_hidden(hidden: bool):
	self.is_hidden = hidden
	hidden_overlay.visible = hidden


func _on_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.get_button_index() == 1:
			_select()
		elif event.get_button_index() == 2:
			_reroll()
		elif event.get_button_index() == 3:
			_throw()


func _select():
	if is_burning:
		player.damage(BATTLE_ACTION_EXECUTION_INFO.base_burn_damage_value)
		set_on_fire(false)
	else:
		toggle_selected.emit()


func _reroll():
	if is_burning:
		player.damage(BATTLE_ACTION_EXECUTION_INFO.base_fire_damage_value)
		set_on_fire(false)
	elif is_slimed:
		return
	else:
		if not player.selected_cards.has(card_info):
			reroll.emit()


func _throw():
	throw.emit()
