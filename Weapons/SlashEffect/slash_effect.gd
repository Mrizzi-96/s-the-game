extends Node2D

enum State { IDLE, HOLDING, PLAYING }

@export var weak_swing_start_fraction : float = 0.85  # dove parte l'animazione per uno swing debole (0=inizio, 1=fine)

@onready var _mesh: MeshInstance2D = $MeshInstance2D
@onready var _anim_player: AnimationPlayer = $AnimationPlayer

var _base_rotation : float
var _base_scale : Vector2
var _anim_length : float

var _state : State = State.IDLE
var _held_clockwise : bool = true

func _ready() -> void:
	visible = false
	_base_rotation = _mesh.rotation
	_base_scale = _mesh.scale
	_anim_length = _anim_player.get_animation(&"Slash").length
	_anim_player.animation_finished.connect(_on_animation_finished)

func update_swing(angular_speed: float, clockwise: bool, min_threshold: float, sustain_threshold: float) -> void:
	if angular_speed >= sustain_threshold:
		_hold(clockwise)
	elif _state == State.HOLDING:
		# il giocatore ha rallentato sotto la soglia di sostegno: rilascia l'animazione intera
		_start(clockwise, 0.0)
	elif angular_speed >= min_threshold and (_state == State.IDLE or clockwise != _held_clockwise):
		var t := clampf(inverse_lerp(min_threshold, sustain_threshold, angular_speed), 0.0, 1.0)
		var start_time := lerpf(_anim_length * weak_swing_start_fraction, 0.0, t)
		_start(clockwise, start_time)

func _hold(clockwise: bool) -> void:
	_apply_orientation(clockwise)
	_anim_player.stop()
	_anim_player.seek(0.0, true)
	visible = true
	_state = State.HOLDING
	_held_clockwise = clockwise

func _start(clockwise: bool, start_time: float) -> void:
	_apply_orientation(clockwise)
	visible = true
	_anim_player.play(&"Slash", -1, 2.0)
	_anim_player.seek(start_time, true)
	_state = State.PLAYING
	_held_clockwise = clockwise

func _apply_orientation(clockwise: bool) -> void:
	if clockwise:
		_mesh.rotation = _base_rotation
		_mesh.scale = _base_scale
	else:
		_mesh.rotation = _base_rotation + PI
		_mesh.scale = Vector2(-_base_scale.x, _base_scale.y)

func _on_animation_finished(_anim_name: StringName) -> void:
	visible = false
	_state = State.IDLE
