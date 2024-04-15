extends BlessingExecution


func _on_battle_started(stack: int):
	var amount = 3 + ((stack  - 1) * 2)
	var player = player_info.current_player_instance
	player.decreased_opponents_max_health.emit(amount, player)
