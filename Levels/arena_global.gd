extends Node2D

var one_time_only = false
var wave_enemies : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	wave_enemies = [load("res://Enemies/enemy_base.tscn")]
	# TODO: attach this code to every single Arena
	# TODO: instantiate the spawners (and their enemies) accordingly
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_0) && !one_time_only:
		one_time_only = true
		$enemySpawner.enemyToSpawn = wave_enemies[0]
		$enemySpawner._spawnEnemy(1, 1)
