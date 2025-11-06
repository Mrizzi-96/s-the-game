extends Node

### This class contains all properties from the run, like the number of rounds played, the available items etc 
const ITEMDATA_DIR_PATH : String = "res://Resources/Items/"

@export var items : Array[ItemData]

@export var player_data : PlayerData

@export var arena_counter: int = 0
# this are the number of arena currently playable
@export var arena_playable: int = 3
# this will be populated on choosing the correct arena
@export var current_arena_params: ArenaParams


# Called when the node enters the scene tree for the first time.
func _ready():
	populate_items()
	player_data = ResourceLoader.load("res://Resources/Player/player_start.tres")
	

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
		
