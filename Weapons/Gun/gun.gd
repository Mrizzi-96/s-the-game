extends ShootingWeapon

func spawn_bullet() -> void:
	var bullet = player_bullet.instantiate()
	bullet.position =$BulletSpawn.global_position
	bullet.rotation =$BulletSpawn.global_rotation 
	get_tree().root.add_child(bullet)
