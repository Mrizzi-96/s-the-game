extends Area2D

#func get_nearest_collider():
	#var colliders = get_overlapping_areas()
	#if colliders.size() > 0:
		#%PickUP.nearest_collider= colliders[0]  # Prendi il primo collider trovato
	#return null

func get_nearest_collider_center()->void:
	var nearest_collide = null
	var min_distance = INF
	var current_position = global_position
	for area in get_overlapping_areas():
		var distance = current_position.distance_to(area.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest_collide = area
	if nearest_collide:
		$"..".nearest_collider=nearest_collide
