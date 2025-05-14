class_name ItemData extends Resource

enum Type {ASS, LEFT_LEG, RIGHT_LEG, WEAPON, POWER_UP}

@export var type : Type
@export var name : String
@export_multiline var description : String
@export var texture : Texture2D
@export var price: int
@export var attack_sound : Resource

@export_group("PowerUP_Data")
@export var pickable_texture : Texture2D
@export var slots : int
@export var movement_speed_text : String
@export var movement_speed : int
@export var damage_text : String
@export var damage : int
@export var fire_rate_text:String
@export var fire_rate:int
@export var bought:bool=false
