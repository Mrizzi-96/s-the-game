extends HBoxContainer

@onready var on_btn: BasicButton = $BasicButton
@onready var off_btn: BasicButton = $BasicButton2


func _ready() -> void:
	on_btn.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	off_btn.button_pressed = DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN


func _on_on_button_pressed() -> void:
	on_btn.button_pressed = true
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	
func _on_off_button_pressed() -> void:
	off_btn.button_pressed = true
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
