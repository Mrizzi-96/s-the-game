extends Button

var difficulty=0
var arena_path=""
var can_interact := true
var timer
var is_active=false

func select_path(number :String):
	arena_path="res://Levels/arena"+number+".tscn"
	load_arena_preview(arena_path)
	print(arena_path)

func load_arena_preview(scene_path: String):
	var packed_scene = load(scene_path)
	if packed_scene:
		var instance = packed_scene.instantiate()
		instance.is_preview = true
		$"../BgArena2/SubViewportContainer/SubViewport".add_child(instance)

func _on_mouse_entered():
	$"../BgArena2".scale = Vector2(0.8, 0.8)

func _on_mouse_exited():
	$"../BgArena2".scale = Vector2(1, 1)
