extends RigidBody2D

class_name ShootingWeapon

@export var player_bullet : PackedScene
@export var recoil_force = 2000
@export var item_data : ItemData
@onready var attack_sfx = %AttackSfx

func _ready():
	# set this item's sprite to item_data.texture
	%WeaponSprite.texture  = item_data.texture
	attack_sfx.stream = item_data.attack_sound
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if Global.active_leg == $"../..":  # Ensures only active weapon processes input
		if Input.is_action_just_pressed("act"):
			act()
		elif Input.is_action_just_pressed("switch"):
			act()

func act() -> void:
	spawn_bullet()
	add_impulse_player()

func spawn_bullet() -> void:
	var bullet = player_bullet.instantiate()
	bullet.position =$BulletSpawn.global_position
	bullet.rotation =$BulletSpawn.global_rotation 
	get_tree().root.add_child(bullet)
	attack_sfx.play()
	
func add_impulse_player() -> void:
	$"../../../..".apply_impulse(Vector2(-recoil_force, 0).rotated($"../..".global_rotation))
	#  ^Hips node										 				^Leg node
