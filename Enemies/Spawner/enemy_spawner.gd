extends Area2D

@export var enemyToSpawn: PackedScene
@export var waveNumber: int
var enemySpawned = false
	
func _spawnEnemy(currentWave: int, enemyCounter: int = 0):
	if currentWave == waveNumber && !enemySpawned:
		var enemy = enemyToSpawn.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.transform = $Marker2D.global_transform
		if enemy:
			enemySpawned =  true
			enemyCounter+=1
			
	print(enemyCounter)
	if enemySpawned:
		queue_free()
		print("spawner destroyed")
