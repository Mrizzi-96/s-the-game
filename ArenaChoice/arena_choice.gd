extends Control

var phase:String=""
var number_arena=1

@export var difficulty:Array[Texture2D] = []

var difficulty_variant = {
	"phase_1": {1: 70, 2: 25, 3: 5},
	"phase_2": {1: 50, 2: 30, 3: 20},
	"phase_3": {1: 20, 2: 50, 3: 30},
	"phase_4": {1: 10, 2: 50, 3: 40},
	"phase_5": {1: 5, 2: 25, 3: 70},
	"phase_6": {1: 0, 2: 0, 3: 100}
}


func _ready():
	phase=match_phase()
	for i in range(3):
		select_arena(i+1)

func select_arena(i:int):
	var arena = get_node("ArenaSelector/BgArena%d" % i) as TextureRect
	var valore =choice_difficulty(phase)
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
	if number_arena<20:
		return "phase_1"
	elif number_arena<50:
		return "phase_2"
	elif number_arena<80:
		return "phase_3"
	elif number_arena<120:
		return "phase_4"
	elif number_arena<200:
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
	Global.goto_scene("res://MainMenu/main_menu.tscn")

func goto_arena_1():
	Global.goto_scene("res://Levels/level1.tscn")

func goto_arena_2():
	Global.goto_scene("res://Levels/level2.tscn")

func goto_arena_3():
	Global.goto_scene("res://Levels/level3.tscn")
