class_name WindowsFileSystemConfig

extends GenericTypeTransferConfig
var dir: String = ""

func _init(_dir: String):
	dir = _dir
	type = Enum.FileTransferType.windows_folders
