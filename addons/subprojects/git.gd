@tool
extends Node
	
var sub_path_no_slash = "subproject"
var sub_path = "/" + sub_path_no_slash
var _and = ' && '
	
func pull(dir):
	_git("pull", dir + sub_path)
	
	
func hard_reset(dir):
	_git("reset --hard", dir + sub_path)
	
	
func clone(dir, url):
	mkdir(dir)
	_run_command('git clone ' + url + ' .', dir + sub_path)


func mkdir(dir):
	_run_command('mkdir ' + sub_path_no_slash, dir)
	
	
func _git(command, dir):
	_run_command("git " + command, dir)
	
func _run_command(command, dir) -> bool:
	var output = []
	OS.execute("CMD.exe", ["/C", 'cd ' + dir + _and + command], output, true, false)
	#OS.execute("git", [command], output)
	var err = false;
	for str in output:
		if (str.contains("fatal")):
			printerr(str)
			err = true
		else:
			print(str)
	return !err
