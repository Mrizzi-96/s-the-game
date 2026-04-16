extends Sprite2D

@export var glow_color: Color = Color(1.0, 0.9, 0.3, 1.0)  # warm yellow
@export var glow_size: float = 48.0
@export var pulse: bool = true
@export var pulse_speed: float = 8.0
@export var pulse_amount: float = 0.15

const TEX_SIZE: int = 128
var _base_scale: Vector2

func _ready() -> void:
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 1))
	grad.set_color(1, Color(1, 1, 1, 0))
	grad.add_point(0.4, Color(1, 1, 1, 0.6))
	
	var gtex := GradientTexture2D.new()
	gtex.gradient = grad
	gtex.fill = GradientTexture2D.FILL_RADIAL
	gtex.fill_from = Vector2(0.5, 0.5)
	gtex.fill_to = Vector2(1.0, 0.5)
	gtex.width = TEX_SIZE
	gtex.height = TEX_SIZE
	texture = gtex
	
	modulate = glow_color
	show_behind_parent = true
	
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = mat
	
	var s := glow_size / float(TEX_SIZE)
	_base_scale = Vector2(s, s)
	scale = _base_scale

func _process(_delta: float) -> void:
	if pulse:
		var t := sin(Time.get_ticks_msec() / 1000.0 * pulse_speed)
		scale = _base_scale * (1.0 + t * pulse_amount)
