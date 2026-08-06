extends ShootingWeapon

@export var shooting_angle = 30
@export var bullet_number = 8
@onready var shooting_cooldown = %ShootingCooldown
@onready var shotgun_vfx: ShotgunVFX = $ShotgunVfx
var can_shoot: bool = true


func spawn_bullet() -> bool:
	if not can_shoot:
		return false

	var spawn_pos = $BulletSpawn.global_position

	# stesso muzzle per tutti i pallini: un solo check prima di sparare l'intera salva
	var probe = player_bullet.instantiate()
	var mask = probe.collision_mask
	probe.free()
	if _is_muzzle_blocked(spawn_pos, mask):
		return false

	can_shoot = false
	shooting_cooldown.start()
	shotgun_vfx.start_vfx()
	for i in range(bullet_number): # Spawn bullets
		var bullet = player_bullet.instantiate()
		bullet.position = spawn_pos
		# Apply random rotation within the spread range
		bullet.rotation = $BulletSpawn.global_rotation + randf_range(-deg_to_rad(shooting_angle), deg_to_rad(shooting_angle))
		get_tree().root.add_child(bullet)
	return true


func _on_shooting_cooldown_timeout():
	can_shoot= true
