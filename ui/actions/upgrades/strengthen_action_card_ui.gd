extends ActionUI

@onready var change_insecurity_button = %ChangeInsecurityButton
@onready var apply_enhancement_button = %ApplyEnhancementButton
@onready var upgrade_damage_button = %UpgradeDamageButton

var player_info: PlayerInfo
var change_insecurity_option: Constants.Insecurity
var apply_enhancement_option: Constants.CardEnhancement
var upgrade_damage_value: int

const CHANGE_INSECURITY_UI = preload("res://ui/actions/upgrades/change_insecurity_ui.tscn")
const APPLY_ENHANCEMENT_UI = preload("res://ui/actions/upgrades/apply_enhancement_ui.tscn")
const UPGRADE_ATTACK_UI = preload("res://ui/actions/upgrades/upgrade_attack_ui.tscn")


func init(player_info: PlayerInfo):
	self.player_info = player_info
	
	_init_change_insecurity_option()
	_init_apply_enhancement_option()
	_init_upgrade_damage_option()


func _init_change_insecurity_option():
	var rng = RandomNumberGenerator.new()
	var chosen_index = rng.randi_range(0, Constants.Insecurity.size() - 1)
	change_insecurity_option = Constants.Insecurity.values()[chosen_index]
	
	change_insecurity_button.text = "Change Insecurity: " + Constants.insecurity_strings[change_insecurity_option]


func _init_apply_enhancement_option():
	var rng = RandomNumberGenerator.new()
	var chosen_index = rng.randi_range(1, Constants.CardEnhancement.size() - 1)
	apply_enhancement_option = Constants.CardEnhancement.values()[chosen_index]
	
	apply_enhancement_button.text = "Apply Enhancement: " + Constants.enhancement_strings.values()[apply_enhancement_option]


func _init_upgrade_damage_option():
	var rng = RandomNumberGenerator.new()
	upgrade_damage_value = rng.randi_range(2, 3)
	
	upgrade_damage_button.text = "Upgrade Damage: +" + str(upgrade_damage_value) + " DMG"


func _on_change_insecurity_button_pressed():
	var change_insecurity_ui = CHANGE_INSECURITY_UI.instantiate()
	get_parent().add_child(change_insecurity_ui)
	change_insecurity_ui.init(player_info, change_insecurity_option)
	self.visible = false
	var went_back = await change_insecurity_ui.finished
	
	change_insecurity_ui.queue_free()
	if not went_back:
		finished.emit()
	else:
		self.visible = true


func _on_apply_enhancement_button_pressed():
	var apply_enhancement_ui = APPLY_ENHANCEMENT_UI.instantiate()
	get_parent().add_child(apply_enhancement_ui)
	apply_enhancement_ui.init(player_info, apply_enhancement_option)
	self.visible = false
	var went_back = await apply_enhancement_ui.finished
	
	apply_enhancement_ui.queue_free()
	if not went_back:
		finished.emit()
	else:
		self.visible = true


func _on_upgrade_damage_button_pressed():
	var upgrade_attack_ui = UPGRADE_ATTACK_UI.instantiate()
	get_parent().add_child(upgrade_attack_ui)
	upgrade_attack_ui.init(player_info, upgrade_damage_value)
	self.visible = false
	var went_back = await upgrade_attack_ui.finished
	
	upgrade_attack_ui.queue_free()
	if not went_back:
		finished.emit()
	else:
		self.visible = true
