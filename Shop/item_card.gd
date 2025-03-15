class_name ItemShopCard extends Control

var image_path : String
var item_data : ItemData

@onready var image_texture = %ImageTexture
@onready var item_price = %ItemPrice

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

func buy():
	if item_data.price > 0:
		print("NOT ABLE TO BUY")
