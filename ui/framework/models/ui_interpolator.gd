extends UIExecutor
class_name UIInterpolator

@export var seconds = 1.0
@export var style = InterpolationStyle.LINEAR

func execute():
	var i = 0.0
	while true:
		execute_interpolation(i / seconds if seconds > 0 else 1, style)
		if i == seconds:
			break
		i += get_process_delta_time()
		if i > seconds:
			break
		await get_tree().process_frame


func execute_interpolation(time, style):
	pass
