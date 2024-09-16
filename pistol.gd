extends RigidBody2D

@export var player_bullet : PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if Input.is_action_just_pressed("act"):
		pistol_shoot()
	#move_and_slide()

func pistol_shoot():
	var bullet = player_bullet.instantiate()
	bullet.position =$BulletSpawn.global_position
	bullet.rotation =$BulletSpawn.global_rotation 
	var level_node = get_level_node()
	if level_node:
		level_node.add_child(bullet)
	else:
		print("Level node not found")
	# Calcola la direzione opposta
	var direction = Vector2(cos($BulletSpawn.global_rotation), sin($BulletSpawn.global_rotation)).normalized() * -1
	var force = direction * 100  # Modifica il valore della forza secondo necessità

	# Applica la forza al player
	apply_impulse(Vector2(), force)

func get_level_node():
	var node = self
	while node and not node.is_in_group("Level"):
		node = node.get_parent()
	return node
