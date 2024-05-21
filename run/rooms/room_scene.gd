class_name RoomScene extends Control

var player_info: PlayerInfo


func _ready():
	self.player_info = RunManager.player_info
	_setup()


func _setup():
	# Intended to be extended by child.
	pass


func _process(delta):
	if Input.is_action_just_pressed("view_your_info"):
		RunManager.open_player_info_ui(get_parent())


func leave_room():
	MapManager.swap_to_map_scene()
