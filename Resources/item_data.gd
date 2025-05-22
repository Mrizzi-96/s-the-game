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
@export var bought:bool=false
var shooting_damage_text : String="shooting damage"
@export var shooting_damage : int
var fire_rate_text:String="fire rate"
@export var fire_rate:int
var health_text : String="health"
@export var health : int
var luck_text : String="luck"
@export var luck : int
var crit_chance_text : String="crit chance"
@export var crit_chance : int
var armor_text : String="armor"
@export var armor : int
var thrust_speed_text  : String="thrust speed"
@export var thrust_speed : int
var thrust_damage_text : String="thrust damage"
@export var thrust_damage : int
