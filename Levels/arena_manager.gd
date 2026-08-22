class_name ArenaManager
extends Node2D

@onready var _player_spawner = $Environment/PlayerSpawner

@export var max_enemy_num:int=10

@onready var _timer_view=$UI/HBoxContainer/TimerView

@onready var _spawn_component=$Components/SpawnComponent

@onready var _score_manager=$Components/ScoreManager
@onready var _pause_component: PauseComponent = $PauseComponent

@export var final_multiplier:float=10

var arena_difficulty: int = RunInfo.current_arena_params.difficulty

var is_preview := false

func _enter_tree() -> void:
	$ArenaNumberUi/ArenaNumberView.number=RunInfo.arena_counter

func _ready() -> void:
	max_enemy_num=arena_difficulty * 10
	if RunInfo.current_arena_params.is_final:
		max_enemy_num=max_enemy_num*arena_difficulty
	if is_preview:
		$UI/HBoxContainer.visible=false
		_pause_component.lock_input()
		return
	$UI/preview.queue_free()
	#_timer_view.start()
	_spawn_component.final_multiplier=final_multiplier
	_spawn_component._configure(max_enemy_num, arena_difficulty)
	_player_spawner.spawn_player()
	_score_manager.init(arena_difficulty)
	
func _process(_delta: float) -> void:
	pass

func _on_timer_view_timeout() -> void:
	var rank : RankItem.ScoreRank =_score_manager.get_rank()
	# save rank & arena score on current arena params
	RunInfo.current_arena_params.score_rank = rank
	RunInfo.current_arena_params.arena_score = _score_manager.get_arena_score()
	# clear main UI
	MainUI.clear_all()
	# clear all enemies and bullets
	await clear_all_enemies()
	await clear_all_bullets()
	if rank != ScoreManager.ScoreRank.E:
		if RunInfo.arena_counter>11:
			Global.goto_scene("res://EndGameUI/end_game_ui.tscn")
		else:
			Global.goto_scene("res://RewardMenu/RewardMenu.tscn")
	else:
		Global.goto_scene("res://GameOverUI/game_over_ui.tscn")

func clear_all_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.free()

func clear_all_bullets():
	var bullets = get_tree().get_nodes_in_group("bullets")
	for b in bullets:
		if is_instance_valid(b):
			b.free()


func _on_arena_number_view_start() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("enable_input"):
		player.enable_input(true)
	for node in get_tree().get_nodes_in_group("weapon"):
		node.enable_input(true)
	# unlock pause menu on game start
	_pause_component.unlock_input()
	_spawn_component.start_spawn()
	_timer_view.start()
