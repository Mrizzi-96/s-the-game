class_name RewardMenu
extends PanelContainer

@onready var _continue_button=$MarginContainer/VBoxContainer/BoxContainer/ContinueButton

func _on_continue_button_pressed() -> void:
	Global.goto_scene("res://Shop/shop.tscn")


func _on_reward_pressed() -> void:
	_continue_button.show()
