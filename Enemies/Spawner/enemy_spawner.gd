extends Area2D

@export var enemyToSpawn: PackedScene
var enemySpawned = false
var speedMult: float = 1.0
var healthMult: float = 1.0

func _spawnEnemy():
	var enemy = enemyToSpawn.instantiate()
	enemy._setSpeed(enemy._getSpeed() * speedMult)
	enemy._setHealth(round(enemy._getHealth() * healthMult))
	get_tree().current_scene.add_child(enemy)
	enemy.transform = $Marker2D.global_transform
	if enemy:
		enemySpawned =  true
		Global.enemyNum+=1
			
	if enemySpawned:
		queue_free()
