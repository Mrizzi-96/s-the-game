extends Control

var card_base_scene = preload("res://Shop/item_card.tscn")
var inv_card_scene = preload("res://Shop/inventory_card.tscn")

@onready var item_resources_folder_path = "res://Resources/Items/"
@onready var player_data = RunInfo.player_data

# Called when the node enters the scene tree for the first time.
func _ready():
	# populate shop
	for i in RunInfo.items.size():
		var instCardScn = card_base_scene.instantiate() as ItemShopCard
		instCardScn.init(RunInfo.items[i], Vector2(128,128))
		%ShopGrid.add_child(instCardScn)
		
	# do the same for player inventory
	for i in player_data.inventory.size():
		var invCard = inv_card_scene.instantiate() as InventoryCard
		invCard.init(player_data.inventory[i], Vector2(128,128))
		%InventoryGrid.add_child(invCard)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_resume_button_pressed():
	Global.goto_scene("res://ArenaChoice/arena_choice.tscn")
