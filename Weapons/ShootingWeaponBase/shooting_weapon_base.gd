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
	spawn_bullet()
	add_impulse_player()

func spawn_bullet() -> void:
	# start animation
	muzzle_animation.stop()
	muzzle_animation.play("default")
	var bullet = player_bullet.instantiate()
	bullet.position =$BulletSpawn.global_position
	bullet.rotation =$BulletSpawn.global_rotation 
	get_tree().root.add_child(bullet)
	AudioManager.create_2d_audio_at_location(self.global_position,SoundEffectSettings.SOUND_EFFECT_TYPE.ON_WEAPON_SHOOT)
	
func add_impulse_player() -> void:
	$"../../../..".apply_impulse(Vector2(-recoil_force, 0).rotated($"../..".global_rotation))
	#  ^Hips node										 				^Leg node
