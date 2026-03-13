class_name VisionCone2D
extends Sensor2D

@export var max_length: float = 300.0
@export var max_angle: float = 90.0


func detect() -> Node2D:
	if _candidates.is_empty():
		return null

	var best_target: Node2D = null
	var best_dist := INF

	for target in _candidates.keys():
		if not is_instance_valid(target):
			_candidates.erase(target)
			continue

		if not check_visibility(target):
			continue

		var d := global_position.distance_squared_to(target.global_position)
		if d < best_dist:
			best_dist = d
			best_target = target

	return best_target


func check_visibility(target: Node2D) -> bool:
	# Distance check
	if global_position.distance_to(target.global_position) > max_length:
		return false

	# Angle check
	var dir := (target.global_position - global_position).normalized()
	var forward := Vector2.RIGHT.rotated(rotation)
	var angle = abs(rad_to_deg(forward.angle_to(dir)))

	if angle > max_angle * 0.5:
		return false

	# Occlusion check
	var space := get_world_2d().direct_space_state
	var params := PhysicsRayQueryParameters2D.create(
		global_position,
		target.global_position
	)
	params.exclude = [self]
	params.collision_mask = occlusion_mask

	return space.intersect_ray(params).is_empty()


func _draw() -> void:
	var steps := 24
	var half_angle := deg_to_rad(max_angle * 0.5)

	var points := PackedVector2Array()
	points.append(Vector2.ZERO)

	for i in range(steps + 1):
		var t := float(i) / steps
		var angle = lerp(-half_angle, half_angle, t)
		var dir := Vector2.RIGHT.rotated(angle)
		points.append(dir * max_length)

	var color := Color(1, 0, 0, 0.75)
	if _last_detected != null:
		color = Color(0, 1, 0, 0.75)

	draw_colored_polygon(points, color)
