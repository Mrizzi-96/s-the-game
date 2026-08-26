extends ShootingWeapon

@export var shooting_angle = 30
@export var bullet_number = 8
@onready var shooting_cooldown = %ShootingCooldown
@onready var shotgun_vfx: ShotgunVFX = $ShotgunVfx
var _reload_timer : Timer
var can_shoot: bool = true

func _ready() -> void:
	_setup_reload_timer()

func _setup_reload_timer():
	_reload_timer = Timer.new()
	_reload_timer.one_shot = true
	# reload sound timer must start half a second early than the shooting cooldown
	_reload_timer.wait_time = shooting_cooldown.wait_time / 2
	_reload_timer.timeout.connect(_on_reload_timeout)
	# finally add to scene tree
	get_tree().root.add_child(_reload_timer)

func spawn_bullet() -> bool:
	if not can_shoot:
		return false

	var spawn_pos = $BulletSpawn.global_position

	# stesso muzzle per tutti i pallini: un solo check prima di sparare l'intera salva
	var probe = player_bullet.instantiate()
	var mask = probe.collision_mask
	probe.free()
	if _is_muzzle_blocked(spawn_pos, mask):
		_report_wall_blocked()
		return false

	can_shoot = false
	shooting_cooldown.start()
	_reload_timer.start()
	# sound blast
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_BIG_WEAPON_SHOOT)
	shotgun_vfx.start_vfx()
	for i in range(bullet_number): # Spawn bullets
		var bullet = player_bullet.instantiate()
		bullet.position = spawn_pos
		# Apply random rotation within the spread range
		bullet.rotation = $BulletSpawn.global_rotation + randf_range(-deg_to_rad(shooting_angle), deg_to_rad(shooting_angle))
		get_tree().root.add_child(bullet)
	return true

func _on_reload_timeout():
	AudioManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SHOTGUN_RELOAD)

func _on_shooting_cooldown_timeout():
	can_shoot= true
