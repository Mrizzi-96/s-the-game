extends Control

@export var ITEMS_PER_ROW = 12
var card_base_scene = preload("res://Shop/item_card.tscn")
@onready var item_resources_folder_path = "res://Resources/Items/"

# Called when the node enters the scene tree for the first time.
func _ready():
	# load item resources as array of resources
	var items_path = []
	for i in DirAccess.get_files_at("res://Resources/Items"):
		if 	i.ends_with(".gd"):
			continue
		var item_full_path = item_resources_folder_path + i 
		items_path.append(item_full_path)
		
	for i in items_path.size():
		var item = load(items_path[i])
		var instCardScn = card_base_scene.instantiate() as ItemShopCard
		instCardScn.init(item, Vector2(128,128))
		%ShopGrid.add_child(instCardScn)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
