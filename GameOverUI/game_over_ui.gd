extends Control

func back_to_menu():
	Global.goto_scene("res://MainMenu/main_menu.tscn")

func _ready() -> void:
	RunInfo.arena_counter=0
