class_name ConfigModel

var image_filetype = ["JPG", "JPEG", "PNG"]
var raw_filetype = ["NEF", "RAW"]

var folder_source: GenericTypeTransferConfig
var folders_destination: Array[FolderConfigDestination]

func _init():
	folder_source = GenericTypeTransferConfig.new()
	folders_destination = []
