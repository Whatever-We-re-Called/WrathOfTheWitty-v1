extends RoomScene

const SACRIFICE_BLESSING_UI = preload("res://ui/actions/upgrades/sacrifice_blessing_ui.tscn")
const STRENGTHEN_INSECURITY_EFFECT_UI = preload("res://ui/actions/upgrades/strengthen_insecurity_effect_ui.tscn")


func _on_sacrifice_cosmic_blessing_button_pressed():
	var sacrifice_blessing_ui = SACRIFICE_BLESSING_UI.instantiate()
	get_parent().add_child(sacrifice_blessing_ui)
	sacrifice_blessing_ui.init(player_info, false, true)
	self.visible = false
	var went_back = await sacrifice_blessing_ui.finished
	
	sacrifice_blessing_ui.queue_free()
	
	if not went_back:
		var strengthen_insecurity_effect_ui = STRENGTHEN_INSECURITY_EFFECT_UI.instantiate()
		get_parent().add_child(strengthen_insecurity_effect_ui)
		strengthen_insecurity_effect_ui.init(player_info)
		await strengthen_insecurity_effect_ui.finished
		
		strengthen_insecurity_effect_ui.queue_free()
	
	self.visible = true


func _on_skip_button_pressed():
	leave_room()
