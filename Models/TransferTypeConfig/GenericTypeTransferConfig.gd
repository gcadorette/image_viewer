class_name GenericTypeTransferConfig
var Enum = load("res://Models/Enum.gd")
var type

func _init():
	type = Enum.FileTransferType.unknown
