extends Camera2D

# Max pixel offset at full trauma
@export var max_offset: float = 30.0
# Max rotation in radians at full trauma
@export var max_rotation: float = 0.5
# How quickly trauma decays per second
@export var trauma_decay: float = 4.0
# Noise movement speed — higher = more frantic
@export var noise_speed: float = 50.0
@export var minimum_shake: float = 0.5
# How fast diminishing kicks in
@export var fatigue_per_shake: float = 0.6
# How quickly fatigue recovers per second (higher = faster return to full strength)
@export var fatigue_decay: float = 2.0

# Enable directional recoil (camera kicks opposite to aim direction)
@export var directional: bool = true
# How much the direction biases the shake (0.0 = pure noise, 1.0 = fully directional)
@export_range(0.0, 1.0) var directional_bias: float = 0.6

var _trauma: float = 0.0
var _fatigue: float = 0.0
var _noise: FastNoiseLite
var _noise_t: float = 0.0
var _recoil_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	_noise = FastNoiseLite.new()
	_noise.seed = randi()
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	_noise.frequency = 0.5

func _process(delta: float) -> void:
	# Full shake restoring
	_fatigue = maxf(_fatigue - fatigue_decay * delta, 0.0)

	if _trauma <= 0.0:
		offset = Vector2.ZERO
		rotation = 0.0
		return

	_noise_t += delta * noise_speed
	var intensity: float = _trauma * _trauma

	var noise_offset := Vector2(
		_noise.get_noise_2d(_noise_t, 0.0),
		_noise.get_noise_2d(0.0, _noise_t)
	)

	if directional and _recoil_dir != Vector2.ZERO:
		var dir_offset: Vector2 = _recoil_dir * noise_offset.length()
		offset = max_offset * intensity * noise_offset.lerp(dir_offset, directional_bias)
	else:
		offset = max_offset * intensity * noise_offset

	rotation = max_rotation * intensity * _noise.get_noise_2d(_noise_t, _noise_t)

	_trauma = maxf(_trauma - trauma_decay * delta, 0.0)

# amount: base trauma to add (0.0 to 1.0). Gets reduced by current fatigue.
# First shot in a burst gets full value, rapid follow-ups deminishes it.
# direction: optional aim direction. When directional is ON, camera recoils opposite to this.
func shake(amount: float, direction: Vector2 = Vector2.ZERO) -> void:
	# Diminishing returns: effective amount shrinks with fatigue
	var effective: float = amount / (1.0 + _fatigue)
	effective = maxf(effective, amount * minimum_shake)
	_trauma = clampf(_trauma + effective, 0.0, 1.0)
	_fatigue += fatigue_per_shake

	if direction != Vector2.ZERO:
		_recoil_dir = -direction.normalized()
