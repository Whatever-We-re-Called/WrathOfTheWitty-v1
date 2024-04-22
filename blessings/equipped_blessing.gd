class_name EquippedBlessing extends Resource

@export var type: Blessings.Type
@export var stack: int

var blessing: Blessing

var equipped_stack: int = 0

func init():
	if blessing == null:
		blessing = Blessings.get_blessing(type).duplicate()


func execute():
	pass
