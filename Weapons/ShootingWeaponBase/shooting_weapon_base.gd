extends RigidBody2D

class_name ShootingWeapon

@export var player_bullet : PackedScene
@export var recoil_force = 2000
@export var item_data : ItemData
@onready var attack_sfx = %AttackSfx
@onready var muzzle_animation: AnimatedSprite2D = %MuzzleAnimation

var _block_input:bool=true

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
	if spawn_bullet():
		add_impulse_player()

func spawn_bullet() -> bool:
	var bullet = player_bullet.instantiate()
	var spawn_pos = $BulletSpawn.global_position
	bullet.position = spawn_pos
	bullet.rotation = $BulletSpawn.global_rotation

	if _is_muzzle_blocked(spawn_pos, bullet.collision_mask):
		bullet.free()
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
	
func add_impulse_player() -> void:
	$"../../../..".apply_impulse(Vector2(-recoil_force, 0).rotated($"../..".global_rotation))
	#  ^Hips node										 				^Leg node
