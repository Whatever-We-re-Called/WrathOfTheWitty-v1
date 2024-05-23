extends RoomScene

@onready var sacrifice_normal_blessing_button = %SacrificeNormalBlessingButton

const SACRIFICE_BLESSING_UI = preload("res://ui/actions/upgrades/sacrifice_blessing_ui.tscn")
const STRENGTHEN_ACTION_CARD_UI = preload("res://ui/actions/upgrades/strengthen_action_card_ui.tscn")


func _on_sacrifice_normal_blessing_button_pressed():
	var sacrifice_blessing_ui = SACRIFICE_BLESSING_UI.instantiate()
	get_parent().add_child(sacrifice_blessing_ui)
	sacrifice_blessing_ui.init(player_info, true, false)
	self.visible = false
	var went_back = await sacrifice_blessing_ui.finished
	
	sacrifice_blessing_ui.queue_free()
	
	if not went_back:
		var strengthen_action_card_ui = STRENGTHEN_ACTION_CARD_UI.instantiate()
		get_parent().add_child(strengthen_action_card_ui)
		strengthen_action_card_ui.init(player_info)
		await strengthen_action_card_ui.finished
		
		strengthen_action_card_ui.queue_free()
	
	self.visible = true


func _on_skip_button_pressed():
	leave_room()
