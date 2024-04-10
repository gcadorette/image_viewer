extends Control

var _config_service: ConfigService = null
var _source_folder_service: FolderService = null
var _tree_service: TreeService = null
var _curr_selected: TreeItem = null
var _curr_file: TreeFile = null

func _ready():
	_config_service = ConfigService.new()
	_source_folder_service = FolderService.new(_config_service.get_folder_source())
	_tree_service = TreeService.new()
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
	switch_views()

func switch_for_source():
	var elements = _source_folder_service.get_all_elements(_config_service.get_raw_file_types(), _config_service.get_img_file_types())
	var tree = %FolderView
	tree = _tree_service.construct_tree(elements, tree)
	# TODO: Populer le side bar
	%EmptyDirectoryControl.hide()
	%PictureViewer.show()

func switch_for_prompt():
	%PictureViewer.hide()
	%EmptyDirectoryControl.show()


func _on_folder_view_item_selected():
	var tree = %FolderView
	var selected = tree.get_selected()
	var file: TreeFile = selected.get_metadata(0)
	if file:
		_curr_selected = selected
		_curr_file = file
		var url = _source_folder_service.get_real_file_url(file.relative_path, file.file_name)
		var img = Image.new()
		#img.load("\"%s\"" % url)
		img.load(url)
		%PictureViewer.texture = ImageTexture.create_from_image(img)
"""
func _input(event: InputEvent): 
	var key_button = {
		"next": %Next,
		"previous": %Previous
	}
	for key in key_button:
		if event.is_action_pressed(key):
			key_button[key].emit_signal("pressed")
"""


func _on_next_pressed():
	var tree = %FolderView
	tree.set_selected(tree.get_next_selected(_curr_selected), 0)


func _on_previous_pressed():
	print("previous!!!")
