extends UIInterpolator
class_name Rotation


@export var target = 0
@export var relative = false

var origin: float
var final: float

func execute_interpolation(time, style):
	if time == 0:
		origin = parent().rotation_degrees
		final = parent().rotation_degrees + target if relative else target
		
	parent().rotation_degrees = interpolate(origin, final, time, style)
