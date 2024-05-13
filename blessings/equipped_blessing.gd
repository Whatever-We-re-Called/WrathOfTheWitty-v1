class_name EquippedBlessing extends Resource

@export var type: Blessings.Type

var blessing: Blessing
var is_init: bool = false


func init(player_info: PlayerInfo):
	if blessing == null:
		blessing = Blessings.get_blessing(type).duplicate()
		blessing.init(player_info)
		blessing.equipped.emit()
		is_init = true
