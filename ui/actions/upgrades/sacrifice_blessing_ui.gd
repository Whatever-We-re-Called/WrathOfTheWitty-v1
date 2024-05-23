extends ActionUI

signal selected_blessing

@onready var blessings_container = %BlessingsContainer

var player_info: PlayerInfo
var include_normal: bool
var include_cosmic: bool
var options: Array[EquippedBlessing]


func init(player_info: PlayerInfo, include_normal: bool, include_cosmic: bool):
	self.player_info = player_info
	self.include_normal = include_normal
	self.include_cosmic = include_cosmic
	
	_decide_options()
	_update_options_visuals()


func _decide_options():
	var normal_blessings: Array[EquippedBlessing]
	var cosmic_blessings: Array[EquippedBlessing]
	for equipped_blessing in player_info.equipped_blessings:
		if not equipped_blessing.blessing.is_cosmic:
			if include_normal:
				normal_blessings.append(equipped_blessing)
			else:
				continue
		else:
			if include_cosmic:
				cosmic_blessings.append(equipped_blessing)
			else:
				continue
	
	options.append_array(cosmic_blessings)
	options.append_array(normal_blessings)


func _update_options_visuals():
	for child in blessings_container.get_children():
		child.queue_free()
	
	for i in range(options.size()):
		var equipped_blessing = options[i]
		
		var texture_rect = TextureRect.new()
		texture_rect.texture = equipped_blessing.blessing.texture
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.custom_minimum_size = Vector2(96, 96)
		
		var hovered_name = equipped_blessing.blessing.name
		if equipped_blessing.blessing.is_cosmic:
			hovered_name += " (Cosmic)"
			texture_rect.modulate = Blessing.COSMIC_COLOR
		else:
			texture_rect.modulate = Blessing.NORMAL_COLOR
		var hovered_info = equipped_blessing.blessing.description
		texture_rect.tooltip_text = equipped_blessing.blessing.get_tooltip()
		
		texture_rect.gui_input.connect(_on_blessing_gui_input.bind(i))
		
		blessings_container.add_child(texture_rect)


func _on_blessing_gui_input(event: InputEvent, index: int):
	if event is InputEventMouseButton:
		if event.button_mask == 1:
			_select_option(index)


func _select_option(index: int):
	player_info.remove_blessing(options[index])
	
	finished.emit()


func _on_skip_button_pressed():
	finished.emit(true)
