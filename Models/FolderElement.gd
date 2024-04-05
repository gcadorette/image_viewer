class_name FolderElement
var Enum = load("res://Models/Enum.gd")

var relative_path = ""

var file_name = ""
var file_type = ""
var type = Enum.FolderElementTypes.unknown

func _init(_relative_path: String, _file_name: String, _file_type: String, _type):
	relative_path = _relative_path
	file_name = _file_name
	file_type = _file_type
	type = _type
