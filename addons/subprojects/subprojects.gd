@tool
extends EditorPlugin

var git
var dock
var add_button
var subprojects

func _enter_tree():
	setup()
	update_all()

func setup():
	# Initialization of the plugin goes here.
	dock = preload("res://addons/subprojects/dock.tscn").instantiate()
	git = dock.get_node("Git")
	
	var cfg_contents = FileAccess.get_file_as_string("res://addons/subprojects/subprojects.cfg") 
	subprojects = JSON.parse_string(cfg_contents).projects
	
	var offset = 0
	for project in subprojects:
		var project_line = preload("res://addons/subprojects/project_line.tscn").instantiate()
		var label = project.author + "/" + project.name
		var path = "[i]" + project.path + "[/i]"
		
		project_line.get_node("HSplitContainer/VSplitContainer/Label").text = label
		project_line.get_node("HSplitContainer/VSplitContainer/Path").text = path
		
		project_line.position.y = offset
		offset += 60
		
		dock.add_child(project_line)
	
	add_button = preload("res://addons/subprojects/add_button.tscn").instantiate()
	add_button.position.y = offset
	dock.add_child(add_button)
	
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)

func update_all():
	for proj in subprojects:
		if project_exists(proj):
			print("Updating " + proj.name)
			git.hard_reset(proj.path)
			git.pull(proj.path)
		else:
			print("Creating " + proj.name)
			git.clone(proj.path, proj.url)


func project_exists(proj) -> bool:
	var dir = DirAccess.open(proj.path)
	return dir.dir_exists("man_subproj/.git")


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dock)
	

func _build() -> bool:
	update_all()
	return true


func _process(delta):
	add_button.size.x = add_button.get_parent().size.x
