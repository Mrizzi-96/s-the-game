class_name InventoryCard extends Control

var image_path : String
var item_data : ItemData


@onready var image_texture = %ImageTexture

signal left_weapon_equipped(prev_weapon : String, next_weapon : String)
signal right_weapon_equipped(prev_weapon : String, next_weapon : String)

func init(item: ItemData):
	if not is_node_ready():
		await ready
	self.item_data = item
	add_to_group("InventoryCard")
	
	# set image
	image_path = item.texture.resource_path
	image_texture.texture = item.texture
	# ignore size of image to have them all same size
	image_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE	
	image_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# if equipment contains the itemdata, then disable button using key
	if RunInfo.player_data.is_equipped("LeftLeg", item_data.name.to_lower()) or RunInfo.player_data.is_equipped("RightLeg", item_data.name.to_lower()):
		disable_buttons()
	# else do nothing
	
func disable_button(button : Button):
	button.disabled = true
	button.visible = false
	
func enable_button(leg : String):
	var button = %EquipButtonLeft if leg =="LeftLeg" else %EquipButtonRight
	# disable equipped button
	%EquippedButton.visible = false
	button.disabled = false
	button.visible = true

func enable_buttons():
	# hide equipped button
	%EquippedButton.visible = false
	# show and re-enable left/right buttons
	%EquipButtonLeft.disabled = false
	%EquipButtonLeft.visible = true
	%EquipButtonRight.disabled = false
	%EquipButtonRight.visible = true

func disable_buttons():
	# hide equipped button
	%EquippedButton.visible = true
	# show and re-enable left/right buttons
	%EquipButtonLeft.disabled = true
	%EquipButtonLeft.visible = false
	%EquipButtonRight.disabled = true
	%EquipButtonRight.visible = false
	

func _on_equip_button_left_pressed():
	var leg = "LeftLeg"
	disable_buttons()
	# signal to shopmanager to re-enable buttons on previous inventory card 
	var prev_weapon = RunInfo.player_data.get_equipped(leg)
	var next_weapon = item_data.name.to_lower()
	RunInfo.player_data.add_to_equipment(leg, next_weapon)	
	left_weapon_equipped.emit(prev_weapon, next_weapon)


func _on_equip_button_right_pressed():
	var leg = "RightLeg"
	disable_buttons()
	# signal to shopmanager to re-enable buttons on previous inventory card 
	var prev_weapon = RunInfo.player_data.get_equipped(leg)
	var next_weapon = item_data.name.to_lower()
	RunInfo.player_data.add_to_equipment(leg, next_weapon)	
	right_weapon_equipped.emit(prev_weapon, next_weapon)
