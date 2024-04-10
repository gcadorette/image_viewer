class_name FolderService

var Enum = load("res://Models/Enum.gd")

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

func get_all_elements(raw_file_types: Array[Variant], img_file_types: Array[Variant]) -> TreeFolder:
	var files = _client.get_all_items()
	var root: TreeFolder = TreeFolder.new('/', '/')
	var folders = {
		root.relative_path: root
	}
	for file in files:
		var curr_elem: TreeFile = null
		var file_name = file.file_name.split("/")[-1]
		var relative_path = file.file_name.replace("/%s" % file_name, "/")
		if file.is_folder:
			curr_elem = TreeFolder.new(relative_path, "%s/" % file_name)
			if not folders.has(curr_elem.file_name):
				folders["%s%s" % [curr_elem.relative_path, curr_elem.file_name]] = curr_elem
		else:
			var file_type = file_name.split(".")[-1].to_upper()
			var filter = raw_file_types + img_file_types
			if filter.find(file_type) != -1:
				type = Enum.FolderElementTypes.raw if raw_file_types.find(file_type) else Enum.FolderElementTypes.image
				curr_elem = TreeFile.new(relative_path, file_name, file_type, type)
		if curr_elem:
			folders[relative_path].add_file(curr_elem)
	return root

func get_real_file_url(relative_path: String, filename: String) -> String:
	return _client.get_file_path("%s%s" % [relative_path, filename])
			





