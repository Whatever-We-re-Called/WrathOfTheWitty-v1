extends Node2D
class_name SplinePath

var points: Array
var handling: float
var speed: float

static func of(handling: float, speed: float, points: Array) -> SplinePath:
	if handling <= 0:
		printerr("Handling must be greater than 0")
		return null
	if speed <= 0:
		printerr("Speed must be greater than 0")
		return null
	
	var spline = SplinePath.new()
	spline.handling = handling
	spline.speed = speed
	spline.points = points
	return spline

func get_origin() -> Vector2:
	return points[0]
	

func get_destination() -> Vector2:
	return points[points.size() - 1]


func get_speed() -> float:
	return speed
	
	
func get_points() -> Array:
	return points
	
	
func get_path_points() -> Array:
	var list = []
	
	var v = get_origin()
	list.append(v)
	
	var target = points[1]
	var speed_squared = speed * speed
	
	var direction = target - v
	direction = direction.normalized() * speed
	
	var index = 1
	var attempts = 0
	
	while true:
		if v.distance_squared_to(target) < speed_squared:
			if target == get_destination():
				list.append(target)
				break
			
			attempts = 0
			index += 1
			target = points[index]
		
		var turn_additive = target - v
		turn_additive = turn_additive.normalized() * handling
		
		direction += turn_additive
		direction = direction.normalized() * speed
		
		v += direction
		list.append(v)
		
		attempts += 1
		if attempts > 10000 * handling:
			break
			
	return list
