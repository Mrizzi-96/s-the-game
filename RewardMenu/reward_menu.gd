class_name RewardMenu
extends PanelContainer

@onready var _continue_button=$MarginContainer/VBoxContainer/BoxContainer/ContinueButton

func _on_continue_button_pressed() -> void:
	Global.goto_scene("res://Shop/shop.tscn")
