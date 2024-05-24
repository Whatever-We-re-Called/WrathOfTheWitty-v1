extends UIInterpolator
class_name Scale


@export var percentage: float

var origin
var target

func _ready():
	if percentage < 0:
		var abs = abs(percentage)
		percentage = 100 / (abs / 100)

func execute_interpolation(time, style):
	if time == 0:
		origin = parent().scale
		target = parent().scale * (percentage / 100.0)
	
	var current = interpolate(origin, target, time, style)
	parent().scale = current
