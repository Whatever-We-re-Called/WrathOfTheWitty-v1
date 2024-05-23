extends RoomScene

@onready var cosmic_blessing_button = %CosmicBlessingButton
@onready var template_card_button = %TemplateCardButton

const SACRIFICE_BLESSING_UI = preload("res://ui/actions/upgrades/sacrifice_blessing_ui.tscn")
const SACRIFICE_TEMPLATE_CARD_UI = preload("res://ui/actions/upgrades/sacrifice_template_card_ui.tscn")

func _on_cosmic_blessing_button_pressed():
	var sacrifice_blessing_ui = SACRIFICE_BLESSING_UI.instantiate()
	get_parent().add_child(sacrifice_blessing_ui)
	sacrifice_blessing_ui.init(player_info, false, true)
	self.visible = false
	var went_back = await sacrifice_blessing_ui.finished
	
	sacrifice_blessing_ui.queue_free()
	if not went_back:
		leave_room()
	else:
		self.visible = true


func _on_template_card_button_pressed():
	var sacrifice_template_card_ui = SACRIFICE_TEMPLATE_CARD_UI.instantiate()
	get_parent().add_child(sacrifice_template_card_ui)
	sacrifice_template_card_ui.init(player_info)
	self.visible = false
	var went_back = await sacrifice_template_card_ui.finished
	
	sacrifice_template_card_ui.queue_free()
	if not went_back:
		leave_room()
	else:
		self.visible = true


func _on_skip_button_pressed():
	leave_room()
