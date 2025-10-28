class_name SpawnComponent
extends Node2D

@export var spawner_group:String="spawners"

@export var enemy_group:String="enemy"

@export var time:float=2.5

@export var max_enemy_num:int

@export var arena_difficulty:int

@onready var _spawn_timer=$SpawnTimer

var difficulty_multiplier: float

var enemiesHealth: int

var enemiesSpeed: float

func _configure(current_max_enemy_num: int, current_arena_difficulty:int) -> void:
	self.arena_difficulty = current_arena_difficulty
	self.max_enemy_num = current_max_enemy_num
	_match_arena_difficulty()
	self.time = time / (1 + min(RunInfo.arenanumber * difficulty_multiplier, 300) / 100.0)
	_spawn_timer.wait_time=self.time

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
		var newHealth = (1.0 + (max(0, RunInfo.arenanumber - 1) * 1.2) / 100.0) * difficulty_multiplier
		var newSpeed = (1.0 + (max(0, RunInfo.arenanumber - 1) * 0.3) / 100.0) * difficulty_multiplier
		spawner.healthMult = newHealth
		spawner.speedMult = newSpeed
		spawner.call("_spawnEnemy")

# converts arena difficulty into its multiplier
func _match_arena_difficulty() -> void:
	match arena_difficulty:
		1:
			difficulty_multiplier = 1
		2:
			difficulty_multiplier = 1.5
		3:
			difficulty_multiplier = 2
		_:
			difficulty_multiplier = 1
