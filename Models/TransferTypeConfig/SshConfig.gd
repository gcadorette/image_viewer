class_name SshConfig
extends GenericTypeTransferConfig
var hostname: String = ""
var port: int = -1
var username: String = ""
var password: String = ""

func _init(_hostname: String, _port: String, _username: String, _password: String):
	hostname = _hostname
	port = int(_port)
	username = _username
	password = _password
	type = Enum.FileTransferType.ssh
