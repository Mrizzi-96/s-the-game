class_name InventoryCard extends Control

var image_path : String
var item_data : ItemData

@onready var image_texture = %ImageTexture
@onready var title :Label = %Title

func init(item: ItemData, cms : Vector2):
	if not is_node_ready():
		await ready
	self.item_data = item
	
	# set title
	title.text = item_data.name.capitalize()
	
	# set image
	image_path = item.texture.resource_path
	image_texture.texture = item.texture
	image_texture.custom_minimum_size = cms
		

func equip(_leg):
	# TODO: equip in player's left or right leg: Global.right_leg_weapon/left_leg_weapon and pass it the itemData name 
	# TODO: create inventory card for previous equipped resource and add it to the inventory
	# TODO: remove newly equipped item's InventoryCard (self.queue_free)
	pass
