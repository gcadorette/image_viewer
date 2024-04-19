class_name FolderService

var Enum = load("res://Models/Enum.gd")

var _client: GenericFolderClient = null
var type = Enum.FileTransferType.unknown
var _curr_folder: Dictionary = {}

func _init(config: GenericTypeTransferConfig):
	type = config.type
	match type:
		Enum.FileTransferType.local:
			var local_folder_config: LocalFileSystemConfig = config
			_client = LocalFolderClient.new(local_folder_config)
		Enum.FileTransferType.ssh:
			var ssh_config: SshConfig = config
			_client = SshClient.new(ssh_config)
		_:
			pass

func has_source() -> bool:
	return type != Enum.FileTransferType.unknown

func get_all_elements(raw_file_types: Array[Variant], img_file_types: Array[Variant]) -> TreeFolder:
	var files = _client.get_all_items()
	var root: TreeFolder = TreeFolder.new('/', '/')
	_curr_folder = {
		root.relative_path: root
	}
	for file in files:
		var curr_elem: TreeFile = null
		var file_name = file.file_name.split("/")[-1]
		var relative_path = file.file_name.replace("/%s" % file_name, "/")
		if file.is_folder:
			curr_elem = TreeFolder.new(relative_path, "%s/" % file_name)
			if not _curr_folder.has(curr_elem.file_name):
				_curr_folder["%s%s" % [curr_elem.relative_path, curr_elem.file_name]] = curr_elem
		else:
			var file_type = file_name.split(".")[-1].to_upper()
			var filter = raw_file_types + img_file_types
			if filter.find(file_type) != -1:
				type = Enum.FolderElementTypes.raw if raw_file_types.find(file_type) else Enum.FolderElementTypes.image
				curr_elem = TreeFile.new(relative_path, file_name, file_type, type)
		if curr_elem:
			_curr_folder[relative_path].add_file(curr_elem)
	return root

func get_real_file_url(relative_path: String, filename: String) -> String:
	return _client.get_file_path("%s%s" % [relative_path, filename])
			
func test_connection() -> String:
	return _client.test_connection()




