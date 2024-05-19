extends Node

enum ActiveMovingNodeData { TARGET_POSITION, SPEED, DURATION }

var active_delay_timers: Dictionary
var active_moving_nodes: Dictionary


func delay_function(duration: float, caller: Node, function: Callable):
	var delay_timer = Timer.new()
	delay_timer.one_shot = true
	delay_timer.timeout.connect(_on_delay_timer_timeout.bind(caller, function, delay_timer))
	add_child(delay_timer)
	delay_timer.start(duration)
	
	if not active_delay_timers.has(caller):
		active_delay_timers[caller] = Array()
	active_delay_timers[caller].append(delay_timer)


func _on_delay_timer_timeout(caller, function, timer):
	if not active_delay_timers.has(caller): return
	
	if caller == null: return
	if not is_instance_valid(caller): return
	if not caller.is_inside_tree(): return
	
	function.call()
	
	for i in range(active_delay_timers[caller].size()):
		if active_delay_timers[caller][i] == timer:
			active_delay_timers[caller].remove_at(i)
			break
	timer.queue_free()


func cancel_all_delays(caller: Node):
	if not active_delay_timers.has(caller): return
	
	for delay_timer in active_delay_timers[caller]:
		delay_timer.stop()
	active_delay_timers.erase(caller)


func _process(delta):
	for active_moving_node in active_moving_nodes:
		if active_moving_node == null: return
		if not is_instance_valid(active_moving_node): return
		if not active_moving_node.is_inside_tree(): return
		
		var target_position = active_moving_nodes[active_moving_node][ActiveMovingNodeData.TARGET_POSITION]
		var speed = active_moving_nodes[active_moving_node][ActiveMovingNodeData.SPEED]
		var calculated_speed = speed * delta
		active_moving_node.position = active_moving_node.position.move_toward(target_position, calculated_speed)


func move_toward_overtime(moving_node: Node, target_position: Vector2,  speed: float, duration: float):
	active_moving_nodes[moving_node] = {
		ActiveMovingNodeData.TARGET_POSITION: target_position,
		ActiveMovingNodeData.SPEED: speed,
		ActiveMovingNodeData.DURATION: duration
	}
	
	delay_function(duration, self, func():
		active_moving_nodes.erase(moving_node)
	)
