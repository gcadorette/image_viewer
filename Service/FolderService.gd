class_name FolderService

var Enum = load("res://Models/Enum.gd")
var FolderItems = load("res://Models/FolderItems.gd")
var FolderElement = load("res://Models/FolderElement.gd")

var _client: GenericFolderClient = null
var type = Enum.FileTransferType.unknown

func _init(config: GenericTypeTransferConfig):
	type = config.type
	match type:
		Enum.FileTransferType.windows_folders:
			var windows_folders_config: WindowsFileSystemConfig = config
			_client = WindowsFolderClient.new(windows_folders_config)
		Enum.FileTransferType.ssh:
			pass
		_:
			pass

func has_source() -> bool:
	return type

func get_all_elements(raw_file_types: Array[Variant], img_file_types: Array[Variant]) -> Array[FolderElement]:
	var files = _client.get_all_items()
	var elements: Array[FolderElement] = []
	for file in files:
		var curr_elem = null
		if file.is_folder:
			curr_elem = FolderElement.new(file.file_name, "", "", Enum.FolderElementTypes.folder)
		else:
			var file_name = file.file_name.split("/")[-1]
			var relative_path = file.file_name.replace("/%s" % file_name, "")
			var file_type = file_name.split(".")[-1]

			var filter = raw_file_types + img_file_types
			if filter.find(file_type) != -1:
				var type = Enum.FolderElementTypes.raw if raw_file_types.find(file_type) else Enum.FolderElementTypes.image
				curr_elem = FolderElement.new(relative_path, file_name, file_type, type)
		if curr_elem:
			elements.append(curr_elem)
	return elements
			





