class_name LootTable extends Resource

@export var entries: Array[LootTableEntry]


func get_random_unique_entries(quantity: int) -> Array[Resource]:
	var result: Array[Resource]
	
	var entries_copy = entries.duplicate()
	var rng = RandomNumberGenerator.new()
	while quantity > 0:
		var total_weight = _get_total_weight_of_entries(entries_copy)
		var number = rng.randi_range(1, total_weight)
		var i = 0
		while number > 0:
			number -= entries_copy[i].weight
			if number <= 0:
				result.append(entries_copy[i])
				break
			i += 1
		quantity -= 1
		entries_copy.remove_at(i)
	
	return result


func _get_total_weight_of_entries(entries: Array[LootTableEntry]):
	var result: int
	for entry in entries:
		result += entry.weight
	return result
