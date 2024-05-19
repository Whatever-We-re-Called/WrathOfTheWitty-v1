extends Node2D

@export_category("Refs")
@export var camera: Camera2D
@export var player: Node2D

@export_category("Generator")
@export var generator: Resource
@export var settings: GeneratorSettings
@export var render_ids = false

@onready var current_floor_label = %CurrentFloorLabel
@onready var max_floor_label = %MaxFloorLabel
@onready var canvas_layer = $CanvasLayer

var root
var selected_node = null

const PLAYER_INFO_UI = preload("res://players/info/player_info_ui.tscn")

func _ready():
	generate()
	
	draw(root, null)
	draw_lines(root)
	current_floor_label.text = str(RunManager.floor)
	max_floor_label.text = str(RunManager.LAST_FLOOR)
	
	camera.setup(root, selected_node)


func _process(delta):
	_handle_control_input()


func _handle_control_input():
	if Input.is_action_just_pressed("view_your_info"):
		_open_player_info_ui()
	
	# Debug
	if Input.is_action_just_pressed("debug_1"):
		MapManager.generate_new_map()
		MapManager.swap_to_map_scene()
	if Input.is_action_just_pressed("debug_2"):
		if selected_node.connections.size() > 0:
			var next_node = selected_node.connections[0]
			set_selected_node(next_node)
			camera.update_position(next_node)
		else:
			MapManager.go_to_next_floor()


func _open_player_info_ui():
	var player_info_ui = PLAYER_INFO_UI.instantiate()
	canvas_layer.add_child(player_info_ui)
	player_info_ui.init(RunManager.player_info)


func generate():
	SeededGenerator.mode("map").reset_transaction().start_transaction()
	MapNode.index = 0
	root = generator.new().generate(settings)


func draw(map_node, parent):
	map_node.draw(parent, self, render_ids)
	for node in map_node.connections:
		draw(node, map_node)
		
	if map_node.id == MapManager.selected_node_id:
		set_selected_node(map_node)


func draw_lines(map_node):
	map_node.draw_lines(self)
	for node in map_node.connections:
		draw_lines(node)


func select(map_node):
	for node in selected_node.connections:
		if node.id == map_node.id:
			enter_room(map_node)


func set_selected_node(map_node):
	selected_node = map_node
	MapManager.selected_node_id = map_node.id
	player.position = map_node.position


func enter_room(map_node: MapNode):
	set_selected_node(map_node)
	if map_node.id != 0:
		get_tree().change_scene_to_packed(map_node.room_info.target_scene)
