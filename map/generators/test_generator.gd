extends MapGenerator

func generate(settings: GeneratorSettings):
	var root = MapNode.new()
	
	var connection = MapNode.new()
	connection.set_offsets(250 * SeededGenerator.next_float(), 250)
	root.connect_node(connection)
	
	var connection3 = MapNode.new()
	connection3.set_offsets(250 * SeededGenerator.next_float(), 250)
	connection.connect_node(connection3)
	
	var connection4 = MapNode.new()
	connection4.set_offsets(250 * SeededGenerator.next_float(), 250)
	connection3.connect_node(connection4)
	
	var connection5 = MapNode.new()
	connection5.set_offsets(250 * SeededGenerator.next_float(), 250)
	connection4.connect_node(connection5)
	
	var connection6 = MapNode.new()
	connection6.set_offsets(250 * SeededGenerator.next_float(), 250)
	connection5.connect_node(connection6)
	
	var connection7 = MapNode.new()
	connection7.set_offsets(250 * SeededGenerator.next_float(), 250)
	connection6.connect_node(connection7)
	connection7.room_script = preload("res://map/rooms/exit/exit_room.tscn").instantiate()
	
	return root
