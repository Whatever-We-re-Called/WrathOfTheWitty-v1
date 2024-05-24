extends UIAction
class_name OnClick


@export var cooldown_in_seconds: float
var cooldown_active = false


func execute():
	if not cooldown_active:
		cooldown_active = true
		start()
	await timer(cooldown_in_seconds)
	cooldown_active = false
	
