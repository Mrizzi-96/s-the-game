extends SlashingWeapon

@export var acceleration_rate : float = 20000.0
@export var max_propeller_speed : float = 20000.0
@export var base_tick_damage : int = 50
@export var tick_interval : float = 0.3
@onready var _propeller_animator: AnimationPlayer = $PropellerAnimator
@onready var _propeller_vfx: PropellerVFX = $PropellerVfx

var _current_speed : float = 0.0
var _is_spinning : bool = false
var _tick_timer : float = 0.0
var _first_contact : Dictionary = {}
var _enemies_in_contact : Array = []

func _ready():
	item_data = ResourceLoader.load("res://Resources/Items/propeller.tres")
	super.init()

func _process(delta) -> void:
	if _block_input:
		return;
	if Global.active_leg == $"../..":
		if Input.is_action_just_pressed("act") or Input.is_action_just_pressed("switch"):
			_propeller_animator.play("MOVING")
			_propeller_vfx.start_bubbles()
			_is_spinning = true
			_current_speed = 0.0
			_tick_timer = 0.0
			_first_contact.clear()

		if _is_spinning:
			_current_speed = min(_current_speed + acceleration_rate * delta, max_propeller_speed)
			_tick_timer += delta
			var hips = $"../../../.."
			hips.apply_central_force(Vector2(_current_speed, 0).rotated($"../..".global_rotation))
			if _tick_timer >= tick_interval:
				_tick_timer = 0.0
				for enemy in _enemies_in_contact:
					if is_instance_valid(enemy):
						enemy.get_parent()._hit(base_tick_damage)

		if Input.is_action_just_released("act") or Input.is_action_just_released("switch"):
			_propeller_animator.play("IDLE")
			_propeller_vfx.stop_bubbles()
			_is_spinning = false
			_current_speed = 0.0
			_enemies_in_contact.clear()
	else:
		_is_spinning = false
		_current_speed = 0.0
		_enemies_in_contact.clear()

func _on_body_entered(body) -> void:
	if body.is_in_group("enemies") and _is_spinning:
		body.get_parent()._hit(base_tick_damage + int(_current_speed))
		_enemies_in_contact.append(body)

func _on_body_exited(body) -> void:
	_enemies_in_contact.erase(body)
