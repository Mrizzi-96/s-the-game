extends Area2D
@onready var scene = get_parent()
@onready var player_scene = preload("res://Player/player.tscn")

func spawn_player():
	var player = player_scene.instantiate()
	print(scene.to_string())
	scene.add_child(player)
	player.transform = $Marker2D.global_transform
