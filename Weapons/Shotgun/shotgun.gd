extends ShootingWeapon

@export var shooting_angle = 30
@export var bullet_number = 8
@onready var shooting_cooldown = %ShootingCooldown
var can_shoot: bool = true

func spawn_bullet() -> void:
	if can_shoot:
		can_shoot = false
		shooting_cooldown.start()
		for i in range(bullet_number): # Spawn bullets
			var bullet = player_bullet.instantiate()
			bullet.position =$BulletSpawn.global_position
			# Apply random rotation within the spread range
			bullet.rotation = $BulletSpawn.global_rotation + randf_range(-deg_to_rad(shooting_angle), deg_to_rad(shooting_angle))
			get_tree().root.add_child(bullet)


func _on_shooting_cooldown_timeout():
	can_shoot= true
