extends CanvasLayer

const IndicatorScene = preload("res://Enemies/enemy_indicator.tscn")

var offscreen_enemies: Dictionary = {}
var margin: float = 40.0

func _process(_delta: float) -> void:
	var screen_rect: Rect2 = get_viewport().get_visible_rect()
	var canvas_transform: Transform2D = get_viewport().get_canvas_transform()
	var screen_center: Vector2 = screen_rect.size * 0.5
	var bounds_half_size: Vector2 = screen_center - Vector2(margin, margin)

	for enemy_root in offscreen_enemies.keys():
		# Safety check
		if not is_instance_valid(enemy_root):
			unregister_on_screen_enemy(enemy_root)
			continue

		var indicator: Control = offscreen_enemies[enemy_root]
		
		#Get enemy moving node
		var enemy: Node2D = enemy_root.get_node_or_null("RigidBody2D")
		if enemy == null:
			continue

		var enemy_screen_pos: Vector2 = canvas_transform * enemy.global_position
		
		# Indicator visibility
		var display_rect: Rect2 = screen_rect.grow(-margin)
		indicator.visible = not display_rect.has_point(enemy_screen_pos)

		if indicator.visible:
			var vec_to_enemy: Vector2 = enemy_screen_pos - screen_center
			indicator.rotation = vec_to_enemy.angle()

			var scale_x: float = bounds_half_size.x / abs(vec_to_enemy.x) if vec_to_enemy.x != 0.0 else INF
			var scale_y: float = bounds_half_size.y / abs(vec_to_enemy.y) if vec_to_enemy.y != 0.0 else INF
			var scale: float = min(scale_x, scale_y)

			indicator.position = screen_center + vec_to_enemy * scale

func register_on_screen_enemy(enemy_root: Node) -> void:
	if enemy_root in offscreen_enemies:
		return
	
	var indicator_instance: Control = IndicatorScene.instantiate()
	add_child(indicator_instance)
	offscreen_enemies[enemy_root] = indicator_instance

func unregister_on_screen_enemy(enemy_root: Node) -> void:
	if offscreen_enemies.has(enemy_root):
		offscreen_enemies[enemy_root].queue_free()
		offscreen_enemies.erase(enemy_root)
