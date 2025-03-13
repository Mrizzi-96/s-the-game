class_name ItemShopCard extends Control

var image_path : String

@onready var image_texture = %ImageTexture
@onready var item_price = %ItemPrice

func init(item_data: ItemData, cms : Vector2):
	if not is_node_ready():
		await ready
	# set image
	image_path = item_data.texture.resource_path
	image_texture.texture = item_data.texture
	image_texture.custom_minimum_size = cms
	
	# set price
	item_price.set_text(str(item_data.price))

func buy(player_gold):
	if item_price > player_gold:
		print("NOT ABLE TO BUY")
