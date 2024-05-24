extends UIInterpolator
class_name Opacity


@export var target = 0
@export var relative = false

var origin: float
var final: float

func execute_interpolation(time, style):
	if time == 0:
		origin = parent().modulate.a
		final = parent().modulate.a + target if relative else target
		
	parent().modulate.a = interpolate(origin, final, time, style)
