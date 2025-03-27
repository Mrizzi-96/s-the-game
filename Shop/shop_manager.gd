extends Control

var card_base_scene = preload("res://Shop/item_card.tscn")
var inv_card_scene = preload("res://Shop/inventory_card.tscn")

@onready var item_resources_folder_path = "res://Resources/Items/"
@onready var player_data = RunInfo.player_data
@onready var ll_weapon_preview = %LeftLegWeaponPreview
@onready var rl_weapon_preview = %RightLegWeaponPreview
# stats: gold, wave num, score
@onready var score = %Score
@onready var wave_num = %WaveNum
@onready var player_gold = %PlayerGold

# Called when the node enters the scene tree for the first time.
func _ready():
	# populate shop
	for i in RunInfo.items.size():
		var current_item = RunInfo.items[i] as ItemData
		if not player_data.is_in_inventory(current_item):
			var instCardScn = card_base_scene.instantiate() as ItemShopCard
			instCardScn.connect("item_bought", add_inventory_card)
			instCardScn.init(current_item)
			%ShopGrid.add_child(instCardScn)
	
	# do the same for player inventory
	for i in player_data.inventory.size():
		var invCard = inv_card_scene.instantiate() as InventoryCard
		invCard.init(player_data.inventory[i])
		# connect to signals	
		invCard.left_weapon_equipped.connect(_on_inventory_card_weapon_equipped.bind("LeftLeg"))
		invCard.right_weapon_equipped.connect(_on_inventory_card_weapon_equipped.bind("RightLeg"))
		%InventoryGrid.add_child(invCard)
	# load preview textures
	ll_weapon_preview.texture = player_data.inventory.filter(func(element): return sort_name(element, player_data.get_equipped("LeftLeg")))[0].texture
	rl_weapon_preview.texture = player_data.inventory.filter(func(element): return sort_name(element, player_data.get_equipped("RightLeg")))[0].texture
	
	# set player gold
	player_gold.text = str(player_data.gold)
	# set wave num
	Global.wave

func add_inventory_card(item_data : ItemData):
	# update player_gold
	player_gold.text = str(player_data.gold)
	# add a new inventory card
	var invCard = inv_card_scene.instantiate() as InventoryCard
	invCard.init(item_data)
	# connect to signals
	invCard.left_weapon_equipped.connect(_on_inventory_card_weapon_equipped.bind("LeftLeg"))
	invCard.right_weapon_equipped.connect(_on_inventory_card_weapon_equipped.bind("RightLeg"))
	%InventoryGrid.add_child(invCard)


func _on_resume_button_pressed():
	Global.goto_scene("res://ArenaChoice/arena_choice.tscn")

func sort_name(element : ItemData, next_weapon : String) -> ItemData:
	if element.name.to_lower() == next_weapon:
		return element
	else:
		return null

func _on_inventory_card_weapon_equipped(prev_weapon, next_weapon, leg : String):
	var pdata = RunInfo.player_data as PlayerData
	# get inventory card associated to prev_weapon and call "enable_button"
	var invCard = get_tree().get_nodes_in_group("InventoryCard") as Array[InventoryCard]
	var prev_weapon_inventory_card = invCard.filter(func(element) : return element.item_data.name.to_lower() == prev_weapon)[0] # single access
	prev_weapon_inventory_card.enable_buttons()	
	var data = pdata.inventory.filter(func(element): return sort_name(element, next_weapon))
	if data.size() > 0:
			# get next weapon item data
		var next_item_data = data[0] as ItemData
		if leg == "LeftLeg":
			ll_weapon_preview.texture = next_item_data.texture
		else:
			rl_weapon_preview.texture = next_item_data.texture
	pass
