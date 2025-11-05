extends Control

var phase:String=""
var number_arena=5

@export var difficulty:Array[Texture2D] = []
@onready var arena_params = ArenaParams.new()
# WARNING:
# For now, on button click the arena params will be added as hardcoded.
# @jadedpear will then use the ones from his arena_preview scene
# see #TG-110 on Taiga

var difficulty_variant = {
	"phase_1": {1: 70, 2: 25, 3: 5},
	"phase_2": {1: 50, 2: 30, 3: 20},
	"phase_3": {1: 20, 2: 50, 3: 30},
	"phase_4": {1: 10, 2: 50, 3: 40},
	"phase_5": {1: 5, 2: 25, 3: 70},
	"phase_6": {1: 0, 2: 0, 3: 100}
}

func _ready():
	#start initialize arena number and decided phase for new choice difficulty 
	$ArenaNumber.text="Arena "+str(RunInfo.arenanumber)+":"
	phase=match_phase()
	for i in range(3):
		select_arena(i+1)

func select_arena(i:int):
	var arena = get_node("ArenaSelector/BgArena%d" % i) as TextureRect
	var valore =choice_difficulty(phase)
	arena.difficulty=valore
	match valore:
		1:
			arena.texture=difficulty[0]
			print("È uno")
		2:
			arena.texture=difficulty[1]
			print("È due")
		3:
			arena.texture=difficulty[2]
			print("È tre")

func match_phase()-> String:
	if RunInfo.arenanumber<20:
		return "phase_1"
	elif RunInfo.arenanumber<50:
		return "phase_2"
	elif RunInfo.arenanumber<80:
		return "phase_3"
	elif RunInfo.arenanumber<120:
		return "phase_4"
	elif RunInfo.arenanumber<200:
		return "phase_5"
	else:
		return "phase_6"

func choice_difficulty(phase: String) -> int:
	var chances = difficulty_variant.get(phase)
	var pool = []
	for i in range(int(chances[1])):
		pool.append(1)
	for i in range(int(chances[2])):
		pool.append(2)
	for i in range(int(chances[3])):
		pool.append(3)
	pool.shuffle()
	return pool[randi() % pool.size()]

func back_to_menu():
	Global.goto_scene("res://Shop/shop.tscn")

#func goto_arena_1():
	#var arena_path = "res://Levels/arena1.tscn"
	#arena_params.arena_scene = preload("res://Levels/arena1.tscn")
	#arena_params.difficulty = 1
	#arena_params.reward_type = ArenaParams.RewardType.WEAPON
	#RunInfo.current_arena_params = arena_params
	#
	#Global.goto_scene(arena_path)
#
#func goto_arena_2():
	#var arena_path = "res://Levels/arena2.tscn"
	#arena_params.arena_scene = preload("res://Levels/arena2.tscn")
	#arena_params.difficulty = 2
	#arena_params.reward_type = ArenaParams.RewardType.GOLD	
	#RunInfo.current_arena_params = arena_params
	#
	#Global.goto_scene(arena_path)
#
#func goto_arena_3():
	#var arena_path = "res://Levels/arena3.tscn"
	#arena_params.arena_scene = preload("res://Levels/arena3.tscn")
	#arena_params.difficulty = 3
	#arena_params.reward_type = ArenaParams.RewardType.SKILL
	#RunInfo.current_arena_params = arena_params
	#
	#Global.goto_scene(arena_path)


func _on_bg_arena_1_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$ArenaSelector/BgArena1.modulate=Color(0.767, 0.767, 0.767)
		var arena_path = "res://Levels/arena1.tscn"
		arena_params.arena_scene = preload("res://Levels/arena1.tscn")
		arena_params.difficulty = $ArenaSelector/BgArena1.difficulty
		arena_params.reward_type = ArenaParams.RewardType.WEAPON
		RunInfo.current_arena_params = arena_params
		
		#Global.goto_scene(arena_path)


func _on_bg_arena_2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$ArenaSelector/BgArena2.modulate=Color(0.767, 0.767, 0.767)
		var arena_path = "res://Levels/arena2.tscn"
		arena_params.arena_scene = preload("res://Levels/arena2.tscn")
		arena_params.difficulty = $ArenaSelector/BgArena2.difficulty
		arena_params.reward_type = ArenaParams.RewardType.GOLD	
		RunInfo.current_arena_params = arena_params
		print(arena_params.difficulty)
		#Global.goto_scene(arena_path)


func _on_bg_arena_3_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$ArenaSelector/BgArena3.modulate=Color(0.767, 0.767, 0.767)
		var arena_path = "res://Levels/arena3.tscn"
		arena_params.arena_scene = preload("res://Levels/arena3.tscn")
		arena_params.difficulty = $ArenaSelector/BgArena3.difficulty
		arena_params.reward_type = ArenaParams.RewardType.SKILL
		RunInfo.current_arena_params = arena_params
		
		#Global.goto_scene(arena_path)


func _on_bg_arena_1_mouse_exited():
	$ArenaSelector/BgArena3.modulate=Color(1, 1, 1)


func _on_bg_arena_2_mouse_exited():
	$ArenaSelector/BgArena3.modulate=Color(1, 1, 1)


func _on_bg_arena_3_mouse_exited():
	$ArenaSelector/BgArena3.modulate=Color(1, 1, 1)
