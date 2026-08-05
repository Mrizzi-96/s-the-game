extends Line2D

@export var trail_length: int = 12
@export var trail_color: Color = Color(1.0, 0.95, 0.3, 1.0)  # punchy yellow
@export var trail_width: float = 4.0

var points_history: Array[Vector2] = []

func _ready() -> void:
	top_level = true
	global_position = Vector2.ZERO
	
	default_color = trail_color
	width = trail_width
	
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.0))
	curve.add_point(Vector2(1.0, 1.0))
	width_curve = curve
	
	#var grad := Gradient.new()
	#grad.set_color(0, Color(trail_color.r, trail_color.g, trail_color.b, 0.0))
	#grad.set_color(1, trail_color)
	#gradient = grad
	
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = mat

func _physics_process(_delta: float) -> void:
	var parent := get_parent() as Node2D
	if parent == null:
		return
	points_history.append(parent.global_position)
	if points_history.size() > trail_length:
		points_history.pop_front()
	
	clear_points()
	for p in points_history:
		add_point(p)
