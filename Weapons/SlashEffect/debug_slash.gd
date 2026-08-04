extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			play_all_slashes()

func play_all_slashes() -> void:
	for mesh in find_all_mesh_instances(self):
		var parent := mesh.get_parent()
		var anim_player := parent.get_node_or_null("AnimationPlayer") as AnimationPlayer
		if anim_player and anim_player.has_animation("Slash"):
			anim_player.play("Slash")

func find_all_mesh_instances(node: Node) -> Array[MeshInstance2D]:
	var result: Array[MeshInstance2D] = []
	for child in node.get_children():
		if child is MeshInstance2D:
			result.append(child)
		result.append_array(find_all_mesh_instances(child))
	return result
