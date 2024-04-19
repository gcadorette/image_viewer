class_name GenericFolderClient #abstract class type beat

func get_all_items() -> Array[FolderItems]:
	return [] #defined in children's class

func get_file_path(relative_path: String) -> String:
	return relative_path #defined in children's class

func test_connection() -> String:
	return "" #to be defined by child
