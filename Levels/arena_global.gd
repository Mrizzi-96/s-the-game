extends Node2D

var player_obj
var enemy_counter : int
var first_wave_spawned
var timer_started
@export var arena_waves : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerSpawner.spawn_player() 
	player_obj = $Player
	player_obj.connect("game_ended", _on_game_ended)
	Global.wave = 1
	Global.enemyNum = 0
	timer_started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.enemyNum <= 0 && first_wave_spawned && !timer_started:
		if Global.wave > arena_waves:
			Global.goto_scene("res://ArenaChoice/arena_choice.tscn")
		Global.wave += 1
		$Timer.start()
		timer_started = true

# First round of spawns
func _on_timer_timeout():
	get_tree().call_group("spawners", "_spawnEnemy")
	first_wave_spawned = true
	timer_started = false

func _on_game_ended():
	_show_game_over_UI()

func _show_game_over_UI():
	Global.goto_scene("res://GameOverUI/game_over_ui.tscn")
