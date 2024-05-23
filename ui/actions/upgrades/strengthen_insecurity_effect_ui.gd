extends ActionUI

@onready var insecurity_options_container = %InsecurityOptionsContainer

var player_info: PlayerInfo

const STRENGTHEN_INSECURITY_EFFECT_OPTION_BUTTON = preload("res://ui/actions/upgrades/strengthen_insecurity_effect_option_button.tscn")



func init(player_info: PlayerInfo):
	self.player_info = player_info
	
	_update_options_visuals()


func _update_options_visuals():
	for child in insecurity_options_container.get_children():
		child.queue_free()
	
	for i in range(Constants.Insecurity.size()):
		var insecurity = Constants.Insecurity.values()[i]
		
		var button_ui = STRENGTHEN_INSECURITY_EFFECT_OPTION_BUTTON.instantiate()
		button_ui.init(insecurity, player_info.get_effect_dividend_stat(insecurity))
		button_ui.pressed.connect(_select_option.bind(i))
		button_ui.disabled = player_info.get_effect_dividend_stat(insecurity) <= PlayerInfo.MIN_DIVIDEND_VALUE
		insecurity_options_container.add_child(button_ui)


func _select_option(index: int):
	player_info.increment_effect_dividend_stat(Constants.Insecurity.values()[index], -1)
	
	finished.emit()


func _on_skip_button_pressed():
	finished.emit()
