@tool
class_name Git extends Node
	
const sub_path_no_slash = "subproject"
const sub_path = "/" + sub_path_no_slash
const _and = ' && '
	
static func pull(dir):
	_git("pull", dir + sub_path)
	
	
static func hard_reset(dir):
	_git("reset --hard", dir + sub_path)
	
	
static func clone(dir, url):
	mkdir(dir)
	_run_command('git clone ' + url + ' .', dir + sub_path)


static func mkdir(dir):
	_run_command('mkdir ' + sub_path_no_slash, dir)
	
	
static func _git(command, dir):
	_run_command("git " + command, dir)
	
static func _run_command(command, dir) -> bool:
	var output = []
	OS.execute("CMD.exe", ["/C", 'cd ' + dir + _and + command], output, true, false)
	#OS.execute("git", [command], output)
	var err = false;
	for str in output:
		if (str.contains("fatal")):
			printerr(str)
			err = true
		else:
			debug(str)
	return !err
