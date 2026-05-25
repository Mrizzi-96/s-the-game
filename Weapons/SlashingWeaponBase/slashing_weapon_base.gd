extends RigidBody2D
class_name SlashingWeapon

@export var slash_strength = 5000
@export var item_data : ItemData
@export var max_charge_time : float = 1.0
@export var base_damage : int = 50
@export var max_damage : int = 150
@export var base_thrust : int = 5000
@export var max_thrust_impulse : int = 10000
@export var tap_threshold : float = 0.2  # secondi
@export_range(0.1, 1.0) var slow_mo_scale : float = 0.2  # quanto rallenta

@onready var attack_sfx = %AttackSfx

var _charge_timer : float = 0.0
var _is_charging : bool = false
var _current_damage : int = 50

func init():
	%WeaponSprite.texture = item_data.texture
	attack_sfx.stream = item_data.attack_sound

func _ready():
	init()

func _process(delta) -> void:
	if Global.active_leg == $"../..":
		if Input.is_action_just_pressed("act") or Input.is_action_just_pressed("switch"):
			_is_charging = true
			_charge_timer = 0.0

		if _is_charging:
			# delta è già scalato da Engine.time_scale, lo "descoliamo"
			var real_delta = delta / Engine.time_scale
			_charge_timer = min(_charge_timer + real_delta, max_charge_time)

			# attiva slow-mo solo dopo il tap threshold, così un tap veloce non rallenta nulla
			if _charge_timer > tap_threshold and Engine.time_scale == 1.0:
				Engine.time_scale = slow_mo_scale

		if Input.is_action_just_released("act") or Input.is_action_just_released("switch"):
			if _is_charging:
				_release_attack()
	else:
		if _is_charging:
			_cancel_charge()

func _release_attack() -> void:
	Engine.time_scale = 1.0  # ripristina PRIMA di tutto

	var charge_ratio : float
	if _charge_timer <= tap_threshold:
		charge_ratio = 0.0
	else:
		charge_ratio = _charge_timer / max_charge_time

	_current_damage = base_damage + int((max_damage - base_damage) * charge_ratio)
	var thrust = base_thrust + int((max_thrust_impulse - base_thrust) * charge_ratio)

	AudioManager.create_2d_audio_at_location(self.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SLASHING_WEAPON_EQUIP)
	$"../../../..".apply_impulse(Vector2(thrust, 0).rotated($"../..".global_rotation))

	_is_charging = false
	_charge_timer = 0.0

func _on_body_entered(body) -> void:
	if body.is_in_group("enemies"):
		body.get_parent()._hit(_current_damage)

func _cancel_charge() -> void:
	Engine.time_scale = 1.0
	_is_charging = false
	_charge_timer = 0.0
