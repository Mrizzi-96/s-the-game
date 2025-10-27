class_name SpawnComponent
extends Node2D

@export var spawner_group:String="spawners"

@export var enemy_group:String="enemy"

@export var time:float=2.5

@export var max_enemy_num:int

@export var arena_difficulty:int

@onready var _spawn_timer=$SpawnTimer

func _configure(current_max_enemy_num: int, current_arena_difficulty:int) -> void:
	self.arena_difficulty = current_arena_difficulty
	self.max_enemy_num = current_max_enemy_num
	self.time = time / (1 + min(RunInfo.arenanumber * arena_difficulty, 300) / 100.0)
	_spawn_timer.wait_time=self.time
	print(time)
	print(RunInfo.arenanumber)
	print(arena_difficulty)

func _on_first_spawn_timer_timeout() -> void:
	for i in max_enemy_num:
		_spawn_enemy()
	_spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var enemies=get_tree().get_nodes_in_group(enemy_group)
	if len(enemies) < max_enemy_num:
		_spawn_enemy()
	_spawn_timer.start()

func _spawn_enemy():
	var enemy_spawners=get_tree().get_nodes_in_group(spawner_group)
	var num=randi_range(0,len(enemy_spawners)-1)
	if num >=0 and len(enemy_spawners)>num:
		var spawner=enemy_spawners[num]
		spawner.call("_spawnEnemy")
