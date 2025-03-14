extends Control

@export var ITEMS_PER_ROW = 12
var card_base_scene = preload("res://Shop/item_card.tscn")
@onready var item_resources_folder_path = "res://Resources/Items/"

# Called when the node enters the scene tree for the first time.
func _ready():
		
	for i in RunInfo.items.size():
		var instCardScn = card_base_scene.instantiate() as ItemShopCard
		instCardScn.init(RunInfo.items[i], Vector2(128,128))
		%ShopGrid.add_child(instCardScn)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
