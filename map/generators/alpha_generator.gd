extends MapGenerator

var settings

func generate(settings: GeneratorSettings) -> MapNode:
	self.settings = settings
	
	var root = _get_new_map_node()
	var previous = [ root ]
	
	generate_next_level(previous, 0)
	connect_dead_ends(previous, 0)
	set_offsets(previous, 0)
	set_room_types(previous)
	
	return root


func debug(message: String):
	if settings.print:
		print(message)


func generate_next_level(previous, level):
	debug("Generating level: " + str(level))
	if level == 0:
		previous = gen_first_level(previous[0])
	elif level < settings.get_levels() - 1:
		previous = gen_standard_level(previous)
	elif level >= settings.get_levels() - 1:
		gen_boss_level(previous)
		
	if level < settings.get_levels() - 1:
		generate_next_level(previous, level + 1)


func gen_first_level(node) -> Array:
	for i in 2 if SeededGenerator.percentage_chance_of(settings.split_from_one) else 1:
		node.connect_node(_get_new_map_node())
	return node.connections

	
func gen_standard_level(previous: Array) -> Array:
	if previous.size() == 1:
		for i in 2 if SeededGenerator.percentage_chance_of(settings.split_from_one) else 1:
			previous[0].connect_node(_get_new_map_node())
		return previous[0].connections
		
	var node_count = previous.size()
	var new_nodes = []
	for node in previous:
		
		if SeededGenerator.percentage_chance_of(settings.split_into_two) and node_count < settings.max_nodes_width:
			node_count += 1
			debug("split: 2")
			for i in 2:
				node.connect_node(_get_new_map_node())
		elif SeededGenerator.percentage_chance_of(settings.split_into_three) and node_count + 1 < settings.max_nodes_width:
			node_count += 2
			debug("split: 3")
			for i in 3:
				node.connect_node(_get_new_map_node())
		elif !SeededGenerator.percentage_chance_of(settings.dead_end):
			debug("continue")
			node.connect_node(_get_new_map_node())
		else:
			debug("dead_end")
		
		if node.connections.size() > 0:
			new_nodes.append_array(node.connections)
		
	if new_nodes.size() == 0:
		var next = _get_new_map_node()
		for node in previous:
			node.connect_node(next)
		new_nodes.append(next)
		
	return new_nodes


func gen_boss_level(previous):
	var boss = _get_new_map_node()
	# TODO Refactor this to be less hard-coded.
	boss.init(preload("res://map/rooms/info/boss_battle_room_info.tres"))
	MapManager.boss_node_id = boss.id
	
	for node in previous:
		node.connect_node(boss)


func connect_dead_ends(nodes, level):
	debug("Connecting ends for level: " + str(level))
	debug("Nodes: " + str(nodes.size()))
	if level >= settings.get_levels() - 1:
		return

	for i in nodes.size():
		var node = nodes[i]
		debug("Node: (" + str(i) + ") " + str(node.id))
		if node.connections.size() == 0:
			if settings.connect:
				connect_to_closest_child(nodes, i)
			else:
				if i != 0 and i != nodes.size() - 1:
					SeededGenerator.next_bool()
	
	var new_nodes = []
	var new_node_ids = []
	for node in nodes:
		for connection in node.connections:
			debug("connection: " + str(connection.id))
			if !new_node_ids.has(connection.id):
				new_node_ids.append(connection.id)
				new_nodes.push_back(connection)
	
	connect_dead_ends(new_nodes, level + 1)
	

func connect_to_closest_child(nodes, i):
	debug("Connecting to closest child: id: " + str(nodes[i].id) + " i: " + str(i))
	if i == 0:
		debug("i == 0")
		for node_index in nodes.size():
			if nodes[node_index].connections.size() > 0:
				nodes[0].connect_node(nodes[node_index].connections[0])
				break
				
	elif i == nodes.size() - 1:
		debug("i == nodes.size() - 1")
		for node_index in nodes.size():
			debug("Checking node: " + str(nodes[nodes.size() - node_index - 1].id))
			if nodes[nodes.size() - node_index - 1].connections.size() > 0:
				debug("Node " + str(nodes[nodes.size() - node_index - 1].id) + " has valid connections")
				nodes[i].connect_node(nodes[nodes.size() - node_index - 1].connections[nodes[nodes.size() - node_index - 1].connections.size() - 1])
				debug("Connected to node: " + str(nodes[nodes.size() - node_index - 1].connections[nodes[nodes.size() - node_index - 1].connections.size() - 1].id))
				break
				
	else:
		var direction = 1 if SeededGenerator.next_bool() else -1
		
		var connecting_node = null
		var connecting_node_index = 1
		var attempts = 0
		while connecting_node == null and attempts < 1000:
			attempts += 1
			if attempts == 1000:
				debug("Failed to connect")
			if i - (direction * connecting_node_index) < 0 or i - (direction * connecting_node_index) >= nodes.size():
				connecting_node_index = 1
				direction *= -1
					
			debug("Checking node: " + str(nodes[i - (direction * connecting_node_index)].id))
			if nodes[i - (direction * connecting_node_index)].connections.size() > 0:
				connecting_node = nodes[i - (direction * connecting_node_index)]
				debug("Node " + str(nodes[i - (direction * connecting_node_index)].id) + " has valid connections")
			else:
				connecting_node_index += 1
		
		var connection_size = connecting_node.connections.size()
		if connection_size == 1:
			nodes[i].connect_node(connecting_node.connections[0])
		else:
			nodes[i].connect_node(connecting_node.connections[connecting_node.connections.size() - 1 if direction == 1 else 0])
	
	
	
func set_offsets(nodes, level):
	if level > settings.get_levels():
		return
	
	if level != 0:
		for node in nodes:
			node.y_offset = 250 + SeededGenerator.next_int_min_max(-50, 50)
		
		var spacing = min(500, settings.max_position_width / nodes.size())
		for i in nodes.size():
			var x = (i - (nodes.size() - 1) / 2.0) * spacing
			nodes[i].x_offset = x
			
	
	var new_nodes = []
	var new_node_ids = []
	for node in nodes:
		for connection in node.connections:
			if !new_node_ids.has(connection.id):
				new_node_ids.append(connection.id)
				new_nodes.append(connection)
	
	set_offsets(new_nodes, level + 1)
	
	
func set_room_types(previous):
	pass


func _get_new_map_node(room_info: RoomInfo = null) -> MapNode:
	var new_map_node = MapNode.new()
	if room_info == null:
		var chosen_room_info_index = SeededGenerator.next_int(temporary_room_pool.size()) - 1
		room_info = temporary_room_pool[chosen_room_info_index]
	new_map_node.init(room_info)
	return new_map_node
