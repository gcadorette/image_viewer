extends Control

var _config_service = null
var _source_folder_service: FolderService = null

func _ready():
	_config_service = ConfigService.new()
	_source_folder_service = FolderService.new(_config_service.get_folder_source())
	switch_views()


func _on_button_pressed() -> void:
	%FolderDialog.show()

func switch_views() -> void:
	var config = _config_service.get_folder_source()
	if config.type != _source_folder_service.type:
		_source_folder_service = FolderService.new(config)

	if _source_folder_service.has_source():
		switch_for_source()
	else:
		switch_for_prompt()

func _on_native_file_dialog_dir_selected(dir: String) -> void:
	_config_service.set_folder_source_windows(dir)
	var elements = _source_folder_service.get_all_elements(_config_service.get_raw_file_types(), _config_service.get_img_file_types())
	switch_views()

func switch_for_source():
	var elements = _source_folder_service.get_all_elements(_config_service.get_raw_file_types(), _config_service.get_img_file_types())
	# TODO: Populer le side bar
	%EmptyDirectoryControl.hide()
	%PictureViewer.show()

func switch_for_prompt():
	%PictureViewer.hide()
	%EmptyDirectoryControl.show()
