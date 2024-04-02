class_name ConfigService

var Config = load("res://Models/Config.gd")
var Enum = load("res://Models/Enum.gd")
var GenericTypeTransferConfig = load("res://Models/TransferTypeConfig/GenericTypeTransferConfig.gd")
var WindowsFileSystemConfig = load("res://Models/TransferTypeConfig/WindowsFileSystemConfig.gd")
var FolderConfigDestination = load("res://Models/FolderConfigDestination.gd")

const CONFIG_FILE_PATH = "user://config.ini"
var _config_file = null
var _config_obj = null

func _init():
	_config_file = ConfigFile.new()
	_config_obj = Config.new()
	
	var err = _config_file.load(CONFIG_FILE_PATH)
	
	if err != OK:
		err = _config_file.save(CONFIG_FILE_PATH)
		if err != OK:
			print("File couldn't be accessed")
			return
	
	# TODO: Lire la config
	
func get_folders_source() -> void: #TODO: Determiner la config à envoyer au UI
	pass # TODO

func create_folder_source_windows(dir: String) -> void:
	var index = len(_config_obj.folders_source)
	var source_tt_config = {dir: dir}
	
	var section_name = "Folder%dSrc" % index
	_config_file.set_value("section_name", "dir", dir)
	_config_obj.folders_source.append(source_tt_config)
