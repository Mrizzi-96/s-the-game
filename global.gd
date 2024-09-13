extends Node

var current_scene = null
var waves_left: int
var level_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() -1)
	level_path = "res://Levels/arena"

func _process(delta):
	# TODO: after wave completed, goto random scene
	if Input.is_key_pressed(KEY_SPACE):
		load_random_arena_scene()
		# TODO: bind not here, but in pause menu on button pressed
	if Input.is_key_pressed(KEY_Q):
		goto_scene("res://MainMenu/main_menu.tscn")

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func load_random_arena_scene():
	var rand = RandomNumberGenerator.new().randi_range(1,3)
	goto_scene(level_path + str(rand) + ".tscn")


func quit_game():
	get_tree().quit()
