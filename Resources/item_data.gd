class_name ItemData extends Resource

enum Type {ASS, LEFT_LEG, RIGHT_LEG, WEAPON, POWER_UP}

@export var type : Type
@export var name : String
@export_multiline var description : String
@export var texture : Texture2D
@export var price: int
@export var attack_sound : Resource
@export var crossair_texture : Texture2D


@export_group("PowerUP_Data")
@export var pickable_texture : Texture2D
@export var slots : int
@export var bought:bool=false


#var shooting_damage_text : String="shooting damage"
#@export var shooting_damage : int
#var fire_rate_text:String="fire rate"
#@export var fire_rate:int
#var health_text : String="health"
#@export var health : int
#var luck_text : String="luck"
#@export var luck : int
#var crit_chance_text : String="crit chance"
#@export var crit_chance : int
#var armor_text : String="armor"
#@export var armor : int
#var thrust_speed_text  : String="thrust speed"
#@export var thrust_speed : int
#var thrust_damage_text : String="thrust damage"
#@export var thrust_damage : int

@export var stats : Dictionary = {
	"shooting_damage": {"text": "shooting damage", "value": 0},
	"fire_rate": {"text": "fire rate", "value": 0},
	"health": {"text": "health", "value": 0},
	"luck": {"text": "luck", "value": 0},
	"crit_chance": {"text": "crit chance", "value": 0},
	"armor": {"text": "armor", "value": 0},
	"thrust_speed": {"text": "thrust speed", "value": 0},
	"thrust_damage": {"text": "thrust damage", "value": 0}
}

func get_item_type() -> Type:
	return type

func get_non_zero_stats():
	var filtered_stats = {}
	for stat_name in stats.keys():
		if stats[stat_name].value != 0:
			filtered_stats[stat_name] = stats[stat_name]
	return filtered_stats

func get_non_zero_stats_count():
	return get_non_zero_stats().size()

# Esempio di utilizzo
#var health_text = stats["health" or number].text  # Ottiene "health"
#var health_value = stats["health" or number].value  # Ottiene il valore numerico
#var non_zero_stats = get_non_zero_stats() # Ottiene statistiche diverse da 0
#var count = get_non_zero_stats_count() # Ottiene numero statistiche diverse da 0
