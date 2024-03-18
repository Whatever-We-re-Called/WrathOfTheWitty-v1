extends MarginContainer

@onready var insecurity_icon = $VBoxContainer/Name/InsecurityIcon
@onready var player_name = $VBoxContainer/Name/PlayerName
@onready var health_bar = $VBoxContainer/HealthBar
@onready var health_bar_label = $VBoxContainer/HealthBar/HealthBarLabel
@onready var ability_bar = $VBoxContainer/AbilityBar
@onready var ability_bar_label = $VBoxContainer/AbilityBar/AbilityBarLabel


func update(player: BattlePlayer):
	insecurity_icon.texture = Constants.get_insecurity_icon()
	insecurity_icon.self_modulate = Constants.get_insecurity_color(player.config.insecurity)
	
	player_name.text = player.config.name
	
	health_bar.value = (float(player.health) / float(player.config.max_health)) * 100.0
	health_bar_label.text = str(player.health) + "/" + str(player.config.max_health)
	
	ability_bar.value = (float(player.stamina) / float(player.config.max_stamina)) * 100
	ability_bar_label.text = str(player.stamina) + "/" + str(player.config.max_stamina)
