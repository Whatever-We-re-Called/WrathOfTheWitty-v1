extends PopupPanel

@onready var name_text = get_node("Name")
@onready var path_text = get_node("Path")
@onready var url_text = get_node("URL")

func open(name, path, url):
	name_text.text = name
	path_text.text = path
	url_text.text = url
	
	popup_centered()
