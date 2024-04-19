class_name LocalFileSystemConfig
extends GenericTypeTransferConfig
var dir: String = ""

func _init(_dir: String):
	dir = _dir
	type = Enum.FileTransferType.local
