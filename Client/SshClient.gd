class_name SshClient
extends GenericFolderClient
var ssh_net_wrapper = load("res://CSharp/SshNetWrapper.cs")

var config: SshConfig = null
var _wrapper = null

func _init(_config: SshConfig):
	config = _config
	_wrapper = ssh_net_wrapper.new(config.hostname, config.port, config.username, config.password)

func get_all_items() -> Array[FolderItems]:
	return [] #defined in children's class

func get_file_path(relative_path: String) -> String:
	return relative_path #defined in children's class

func test_connection() -> String:
	var result = _wrapper.TestConnection()
	print(result)
	return result