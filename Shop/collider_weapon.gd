extends Area2D

var disabled_colliders = []  # Memorizza i collider disattivati
#@onready var leftleg=%WeaponPreviewLeft
#@onready var rightleg=%WeaponPreviewRight

func disable_colliders(creator):
	disabled_colliders.clear()  # Puliamo la lista prima di aggiungere nuovi collider
	for area in get_overlapping_areas():
		if area.is_in_group("LeftLeg"):
			var collider = area.get_node("CollisionShape2D")
			print("Area rilevata:", area.name)
			if collider:
				#leftleg.visible=false
				creator.equip_left()
				#collider.visible=false  # Disattiva il collider
				collider.set_deferred("disabled", true)
				disabled_colliders.append(collider)  # Salva il collider disattivato
		elif area.is_in_group("RightLeg"):
			var collider = area.get_node("CollisionShape2D")
			print("Area rilevata:", area.name)
			if collider:
				#rightleg.visible=false
				creator.equip_right()
				#collider.visible=false  # Disattiva il collider
				collider.set_deferred("disabled", true)
				disabled_colliders.append(collider)  # Salva il collider disattivato

func enable_colliders():
	for collider in disabled_colliders:
		if collider:
			#collider.visible=true # Riattiva il collider
			collider.set_deferred("disabled", false)
	disabled_colliders.clear()  # Svuota la lista dopo la riattivazione
