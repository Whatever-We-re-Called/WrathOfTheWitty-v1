extends Node

var seed: String
var modes = {} # This needs to be persistent
var current_mode = null


func get_seed() -> String:
	if seed == null:
		set_seed(_generate_seed())
	return seed


func set_seed(value):
	seed = value


func _generate_seed() -> String:
	var number = ""
	for i in range(0, 8):
		number += str(randi() % 10)
	return number


func mode(mode: String) -> SeededGenerator:
	self.current_mode = mode
	return self


func start_transaction() -> SeededGenerator:
	var dict = _get_or_create_mode()
	dict.start_index = dict.index
	dict.start_loop = dict.loop
	
	return self


func drop_transaction() -> SeededGenerator:
	var dict = _get_or_create_mode()
	dict.start_index = null
	dict.start_loop = null
	
	return self


func reset_transaction() -> SeededGenerator:
	var dict = _get_or_create_mode()
	
	if dict.has("start_index") and dict.start_index != null:
		dict.index = dict.start_index
	if dict.has("start_loop") and dict.start_loop != null:
		dict.loop = dict.start_loop

	dict.hash = Hashing.hash_string(seed + str(dict.loop))
	
	return self


func _get_mode_hash() -> Array:
	var dict = _get_or_create_mode()
	if dict.hash == null:
		dict.hash = Hashing.hash_string(seed + str(dict.loop))
	return dict.hash


func _set_mode_hash(hash: Array):
	_get_or_create_mode().hash = hash


func _get_mode_index() -> int:
	return _get_or_create_mode().index
	
	
func _set_mode_index(index: int):
	_get_or_create_mode().index = index
	
	
func _get_mode_loop() -> int:
	return _get_or_create_mode().loop
	
	
func _set_mode_loop(loop: int):
	_get_or_create_mode().loop = loop
	

func _get_or_create_mode() -> Dictionary:
	if !modes.has(current_mode):
		var dict = {}
		dict.index = 0
		dict.loop = 0
		dict.hash = null
		modes[current_mode] = dict
	return modes[current_mode]


func _access() -> int:
	var index = _get_mode_index()
	var loop = _get_mode_loop()
	
	var char = _get_mode_hash()[index]
	index += 1
	if index > _get_mode_hash().size() - 1:
		index = 0
		_set_mode_hash(Hashing.hash_string(seed + str(loop)))
		loop += 1
		
	_set_mode_index(index)
	_set_mode_loop(loop)
	return char


# Returns a boolean based on a float (0-1)
func chance_of(chance: float) -> bool:
	var index = _access()
	return chance > (float(index) / float(Hashing.MAX_VALUE))
	
	
# Returns a boolean based on a percentage (0-100)
func percentage_chance_of(chance: float) -> bool:
	var index = _access()
	return chance > (float(index) / float(Hashing.MAX_VALUE)) * 100

# Returns a boolean with a 50/50 chance
func next_bool() -> bool:
	return percentage_chance_of(50)
	
	
# Returns a float between -1 and 1
func next_float() -> float:
	var _float = next_positive_float()
	return _float if next_bool() else -_float
	

# Returns a float between - and 1
func next_positive_float() -> float:
	var index = _access()
	return (float(index) / float(Hashing.MAX_VALUE))
	

# Returns an integer between 1 and <max> **Inclusive**
func next_int(max: int) -> int:
	return next_int_min_max(1, max)
	
	
# Returns an integer between <min> and <max> **Inclusive**
func next_int_min_max(min, max) -> int:
	if min > max:
		var temp = min
		min = max
		max = temp
	
	var quotient = float(_access()) / float(Hashing.MAX_VALUE)
	var diff = max - min + 1
	return floor((quotient * diff) + min)
