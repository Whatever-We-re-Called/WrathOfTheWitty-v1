class_name EquippedBlessing extends Resource

@export var type: Blessings.Type
@export var is_cosmic: bool

var blessing: Blessing
var is_init: bool = false

func init():
	if blessing == null:
		blessing = Blessings.get_blessing(type).duplicate()
		is_init = true


func execute():
	pass
