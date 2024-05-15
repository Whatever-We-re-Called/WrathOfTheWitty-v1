extends Node

var active_delay_timers: Dictionary


func delay_function(duration: float, caller: Node, function: Callable):
	var delay_timer = Timer.new()
	delay_timer.one_shot = true
	delay_timer.timeout.connect(_on_delay_timer_timeout.bind(caller, function, delay_timer))
	add_child(delay_timer)
	delay_timer.start(duration)
	
	if not active_delay_timers.has(caller):
		active_delay_timers[caller] = Array()
	active_delay_timers[caller].append(delay_timer)


func _on_delay_timer_timeout(caller: Node, function: Callable, timer: Timer):
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
