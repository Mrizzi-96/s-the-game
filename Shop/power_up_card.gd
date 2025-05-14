class_name PowShopCard
extends Control

var image_path : String
var item_data : ItemData

@onready var bought:bool=true
@export var selection:Texture2D
@onready var image_texture : TextureRect = %PowerUP
@onready var item_price = %ItemPrice
@onready var buy_button : Button = %BuyButton
@onready var title : Label = %Title
signal item_bought(item_data: ItemData)

func init(item: ItemData):
	if not is_node_ready():
		await ready
	self.item_data = item
	# set title
	title.text = item_data.name
	# set image
	#image_path = item.texture.resource_path
	image_texture.texture = item.pickable_texture
	# set price
	item_price.set_text(str(item_data.price))
	# disable buy button if player has not enough money
	#buy_button.disabled = item_data.price > RunInfo.player_data.gold
	
func buy():
	bought=true
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
		# tell shop manager to instantiate a new inventory card
		item_bought.emit(item_data)
		# remove card from shop
		queue_free()

func _on_control_mouse_entered() -> void:
	buy_button.visible=true
	if bought==true:
		buy_button.icon=selection


func _on_control_mouse_exited() -> void:
	buy_button.visible=false
