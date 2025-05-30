extends RigidBody2D

class_name SlashingWeapon

@export var slash_strength = 5000
@export var item_data : ItemData
@onready var attack_sfx = %AttackSfx

func init():
	# set this item's sprite to item_data.texture
	%WeaponSprite.texture  = item_data.texture
	attack_sfx.stream = item_data.attack_sound
	
func _ready():
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if Global.active_leg == $"../..":  # Ensures only active weapon processes input
		if Input.is_action_just_pressed("act"):
			act()
		elif Input.is_action_just_pressed("switch"):
			act()

func act() -> void:
	add_impulse_player()

func add_impulse_player():
	AudioManager.create_2d_audio_at_location(self.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SLASHING_WEAPON_EQUIP)
	$"../../../..".apply_impulse(Vector2(slash_strength, 0).rotated($"../..".global_rotation))

func _on_body_entered(body) -> void:
	if body.is_in_group("enemies"):
		body.get_parent()._hit(100)
