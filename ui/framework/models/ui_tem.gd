extends Node
class_name UIItem


signal break_loop

var shown = false


func _ready():
	if self.visible:
		show()
		
	for child in get_children():
		if child is Button:
			child.pressed.connect(_on_click)


func show():
	if not self.visible or not shown:
		for child in get_children():
			if child is OnShow:
				child.execute()
	self.visible = true
	shown = true
	
	
func hide():
	if self.visible or shown:
		for child in get_children():
			if child is OnHide:
				await child.execute()
	self.visible = false
	shown = false


func _on_click():
	for child in get_children():
		if child is OnClick:
			child.execute()
