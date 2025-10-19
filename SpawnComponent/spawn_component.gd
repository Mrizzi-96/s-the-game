class_name SpawnComponent
extends Node2D

@export var spawner_group:String="spawners"

@export var enemy_group:String="enemy"

@export var time:float=2.5

@export var max_enemy_num:int=10

@onready var _spawn_timer=$SpawnTimer

func _ready() -> void:
	_spawn_timer.wait_time=time

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
	var spawner=enemy_spawners[num]
	spawner.call("_spawnEnemy")
