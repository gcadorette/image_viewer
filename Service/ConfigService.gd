class_name ConfigService

var ConfigModel = load("res://Models/Config.gd")
var Enum = load("res://Models/Enum.gd")
var GenericTypeTransferConfig = load("res://Models/TransferTypeConfig/GenericTypeTransferConfig.gd")
var WindowsFileSystemConfig = load("res://Models/TransferTypeConfig/WindowsFileSystemConfig.gd")
var FolderConfigDestination = load("res://Models/FolderConfigDestination.gd")

const CONFIG_FILE_PATH = "user://config.ini"
const GENERAL_SECTION = "General"
const FOLDER_SRC_SECTION = "FolderSrc"
const SEPARATOR = "|"

var _config_file: ConfigFile = null
var _config_obj: ConfigModel = null

func _init():
	#fichier de config peut-être uniquement nécessaire pour les raw files types / img file types?
	#ca vaut tu la peine de sauvegarder le src/dest folder? À moins que ça soit par projet (ou par folder de source, ig)
	#au pire on sauvegarde toute et, au démarage, au demande si on veut continuer ou recommencer? Si recommencer, reset la config avec les valeurs par defaut
	_config_file = ConfigFile.new()
	_config_obj = ConfigModel.new()
	
	var err = _config_file.load(CONFIG_FILE_PATH)
	
	if err != OK:
		err = _save()  #try to create the file
		if err != OK:
			print("File couldn't be accessed")
			return
	
	var all_sections = _config_file.get_sections()
	
	for section in all_sections:
		match section:
			GENERAL_SECTION:
				var raw_filetypes_crude = _config_file.get_value(GENERAL_SECTION, "raw_file_type")
				var img_filetypes_crude = _config_file.get_value(GENERAL_SECTION, "img_file_type")

				_config_obj.raw_filetype = raw_filetypes_crude.split(SEPARATOR)
				_config_obj.image_filetype = img_filetypes_crude.split(SEPARATOR)
			FOLDER_SRC_SECTION:
				var type = int(_config_file.get_value(FOLDER_SRC_SECTION, "type"))
				if type == Enum.FileTransferType.windows_folders:
					var dir = _config_file.get_value(FOLDER_SRC_SECTION, "dir")
					var source_tt_config = WindowsFileSystemConfig.new(dir)
					source_tt_config.type = type
					_config_obj.folder_source = source_tt_config

	
func get_folder_source() -> GenericTypeTransferConfig:
	return _config_obj.folder_source

func set_folder_source_windows(dir: String) -> void:
	var source_tt_config = WindowsFileSystemConfig.new(dir)
	
	_config_file.set_value("FolderSrc", "dir", dir)
	_config_file.set_value("FolderSrc", "type", source_tt_config.type)
	_config_obj.folder_source = source_tt_config
	_save()

func get_raw_file_types() -> Array[Variant]:
	return _config_obj.raw_filetype

func get_img_file_types() -> Array[Variant]:
	return _config_obj.image_filetype

func _save() -> bool:
	var inified_raw_file_types = _dir_to_ini_file(get_raw_file_types())
	var inified_image_file_types = _dir_to_ini_file(get_img_file_types())
	_config_file.set_value(GENERAL_SECTION, "raw_file_type", inified_raw_file_types)
	_config_file.set_value(GENERAL_SECTION, "img_file_type", inified_image_file_types)

	return _config_file.save(CONFIG_FILE_PATH)

func _dir_to_ini_file(file_types: Array[Variant]) -> String:
	var inified_types = file_types[0]
	
	for file_type in file_types.slice(1, file_types.size()):
		inified_types += "%s%s" % [SEPARATOR, file_type]
	return inified_types
