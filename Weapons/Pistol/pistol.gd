extends RigidBody2D

@export var player_bullet : PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(_event):
	if Input.is_action_just_pressed("act"):
		act()

func act():
	spawn_bullet()
	# TODO: add opposing force to player
	
func spawn_bullet():
	var bullet = player_bullet.instantiate()
	bullet.position =$BulletSpawn.global_position
	bullet.rotation =$BulletSpawn.global_rotation 
	get_tree().root.add_child(bullet)
