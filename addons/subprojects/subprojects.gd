@tool
extends EditorPlugin

var dock
var add_button
var subprojects
var edit_window
var project_lines

func _enter_tree():
	init()
	update_all()


func init():
	dock = preload("res://addons/subprojects/dock.tscn").instantiate()

	edit_window = dock.get_node("EditDialogue")
	edit_window.saved.connect(save_all)
	edit_window.refresh.connect(update_current)
	edit_window.delete.connect(delete_current)
	
	add_button = preload("res://addons/subprojects/add_button.tscn").instantiate()
	add_button.pressed.connect(open_edit_window)
	
	var cfg_contents = FileAccess.get_file_as_string("res://addons/subprojects/subprojects.cfg") 
	subprojects = JSON.parse_string(cfg_contents).projects
	
	setup()
	
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)

func setup():
	project_lines = []
	
	var offset = 0
	var index = 0;
	for project in subprojects:
		project.index = index
		index += 1
		var project_line = preload("res://addons/subprojects/project_line.tscn").instantiate()
		var label = project.author + "/" + project.name
		var path = "[i]" + project.path + "[/i]"
		
		project_line.get_node("HSplitContainer/VSplitContainer/Label").text = label
		project_line.get_node("HSplitContainer/VSplitContainer/Path").text = path
		project_line.get_node("HSplitContainer/CenterContainer/Button").pressed.connect(open_edit_window.bind(project))
		
		project_line.position.y = offset
		offset += 60
		
		project_lines.append(project_line)
		
		dock.add_child(project_line)
	
	add_button.position.y = offset
	dock.add_child(add_button)


func clear_lines():
	dock.remove_child(add_button)
	for line in project_lines:
		dock.remove_child(line)
	

func update_all():
	for proj in subprojects:
		update(proj)
			
			
			
func update_current():
	update(edit_window.project)
	

func update(proj):
	if proj.index == -1:
		pass
	elif project_exists(proj):
		debug("Updating " + proj.name)
		Git.hard_reset(proj.path)
		Git.pull(proj.path)
	else:
		debug("Creating " + proj.name)
		Git.clone(proj.path, proj.url)

func project_exists(proj) -> bool:
	var dir = DirAccess.open(proj.path)
	return dir.dir_exists(Git.sub_path_no_slash + "/.Git")


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dock)
	

func _build() -> bool:
	update_all()
	return true


func open_edit_window(proj = null):
	if proj == null:
		edit_window.open_add_panel()
	else:
		edit_window.open_edit_panel(proj)


func _process(delta):
	add_button.size.x = add_button.get_parent().size.x
	
	
func save_all():
	if edit_window.project.index != -1:
		subprojects[edit_window.project.index] = edit_window.project
	else:
		edit_window.project.index = subprojects.size()
		subprojects.push_back(edit_window.project)
	
	save_to_file()
	

func delete_current():
	if edit_window.project.index != -1:
		subprojects.remove_at(edit_window.project.index)
		save_to_file()
	
	
func save_to_file():
	var projects = {}
	projects.projects = subprojects
	
	var file = FileAccess.open("res://addons/subprojects/subprojects.cfg", FileAccess.WRITE)
	file.store_string(JSON.stringify(projects, "\t"))
	
	clear_lines()
	setup()
