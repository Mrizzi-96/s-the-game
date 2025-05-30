extends Control

var item_data : ItemData

@onready var stats_text : Label = %StatsText
@onready var stats_value : Label = %StatsValue
@onready var tag_weapon : TextureRect = %TagWeapon
var m_icon:Texture2D=load("res://Shop/shop-invetory items/upgrade card/M_icon.png")
var s_icon:Texture2D=load("res://Shop/shop-invetory items/upgrade card/S_icon.png")
var non_zero_stats:Dictionary={}


func init(item: ItemData,num):
	if not is_node_ready():
		await ready
	self.item_data = item
	#set stats
	non_zero_stats=item_data.get_non_zero_stats()
	stats_text.text = non_zero_stats[num].text
	stats_value.text = str("+",non_zero_stats[num].value,"%")
	tag_weapon.texture=s_icon
	#print("statistica ",stats_text.text, stats_value.text)
