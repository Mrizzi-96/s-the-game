extends Node

@onready var font = load("res://UI/Fonts/Bungee-Regular.ttf")

func display_damage(damage: int, position: Vector2):
	#Number label setup
	var number = Label.new()
	number.global_position = position
	number.text = str(damage)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	number.label_settings.font_color = "#c80000"
	number.label_settings.font_size = 24
	number.label_settings.font = font
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 10
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	number.modulate.a = 1
	#Randomize values
	var scale = Vector2.ONE
	scale = Vector2(randf_range(0.9, 1.2), randf_range(0.9, 1.2))
	
	var base_scale = randf_range(0.95, 1.15)
	number.scale = Vector2(base_scale, base_scale)
	var move_x = randf_range(-32, 32)
	var move_y = randf_range(-58, -32)
	var end_pos = number.position + Vector2(move_x, move_y)
	var end_rot = randf_range(-0.5, 0.5)
	var target_scale = randf_range(0.6, 0.9)
	var pop_time = randf_range(0.3, 0.5)
	var fade_delay = randf_range(0.28, 0.44)

	#Tween animation
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(number, "position", end_pos, pop_time).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "modulate:a", 0, pop_time * 1.1).set_delay(fade_delay)
	tween.tween_property(number, "scale", Vector2(target_scale, target_scale), pop_time)
	tween.tween_property(number, "rotation", end_rot, pop_time)
	await tween.finished
	number.queue_free()
