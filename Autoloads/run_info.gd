extends Node

### This class contains all properties from the run, like the number of rounds played, the available items etc 
const ITEMDATA_DIR_PATH : String = "res://Resources/Items/"

@export var items : Array[ItemData]

@export var player_data : PlayerData

@export var arena_counter: int = 0
## The number of the currently playable arenas
@export var arena_playable: int = 5
# this will be populated on choosing the correct arena
@export var current_arena_params: ArenaParams

@export var total_score : int = 0

var is_final:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_items()
	player_data = ResourceLoader.load("res://Resources/Player/player_start.tres")
	if RunInfo.arena_counter==10:
		%NextArenaButton.text="Final Arena"
	

func reset() -> void:
	arena_counter = 1
	total_score = 0
	player_data = ResourceLoader.load("res://Resources/Player/player_start.tres")
	_reset_arena_params()
	populate_items()

func _reset_arena_params():
	RunInfo.current_arena_params = ArenaParams.new()
	var arena_path : String = "res://Levels/arena%d" % randi_range(1,RunInfo.arena_playable) +".tscn"
	RunInfo.current_arena_params.arena_scene = arena_path
	RunInfo.current_arena_params.difficulty = 1
	RunInfo.current_arena_params.reward_type = ArenaParams.RewardType.WEAPON

func calculate_next_arena_params():
	RunInfo.arena_counter = RunInfo.arena_counter + 1
	var ap = RunInfo.current_arena_params
	# choose random arena
	var arena_path : String = "res://Levels/arena%d" % randi_range(1,RunInfo.arena_playable) +".tscn"
	ap.arena_scene = arena_path
	ap.difficulty = _calculate_difficulty()
	ap.is_final=false
	ap.reward_type = ArenaParams.RewardType.WEAPON
	
func calculate_final_arena_params():
	RunInfo.arena_counter = RunInfo.arena_counter + 1
	var ap = RunInfo.current_arena_params
	# choose random arena
	var arena_path : String = "res://Levels/arena%d" % randi_range(1,RunInfo.arena_playable) +".tscn"
	ap.arena_scene = arena_path
	ap.difficulty = 3
	ap.is_final=true
	ap.reward_type = ArenaParams.RewardType.WEAPON

func _calculate_difficulty() -> int:
	if arena_counter > 0 and arena_counter <= 3:
		return 1
	elif arena_counter > 3 and arena_counter < 7:
		return 2
	elif arena_counter >= 7:
		return 3
	else:
		return 1

	
func populate_items() -> void:
	for i in DirAccess.get_files_at(ITEMDATA_DIR_PATH):
		if i.ends_with(".remap"):
			i = i.replace(".remap", "")
		var item = ResourceLoader.load(ITEMDATA_DIR_PATH + i) as ItemData
		items.append(item)
		#print(items)
	# TODO: ricordati di inizializzare delle card diverse da speed UP, creandole con parametri diversi.
	# Ne aggiunge 5 più quelle precedentemente inserite in items!
	#for i in range (0,7):
		#var power_up = ResourceLoader.load("res://Resources/Items/speedUP.tres") as ItemData
		#items.append(power_up)
		
