extends Area2D

@export var enemyToSpawn: PackedScene
@export var waveNumber: int
var enemySpawned = false
	
func _spawnEnemy():
	if Global.wave == waveNumber && !enemySpawned:
		var enemy = enemyToSpawn.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.transform = $Marker2D.global_transform
		if enemy:
			enemySpawned =  true
			Global.enemyNum+=1
			
	if enemySpawned:
		queue_free()
