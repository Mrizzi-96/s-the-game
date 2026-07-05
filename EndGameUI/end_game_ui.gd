class_name EndGameUi
extends Control

func _ready() -> void:
	$VBoxContainer/HBoxContainer/Label3.text=str(RunInfo.total_score)
	


func _on_main_menu_button_button_up() -> void:
	Global.goto_scene("res://MainMenu/main_menu.tscn")
