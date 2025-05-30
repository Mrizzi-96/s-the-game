extends Area2D

func get_nearest_collider_weapon():
	var nearest_collide = null
	var min_distance = INF
	var current_position = global_position
	for area in get_overlapping_areas():
		if area.is_in_group("LeftLeg") or area.is_in_group("RightLeg"):
			var distance = current_position.distance_to(area.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest_collide = area
	if nearest_collide:
		$"..".nearest_collider=nearest_collide


func get_nearest_collider_powerUP()->void:
	var nearest_collide = null
	var min_distance = INF
	var current_position = global_position
	for area in get_overlapping_areas():
		if area.is_in_group("grid"):
			var distance = current_position.distance_to(area.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest_collide = area
	if nearest_collide:
		$"..".nearest_collider=nearest_collide
