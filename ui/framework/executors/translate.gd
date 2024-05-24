extends UIInterpolator
class_name Translate


@export var target: Vector2
@export var relative = true

var origin
var final

func execute_interpolation(time, style):
	if time == 0:
		origin = parent().position
		final = parent().position + target if relative else target
		
	parent().position = interpolate(origin, final, time, style)
