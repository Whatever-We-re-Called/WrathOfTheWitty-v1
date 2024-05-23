extends RoomScene

@onready var heal_button = %HealButton
@onready var upgrade_button = %UpgradeButton

var heal_amount: int

const MAX_ALLOWED_ACTIONS: int = 1
const HEAL_PERCENTAGE_OF_MAX_HEALTH: float = 0.3
const UPGRADE_TEMPLATE_CARD_UI = preload("res://ui/actions/upgrades/upgrade_template_card_ui.tscn")


func _setup():
	_init_heal_option()


func _init_heal_option():
	heal_amount = int(floor(float(player_info.health_stat) * HEAL_PERCENTAGE_OF_MAX_HEALTH))
	heal_button.text = "Heal (+" + str(heal_amount) + " HP)"


func _on_heal_button_pressed():
	player_info.heal(heal_amount)
	leave_room()


func _on_upgrade_button_pressed():
	var upgrade_template_card_ui = UPGRADE_TEMPLATE_CARD_UI.instantiate()
	get_parent().add_child(upgrade_template_card_ui)
	upgrade_template_card_ui.init(player_info)
	self.visible = false
	var went_back = await upgrade_template_card_ui.finished
	
	upgrade_template_card_ui.queue_free()
	if not went_back:
		leave_room()
	else:
		self.visible = true


func _on_skip_button_pressed():
	leave_room()
