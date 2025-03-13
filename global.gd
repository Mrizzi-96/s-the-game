extends Node

var current_scene = null
var wave: int
var level_path: String
var enemyNum: int
var active_leg
var right_weapon
var left_weapon
var weapons = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() -1)
	level_path = "res://Levels/arena"
	
	var weapon_dir = "res://Weapons/"
	scan_directory(weapon_dir)
	#print(weapons)  # Debug: Check the generated dictionary

func _process(_delta):
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

#Weapon dictonary automatic generation
func scan_directory(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				var entry_path = path + file_name
				if dir.current_is_dir():
					if file_name != "Assets" and file_name != "Bullet":
						scan_directory(entry_path + "/")
				else:
					if file_name.ends_with(".tscn"): 
						var weapon_name = file_name.get_basename()
						weapons[weapon_name] = entry_path
			file_name = dir.get_next()  
		dir.list_dir_end()  # Close the directory listing
	else:
		print("An error occurred when trying to access the path: " + path)
