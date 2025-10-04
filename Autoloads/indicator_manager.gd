extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")

var IndicatorScene = preload("res://Enemies/enemy_indicator.tscn")
var offscreen_enemies = {}
var margin = 40.0 

func _ready():
	pass

func _process(delta):
	# Get screen boundaries
	var screen_rect = get_viewport().get_visible_rect()
	var screen_center = screen_rect.size / 2

	var canvas_transform = get_viewport().get_canvas_transform()
	for enemy in offscreen_enemies:
		var indicator = offscreen_enemies[enemy]
		var enemy_screen_pos = canvas_transform * enemy.global_position

		# Check if enemy is on-screen
		if screen_rect.has_point(enemy_screen_pos):
			indicator.visible = false
		else:
			indicator.visible = true

			# Calculate position and rotation
			var direction = screen_center.direction_to(enemy_screen_pos)
			indicator.rotation = direction.angle()

			# Block the indicator to the screen border
			var clamped_pos_x = clamp(enemy_screen_pos.x, margin, screen_rect.size.x - margin)
			var clamped_pos_y = clamp(enemy_screen_pos.y, margin, screen_rect.size.y - margin)
			indicator.global_position = Vector2(clamped_pos_x, clamped_pos_y)

func register_on_screen_enemy(enemy):
	var indicator_instance = IndicatorScene.instantiate()
	add_child(indicator_instance)
	offscreen_enemies[enemy] = indicator_instance

func unregister_on_screen_enemy(enemy):
	if offscreen_enemies.has(enemy):
		offscreen_enemies[enemy].queue_free()
		offscreen_enemies.erase(enemy)
