class_name ArenaManager
extends Node2D

@onready var _player_spawner = $Environment/PlayerSpawner

@export var max_enemy_num:int=10

@onready var _timer_view=$UI/HBoxContainer/TimerView

@onready var _spawn_component=$Components/SpawnComponent

#TODO: pass dynamic difficulty from selection
var arena_difficulty: int = 1

func _ready() -> void:
	_timer_view.start()
	_spawn_component._configure(max_enemy_num, arena_difficulty)
	_player_spawner.spawn_player()
	RunInfo.arenanumber += 1
	
func _process(_delta: float) -> void:
	pass

func _on_timer_view_timeout() -> void:
	var ranks=["A", "B","C","D","E"]
	var rank=ranks[randi_range(0,len(ranks)-1)]
	MainUI.clear_all()
	if rank != "E":
		Global.goto_scene("res://RewardMenu/RewardMenu.tscn")
	else:
		Global.goto_scene("res://GameOverUI/game_over_ui.tscn")
