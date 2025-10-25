extends Area2D

@export var enemyToSpawn: PackedScene
var enemySpawned = false
	
func _spawnEnemy():
	var enemy = enemyToSpawn.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.transform = $Marker2D.global_transform
	if enemy:
		enemySpawned =  true
		Global.enemyNum+=1
			
	if enemySpawned:
		queue_free()
