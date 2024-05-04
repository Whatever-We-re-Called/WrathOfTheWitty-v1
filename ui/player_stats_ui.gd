extends MarginContainer

@onready var player_name = $VBoxContainer/Name/PlayerName
@onready var health_bar = $VBoxContainer/HealthBar
@onready var health_bar_label = $VBoxContainer/HealthBar/HealthBarLabel
@onready var stamina_bar = $VBoxContainer/StaminaBar
@onready var stamina_bar_label = $VBoxContainer/StaminaBar/StaminaBarLabel
@onready var active_status_effects = $VBoxContainer/ActiveStatusEffects
@onready var status_effect_container = active_status_effects.get_child(0)
@onready var freeze_bar = $VBoxContainer/StaminaBar/FreezeBar
@onready var insecurity_affinities_container = $VBoxContainer/Name/InsecurityAffinitiesContainer

const STATUS_EFFECT_UI_SCENE = preload("res://players/status_effects/status_effect_ui.tscn")

func update(player: BattlePlayer):
	player_name.text = player.info.name
	_update_insecurity_affinities_ui(player)
	
	health_bar.value = (float(player.health) / float(player.info.health_stat)) * 100.0
	health_bar_label.text = str(player.health) + "/" + str(player.info.health_stat)
	
	stamina_bar.value = (float(player.stamina) / float(player.info.stamina_stat)) * 100
	stamina_bar_label.text = str(player.stamina) + "/" + str(player.info.stamina_stat)
	
	var freeze_value = player.get_frozen_stamina_count()
	freeze_bar.value = (float(freeze_value) / float(player.info.stamina_stat)) * 100
	
	_update_status_effect_ui(player)


func _update_insecurity_affinities_ui(player: BattlePlayer):
	for child in insecurity_affinities_container.get_children():
		child.free()
	
	var insecurity_affinities = player.info.get_insecurity_affinities()
	for insecurity in insecurity_affinities:
		var affinity_type = insecurity_affinities[insecurity]
		print(player.info.name, " ", insecurity, " ", affinity_type)
		var texture_rect = TextureRect.new()
		texture_rect.texture = Constants.get_insecurity_icon(affinity_type)
		texture_rect.modulate = Constants.get_insecurity_color(insecurity)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.custom_minimum_size = Vector2(48, 48)
		insecurity_affinities_container.add_child(texture_rect)


func _update_status_effect_ui(player: BattlePlayer):
	for child in status_effect_container.get_children():
		child.free()
	
	for status_effect in player.active_status_effects.keys():
		var value = player.active_status_effects[status_effect]
		if value == 0: continue
		
		var status_effect_info = Constants.PlayerStatusEffectInfo[status_effect]
		var icon = status_effect_info.icon
		var color = status_effect_info.color
		var hide_text = Constants.PlayerStatusEffectInfo[status_effect].hide_quantity_text
		
		var status_effect_ui = STATUS_EFFECT_UI_SCENE.instantiate()
		status_effect_ui.init(icon, value, color, hide_text)
		status_effect_container.add_child(status_effect_ui)
