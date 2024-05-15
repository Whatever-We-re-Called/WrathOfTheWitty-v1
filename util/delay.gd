extends Node

func delay_function(duration: float, caller: Node, function: Callable):
	await get_tree().create_timer(duration).timeout
	
	if caller == null: return
	if not is_instance_valid(caller): return
	if not caller.is_inside_tree(): return
	
	function.call()
