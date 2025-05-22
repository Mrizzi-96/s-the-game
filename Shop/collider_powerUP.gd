extends Area2D

var disabled_colliders = []  # Memorizza i collider disattivati

func disable_colliders():
	disabled_colliders.clear()  # Puliamo la lista prima di aggiungere nuovi collider
	for area in get_overlapping_areas():
		if area.is_in_group("grid"):
			var collider = area.get_node("CollisionShape2D")
			print("Area rilevata:", area.name)
			if collider:
				collider.visible=false  # Disattiva il collider
				disabled_colliders.append(collider)  # Salva il collider disattivato

func enable_colliders():
	for collider in disabled_colliders:
		if collider:
			collider.visible=true # Riattiva il collider
	disabled_colliders.clear()  # Svuota la lista dopo la riattivazione
