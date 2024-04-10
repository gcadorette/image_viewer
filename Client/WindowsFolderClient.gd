class_name WindowsFolderClient
extends GenericFolderClient
var _dir: String = ""

func _init(config: WindowsFileSystemConfig): 
	_dir = config.dir

func get_all_items() -> Array[FolderItems]:
	return _get_all_items_recurr([], _dir)

func _get_all_items_recurr(found_files: Array[FolderItems], path: String) -> Array[FolderItems]:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			file_name = file_name.replace(_dir, "")
			file_name = "%s/%s" % [path, file_name]
			var is_folder = dir.current_is_dir()
			var curr_item = FolderItems.new(is_folder, file_name.replace("%s" % _dir, ""))
			found_files.append(curr_item)
			if is_folder:
				found_files = _get_all_items_recurr(found_files, file_name)
			file_name = dir.get_next()
		return found_files
	else:
		return found_files

func get_file_path(relative_path: String) -> String:
	return "%s%s" % [_dir, relative_path]
