extends RigidBody2D
class_name SlashingWeapon

@export var slash_strength = 5000
@export var item_data : ItemData
@export var max_charge_time : float = 1.0
@export var base_damage : int = 50
@export var max_damage : int = 150
@export var base_thrust : int = 5000
@export var max_thrust_impulse : int = 15000
@export var tap_threshold : float = 0.2  # secondi
@export_range(0.1, 1.0) var slow_mo_scale : float = 0.2  # quanto rallenta
@export_range(0.0, 1.0) var velocity_override : float = 0.9 # quanto il charge attack ignora la velocità corrente
@export var charge_textures : Array[Texture2D] = []
@export var quick_charge_threshold : float = 0.33
@export var slow_charge_threshold : float = 0.66
@export var charge_sprite_fadeout : float = 0.7
@export var wind_lines_duration : float = 0.7


@onready var attack_sfx = %AttackSfx
@onready var _charge_sprite = $ChargeSprite
@onready var _wind_lines = $WindLines

var _charge_timer : float = 0.0
var _is_charging : bool = false
var _current_damage : int = 50
var _charge_tween : Tween

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
			var real_delta = delta / Engine.time_scale
			_charge_timer = min(_charge_timer + real_delta, max_charge_time)
			var charge_ratio = _charge_timer / max_charge_time

			if _charge_timer > tap_threshold and Engine.time_scale == 1.0:
				Engine.time_scale = slow_mo_scale

		if Input.is_action_just_released("act") or Input.is_action_just_released("switch"):
			if _is_charging:
				_release_attack()
	else:
		if _is_charging:
			_cancel_charge()

func _release_attack() -> void:
	Engine.time_scale = 1.0

	var charge_ratio : float
	if _charge_timer <= tap_threshold:
		charge_ratio = 0.0
	else:
		charge_ratio = _charge_timer / max_charge_time

	_current_damage = base_damage + int((max_damage - base_damage) * charge_ratio)
	var thrust = base_thrust + int((max_thrust_impulse - base_thrust) * charge_ratio)

	var hips = $"../../../.."
	hips.linear_velocity = hips.linear_velocity * (1.0 - charge_ratio * velocity_override)

	AudioManager.create_2d_audio_at_location(self.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_SLASHING_WEAPON_EQUIP)
	hips.apply_impulse(Vector2(thrust, 0).rotated($"../..".global_rotation))


	if charge_ratio > tap_threshold / max_charge_time:
		_wind_lines.emitting = true
		get_tree().create_timer(wind_lines_duration).timeout.connect(func(): _wind_lines.emitting = false)
		_charge_sprite.visible = true
		if charge_ratio < quick_charge_threshold:
			_charge_sprite.texture = charge_textures[0]
		elif charge_ratio < slow_charge_threshold:
			_charge_sprite.texture = charge_textures[1]
		else:
			_charge_sprite.texture = charge_textures[2]
	_fade_out_indicator(charge_sprite_fadeout)

	_is_charging = false
	_charge_timer = 0.0

func _on_body_entered(body) -> void:
	if body.is_in_group("enemies"):
		body.get_parent()._hit(_current_damage)

func _cancel_charge() -> void:
	Engine.time_scale = 1.0
	_is_charging = false
	_charge_timer = 0.0

func _fade_out_indicator(linger_time : float = 0.7) -> void:
	if _charge_tween:
		_charge_tween.kill()
	_charge_tween = create_tween()
	_charge_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_charge_tween.tween_interval(linger_time)
	_charge_tween.tween_property(_charge_sprite, "modulate:a", 0.0, 0.3)
	_charge_tween.tween_callback(func():
		_charge_sprite.visible = false
		_charge_sprite.modulate.a = 1.0
	)
