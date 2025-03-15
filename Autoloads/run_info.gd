extends Node

### This class contains all properties from the run, like the number of rounds played, the available items etc 
const ITEMDATA_DIR_PATH : String = "res://Resources/Items/"

@export var items : Array[ItemData]

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_items()

func populate_items() -> void:
	for i in DirAccess.get_files_at(ITEMDATA_DIR_PATH):
		var item = ResourceLoader.load(ITEMDATA_DIR_PATH + i) as ItemData
		items.append(item)
