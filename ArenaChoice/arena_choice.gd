extends Control

@onready var arena_params = ArenaParams.new()
# WARNING:
# For now, on button click the arena params will be added as hardcoded.
# @jadedpear will then use the ones from his arena_preview scene
# see #TG-110 on Taiga 

func back_to_menu():
	Global.goto_scene("res://MainMenu/main_menu.tscn")

func goto_arena_1():
	var arena_path = "res://Levels/arena1.tscn"
	arena_params.arena_scene = preload("res://Levels/arena1.tscn")
	arena_params.difficulty = 1
	arena_params.reward_type = ArenaParams.RewardType.WEAPON
	RunInfo.current_arena_params = arena_params
	
	Global.goto_scene(arena_path)

func goto_arena_2():
	var arena_path = "res://Levels/arena2.tscn"
	arena_params.arena_scene = preload("res://Levels/arena2.tscn")
	arena_params.difficulty = 2
	arena_params.reward_type = ArenaParams.RewardType.GOLD	
	RunInfo.current_arena_params = arena_params
	
	Global.goto_scene(arena_path)

func goto_arena_3():
	var arena_path = "res://Levels/arena3.tscn"
	arena_params.arena_scene = preload("res://Levels/arena3.tscn")
	arena_params.difficulty = 3
	arena_params.reward_type = ArenaParams.RewardType.SKILL
	RunInfo.current_arena_params = arena_params
	
	Global.goto_scene(arena_path)
