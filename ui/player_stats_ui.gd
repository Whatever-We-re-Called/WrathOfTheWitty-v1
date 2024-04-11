extends MarginContainer

@onready var insecurity_icon = $VBoxContainer/Name/InsecurityIcon
@onready var player_name = $VBoxContainer/Name/PlayerName
@onready var health_bar = $VBoxContainer/HealthBar
@onready var health_bar_label = $VBoxContainer/HealthBar/HealthBarLabel
@onready var stamina_bar = $VBoxContainer/StaminaBar
@onready var stamina_bar_label = $VBoxContainer/StaminaBar/StaminaBarLabel
@onready var active_status_effects = $VBoxContainer/ActiveStatusEffects
@onready var status_effect_container = active_status_effects.get_child(0)

const STATUS_EFFECT_UI_SCENE = preload("res://players/status_effects/status_effect_ui.tscn")

func update(player: BattlePlayer):
	insecurity_icon.texture = Constants.get_insecurity_icon()
	#insecurity_icon.self_modulate = Constants.get_insecurity_color(player.info.insecurity)
	
	player_name.text = player.info.name
	
	health_bar.value = (float(player.health) / float(player.info.health_stat)) * 100.0
	health_bar_label.text = str(player.health) + "/" + str(player.info.health_stat)
	
	stamina_bar.value = (float(player.stamina) / float(player.info.stamina_stat)) * 100
	stamina_bar_label.text = str(player.stamina) + "/" + str(player.info.stamina_stat)
	
	_update_status_effect_ui(player)


func _update_status_effect_ui(player: BattlePlayer):
	for child in status_effect_container.get_children():
		child.free()
	
	for status_effect in player.active_status_effects.keys():
		var value = player.active_status_effects[status_effect]
		if value == 0: continue
		
		var status_effect_info = Constants.PlayerStatusEffectInfo[status_effect]
		var icon = status_effect_info.icon
		var color = status_effect_info.color
		
		var status_effect_ui = STATUS_EFFECT_UI_SCENE.instantiate()
		status_effect_ui.init(icon, value, color)
		status_effect_container.add_child(status_effect_ui)
