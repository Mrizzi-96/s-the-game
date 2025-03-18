class_name ItemShopCard extends Control

var image_path : String
var item_data : ItemData

@onready var image_texture = %ImageTexture
@onready var item_price = %ItemPrice
@onready var buy_button : Button = %BuyButton

func init(item: ItemData, cms : Vector2):
	if not is_node_ready():
		await ready
	self.item_data = item
	# set image
	image_path = item.texture.resource_path
	image_texture.texture = item.texture
	image_texture.custom_minimum_size = cms
	
	# set price
	item_price.set_text(str(item_data.price))
	# disable buy button if player has not enough money
	buy_button.disabled = item_data.price > RunInfo.player_data.gold
		

func buy():
	var player_gold = RunInfo.player_data.gold
	if item_data.price > player_gold:
		print("NOT ABLE TO BUY")
	else:
		# remove item price from player gold
		RunInfo.player_data.gold = player_gold - item_data.price
		if	RunInfo.player_data.gold < 0:
			RunInfo.player_data.gold = 0
			
		# add to RunInfo player_inventory
		RunInfo.player_data.add_to_inventory(item_data)
		# remove card from shop
		queue_free()
