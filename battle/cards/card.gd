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
@onready var slimed_overlay = %SlimedOverlay
@onready var hidden_overlay = %HiddenOverlay
@onready var attack_value_label = %AttackValueLabel

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
	_init_attack_texture()
	_init_enhancement_texture()
	_init_insult_texture()


func _init_attack_texture():
	var color = Constants.get_insecurity_color(card_info.insecurity)
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
	
	print(card_info.insecurity)
	attack_value_label.text = str(card_info.attack_value)


func _init_enhancement_texture():
	if card_info.enhancement == Constants.CardEnhancement.NONE:
		enhancement_info.visible = false
	else:
		enhancement_info.visible = true
		
		var color = Color.WHITE
		enhancement_icon.texture = CARD_TEXTURES.enhancement_icon
		enhancement_icon.self_modulate = color
		#enhancement_label.text = CARD_TEXTURES.get_enhancement_as_string(enhancement)
		enhancement_label.add_theme_color_override("font_color", color)


func _init_insult_texture():
	insult_label.text = card_info.insult_text


func set_on_fire(is_on_fire: bool, extinguish_damage: int = 0):
	if is_burning and not is_on_fire:
		fire_extinguished.emit()
	
	self.is_burning = is_on_fire
	burning_overlay.visible = is_on_fire
	
	if is_burning:
		burning_label.text = str(extinguish_damage) + " HP"


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
		player.damage(BATTLE_ACTION_EXECUTION_INFO.base_burn_damage_value)
		set_on_fire(false)
	elif is_slimed:
		return
	else:
		if not player.selected_cards.has(card_info):
			reroll.emit()


func _throw():
	throw.emit()
