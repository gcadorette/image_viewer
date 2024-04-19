class_name ConfigService

var Enum = load("res://Models/Enum.gd")

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

				_config_obj.raw_filetype = _unseparated_ini_config_to_capped_array(raw_filetypes_crude)
				_config_obj.image_filetype = _unseparated_ini_config_to_capped_array(img_filetypes_crude)
			FOLDER_SRC_SECTION:
				var type = int(_config_file.get_value(FOLDER_SRC_SECTION, "type"))
				if type == Enum.FileTransferType.local:
					var dir = _config_file.get_value(FOLDER_SRC_SECTION, "dir")
					var source_tt_config = LocalFileSystemConfig.new(dir)
					source_tt_config.type = type
					_config_obj.folder_source = source_tt_config
				elif type == Enum.FileTransferType.ssh:
					var hostname = _config_file.get_value(FOLDER_SRC_SECTION, "hostname")
					var port = _config_file.get_value(FOLDER_SRC_SECTION, "port")
					var username = _config_file.get_value(FOLDER_SRC_SECTION, "username")
					var config = SshConfig.new(hostname, port, username, "")
					_config_obj.folder_source = config

func get_folder_source_type():
	return _config_obj.folder_source.type

func get_folder_source() -> GenericTypeTransferConfig:
	return _config_obj.folder_source

func set_folder_source_windows(dir: String) -> void:
	var source_tt_config = LocalFileSystemConfig.new(dir)
	
	_config_file.set_value(FOLDER_SRC_SECTION, "dir", dir)
	_config_file.set_value(FOLDER_SRC_SECTION, "type", source_tt_config.type)
	_config_obj.folder_source = source_tt_config
	_save()

func set_folder_source_ssh(config: SshConfig) -> void:
	_config_file.set_value(FOLDER_SRC_SECTION, "type", config.type)
	_config_file.set_value(FOLDER_SRC_SECTION, "hostname", config.hostname)
	_config_file.set_value(FOLDER_SRC_SECTION, "port", config.port)
	_config_file.set_value(FOLDER_SRC_SECTION, "username", config.username)

	_config_obj.folder_source = config
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

func _unseparated_ini_config_to_capped_array(ini_config: String) -> Array[String]:
	var uncapped_splitted = ini_config.split(SEPARATOR)
	var capped_array: Array[String] = []
	for uncapped in uncapped_splitted:
		capped_array.append(uncapped.to_upper())
	return capped_array
