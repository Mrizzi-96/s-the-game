extends RigidBody2D

class_name ShootingWeapon

const FART_VFX_SCENES : Array[PackedScene] = [
	preload("res://Player/Vfx/fart_vfx_1.tscn"),
	preload("res://Player/Vfx/fart_vfx_2.tscn"),
	preload("res://Player/Vfx/fart_vfx_3.tscn"),
]
const FART_VFX_MAX_LIFETIME : float = 7.0  # copre anche il caso più lungo (vfx1 + Fly + trail)
const FART_VFX_SIZE_MULTIPLIER : float = 1.5

@export var player_bullet : PackedScene
@export var recoil_force = 2000
@export var item_data : ItemData
@onready var attack_sfx = %AttackSfx
@onready var muzzle_animation: AnimatedSprite2D = %MuzzleAnimation

var _block_input:bool=true
var _shot_blocked_by_wall: bool = false

func enable_input(value:bool):
	_block_input=not value

func _ready():
	# set this item's sprite to item_data.texture
	%WeaponSprite.texture  = item_data.texture
	attack_sfx.stream = item_data.attack_sound
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if _block_input:
		return
	if Global.active_leg == $"../..":  # Ensures only active weapon processes input
		if Input.is_action_just_pressed("act"):
			act()
		elif Input.is_action_just_pressed("switch"):
			act()

func act() -> void:
	_shot_blocked_by_wall = false
	if spawn_bullet():
		add_impulse_player()
	elif _shot_blocked_by_wall:
		# il rinculo del grilletto c'è comunque, anche se non parte nessun proiettile
		add_impulse_player()

func spawn_bullet() -> bool:
	var bullet = player_bullet.instantiate()
	var spawn_pos = $BulletSpawn.global_position
	bullet.position = spawn_pos
	bullet.rotation = $BulletSpawn.global_rotation

	if _is_muzzle_blocked(spawn_pos, bullet.collision_mask):
		bullet.free()
		_report_wall_blocked()
		return false

	# start animation
	muzzle_animation.stop()
	muzzle_animation.play("default")
	get_tree().root.add_child(bullet)
	AudioManager.create_2d_audio_at_location(self.global_position,SoundEffectSettings.SOUND_EFFECT_TYPE.ON_WEAPON_SHOOT)
	return true

# condiviso con le sottoclassi (es. Shotgun) che spawnano proiettili con la loro logica:
# vero se un muro impedisce di sparare dal punto di spawn indicato
func _is_muzzle_blocked(spawn_pos: Vector2, mask: int) -> bool:
	var leg = $"../.."
	var hips = $"../../../.."
	var space_state = get_world_2d().direct_space_state

	# un raycast NON rileva un muro se parte già al suo interno (es. la gamba è stata
	# spinta dentro un muro da un contraccolpo): controlliamo esplicitamente entrambi
	# gli estremi, oltre al percorso, per non lasciare buchi
	if _point_in_wall(space_state, leg.global_position, mask, hips) \
			or _point_in_wall(space_state, spawn_pos, mask, hips):
		return true

	# la gamba estesa può spingere la canna oltre un muro sottile: se il percorso dalla gamba
	# alla canna attraversa un muro, non si spara (un semplice check sul punto di spawn non
	# basterebbe, perché la canna potrebbe già trovarsi dall'altra parte del muro)
	var query = PhysicsRayQueryParameters2D.create(leg.global_position, spawn_pos)
	query.collision_mask = mask
	query.collide_with_areas = false
	query.exclude = [hips.get_rid()]
	return not space_state.intersect_ray(query).is_empty()

func _point_in_wall(space_state: PhysicsDirectSpaceState2D, point: Vector2, mask: int, exclude_body: Node2D) -> bool:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collision_mask = mask
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = [exclude_body.get_rid()]
	return not space_state.intersect_point(query).is_empty()

# feedback per il giocatore quando il colpo viene bloccato da un muro: usato anche
# dalle sottoclassi (es. Shotgun) che spawnano i proiettili con logica propria
func _report_wall_blocked() -> void:
	_shot_blocked_by_wall = true
	AudioManager.create_2d_audio_at_location(
		self.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SHOT_BLOCKED
	)
	_spawn_random_fart_vfx()

func _spawn_random_fart_vfx() -> void:
	var vfx = FART_VFX_SCENES[randi() % FART_VFX_SCENES.size()].instantiate()
	# posizione dall'anca (Hips), ma l'orientamento da Cheeks: Cheeks rappresenta dove il
	# player "punta in basso" (AssSprite ha una sua rotazione locale, diversa da quella di Hips)
	var hips = $"../../../.."
	var cheeks = $"../../../AssSprite/Cheeks"
	vfx.global_position = hips.global_position
	vfx.global_rotation = cheeks.global_rotation
	# la dimensione delle particelle (material) e lo spazio di simulazione (node scale, che
	# sposta anche quanto viaggiano lontano) sono due cose separate: vanno scalate entrambe
	# per ingrandire l'effetto in modo uniforme
	vfx.scale *= FART_VFX_SIZE_MULTIPLIER
	_scale_particle_size(vfx, FART_VFX_SIZE_MULTIPLIER)
	vfx.z_index = 100  # sopra a tutti gli elementi di gioco (player/muri usano z_index 0-5)
	get_tree().root.add_child(vfx)
	get_tree().create_timer(FART_VFX_MAX_LIFETIME).timeout.connect(vfx.queue_free)

# scalare il node stesso sposta solo lo spazio di simulazione (le particelle vanno più
# lontano), non la dimensione con cui vengono disegnate: quella dipende dal
# ParticleProcessMaterial, quindi va duplicato (è condiviso dalla scena) e scalato lì,
# per ogni GPUParticles2D nell'albero (compreso il sotto-emettitore Fly di fart_vfx_1)
func _scale_particle_size(node: Node, multiplier: float) -> void:
	if node is GPUParticles2D and node.process_material is ParticleProcessMaterial:
		var mat : ParticleProcessMaterial = node.process_material.duplicate()
		mat.scale_min *= multiplier
		mat.scale_max *= multiplier
		node.process_material = mat
	for child in node.get_children():
		_scale_particle_size(child, multiplier)

func add_impulse_player() -> void:
	$"../../../..".apply_impulse(Vector2(-recoil_force, 0).rotated($"../..".global_rotation))
	#  ^Hips node										 				^Leg node
