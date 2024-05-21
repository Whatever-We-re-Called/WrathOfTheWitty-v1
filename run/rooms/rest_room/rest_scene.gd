extends RoomScene

@onready var heal_button = %HealButton
@onready var upgrade_button = %UpgradeButton

var heal_amount: int

const MAX_ALLOWED_ACTIONS: int = 1
const HEAL_PERCENTAGE_OF_MAX_HEALTH: float = 0.3
const UPGRADE_TEMPLATE_CARD_UI = preload("res://ui/actions/upgrades/upgrade_template_card_ui.tscn")


func _setup():
	_init_heal_option()
	_init_upgrade_option()


func _init_heal_option():
	heal_amount = int(floor(float(player_info.health_stat) * HEAL_PERCENTAGE_OF_MAX_HEALTH))
	heal_button.text = "Heal (+" + str(heal_amount) + " HP)"


func _init_upgrade_option():
	var can_upgrade = false
	for equipped_template_card in player_info.equipped_template_cards:
		if not equipped_template_card.is_upgraded:
			can_upgrade = true
			break
	upgrade_button.visible = can_upgrade


func _on_heal_button_pressed():
	player_info.heal(heal_amount)
	leave_room()


func _on_upgrade_button_pressed():
	var upgrade_template_card_ui = UPGRADE_TEMPLATE_CARD_UI.instantiate()
	get_parent().add_child(upgrade_template_card_ui)
	upgrade_template_card_ui.init(player_info)
	self.visible = false
	await upgrade_template_card_ui.finished
	
	self.visible = true
	upgrade_template_card_ui.queue_free()
	leave_room()
