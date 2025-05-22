class_name PowShopCard
extends Control

var image_path : String
var item_data : ItemData

@onready var bought: bool
@onready var buy_selection:Texture2D=load("res://Shop/shop-invetory items/upgrade card/tooltip (when cursor is above card)/card selection (shop) when cursor is above it.png")
@onready var equip_selection:Texture2D=load("res://Shop/shop-invetory items/upgrade card/tooltip (when cursor is above card)/card selection (inventory) when cursor is above it.png")
@onready var image_texture : TextureRect = %PowerUP
@onready var pickUP_texture : TextureRect = %PickUP
@onready var item_price = %ItemPrice
@onready var buy_button : Button = %BuyButton
@onready var title : Label = %Title

var start_position=position
var following = false
var center=size/2

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
	item_price.text=(str(item_data.price))
	# disable buy button if player has not enough money
	#buy_button.disabled = item_data.price > RunInfo.player_data.gold

func buy():
	if !bought:
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



func _on_buy_button_mouse_entered() -> void:
	%EmptyTooltip.visible=true
	if bought==true:
		buy_button.icon=equip_selection
	else:
		buy_button.icon=buy_selection



func _on_buy_button_mouse_exited() -> void:
	if !is_queued_for_deletion():
		%EmptyTooltip.visible=false
		buy_button.icon = null

func drag() -> void:
	if bought==true:
		
		pass # Replace with function body.
