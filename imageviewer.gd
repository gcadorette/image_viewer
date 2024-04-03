extends Control
var ConfigService = load("res://Service/ConfigService.gd")
var _config_service = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_config_service = ConfigService.new()


func _on_button_pressed():
	%FileDialog.show()
