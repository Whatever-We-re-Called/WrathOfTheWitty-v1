@tool
extends PopupPanel

signal saved
signal refresh
signal delete

var project = {}

@onready var label = get_node("Control/HBoxContainer3/Label")
@onready var name_text = get_node("Control/Name")
@onready var author_text = get_node("Control/Author")
@onready var path_text = get_node("Control/HBoxContainer2/Path")
@onready var url_text = get_node("Control/URL")
@onready var file_dialog = get_node("Control/HBoxContainer2/FileDialog")

func open_add_panel():
	label.text = "Add Subproject"
	project.index = -1
	open_panel()
	
	
func open_edit_panel(proj):
	label.text = "Edit Subproject"
	project = proj
	open_panel(proj.name, proj.author, proj.path, proj.url)

func open_panel(name = "", author = "", path = "", url = ""):
	name_text.text = name
	author_text.text = author
	path_text.text = path
	url_text.text = url
	
	popup_centered()


func _on_cancel_pressed():
	hide()
	file_dialog.hide()


func _on_save_pressed():
	hide()
	file_dialog.hide()
	project.name = name_text.text
	project.author = author_text.text
	project.path = path_text.text
	project.url = url_text.text
	
	saved.emit()


func _on_refresh_pressed():
	refresh.emit()
	file_dialog.hide()


func _on_delete_pressed():
	hide()
	file_dialog.hide()
	delete.emit()


func _on_file_dialog_button_pressed():
	file_dialog.show()


func _on_file_dialog_dir_selected(dir):
	dir = dir.replace("res://", "")
	if dir.ends_with("/subproject"):
		dir = dir.left(dir.length() - "/subproject".length())
	path_text.text = dir
