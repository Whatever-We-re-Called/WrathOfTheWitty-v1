extends Node2D

signal pressed

@onready var sprite_2d = $Sprite2D
@onready var button = $Button
@onready var id_label = $IDLabel

func init(room_info: RoomInfo, render_id: bool = false, id: int = 0):
	sprite_2d.texture = room_info.icon
	sprite_2d.modulate = room_info.color
	
	if render_id:
		id_label.visible = true
		id_label.text = str(id)
	else:
		id_label.visible = false


func _on_button_pressed():
	pressed.emit()
