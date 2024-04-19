extends Control
var Enum = load("res://Models/Enum.gd")
var Dimensions = load("res://Models/Dimensions.gd")

var _config_service: ConfigService = null
var _source_folder_service: FolderService = null
var _tree_service: TreeService = null
var _curr_selected: TreeItem = null
var _curr_file: TreeFile = null

func _ready():
	_config_service = ConfigService.new()
	_source_folder_service = FolderService.new(_config_service.get_folder_source())
	_tree_service = TreeService.new()
	setup_source_choice_dialog()
	switch_views()


func _on_empty_directory_button_pressed() -> void:
	%SourceChoiceDialog.show()

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

func setup_source_choice_dialog():
	var type = _source_folder_service.type

	%LocalChoice.set_pressed_no_signal(type == Enum.FileTransferType.local)
	%SshChoice.set_pressed_no_signal(type == Enum.FileTransferType.ssh)

func _on_source_choice_dialog_confirmed():
	if %LocalChoice.button_pressed:
		%FolderDialog.show()
	elif %SshChoice.button_pressed:
		set_ssh_options_dialog_edits()
		%SshOptionsDialog.show()
	else:
		return
	%SourceChoiceDialog.hide()


func _on_ssh_options_dialog_confirmed():
	reset_ssh_options_dialog()
	var config: SshConfig = SshConfig.new(%HostNameEdit.get_text(), int(%PortEdit.get_text()), %UsernameEdit.get_text(), %PasswordEdit.get_text())
	_source_folder_service = FolderService.new(config)
	var error = _source_folder_service.test_connection()
	if not error.is_empty():
		var lines = ceil(error.length() / Dimensions.SSH_OPTIONS_DIALOG_LINE_CHARS)
		var new_height = lines * Dimensions.SSH_OPTIONS_DIALOG_LINE_HEIGHT + Dimensions.SSH_OPTIONS_DIALOG_NO_ERROR_LENGTH
		%RichTextLabel.set_text(error)
		%RichTextLabel.show()
		%SshOptionsDialog.size.y = min(new_height, Dimensions.SSH_OPTIONS_DIALOG_MAX_LENGTH)
	else:
		%SshOptionsDialog.hide()
		_config_service.set_folder_source_ssh(config)
		switch_views()

func _on_ssh_options_dialog_visibility_changed():
	reset_ssh_options_dialog()

func reset_ssh_options_dialog():
	%RichTextLabel.set_text("")
	%RichTextLabel.hide()
	%SshOptionsDialog.size.y = Dimensions.SSH_OPTIONS_DIALOG_NO_ERROR_LENGTH

func set_ssh_options_dialog_edits():
	var config: SshConfig = SshConfig.new("", -1, "", "")
	if _config_service.get_folder_source_type() == Enum.FileTransferType.ssh:
		config = _config_service.get_folder_source()
	%HostNameEdit.set_text(config.hostname)
	%PortEdit.set_text(str(config.port) if config.port > 0 else "")
	%UsernameEdit.set_text(config.username)
	%PasswordEdit.set_text("")
