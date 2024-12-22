extends RigidBody2D

class_name ShootingWeapon

@export var player_bullet : PackedScene
@export var recoil_force = 2000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("act") && Global.active_leg.name == "RightLeg":
		act()

func act() -> void:
	spawn_bullet()
	add_impulse_player()

func spawn_bullet() -> void:
	var bullet = player_bullet.instantiate()
	bullet.position =$BulletSpawn.global_position
	bullet.rotation =$BulletSpawn.global_rotation 
	get_tree().root.add_child(bullet)
	
func add_impulse_player() -> void:
	$"../../../..".apply_impulse(Vector2(-recoil_force, 0).rotated($"../..".global_rotation))
	#  ^Hips node										 		  ^RightLeg node
