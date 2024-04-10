class_name TreeFolder
extends TreeFile

var files: Array[TreeFile]

func _init(_relative_path: String, _file_name: String):
	super(_relative_path, _file_name, '', Enum.FolderElementTypes.folder)
	files = []

func add_file(file: TreeFile):
	files.append(file)
