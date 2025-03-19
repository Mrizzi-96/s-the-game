class_name PlayerData extends Resource

@export var gold : int
@export var inventory: Array[ItemData]
@export var equipment : Dictionary # here, we set a dictionary with "left_leg" / "right_leg" and ItemData as value.
@export var health : int

func add_to_equipment(leg: String, item_name : String):
	equipment[leg] = item_name.to_lower() # lowercase since Global.Weapons[key] is lowercase
	
func add_to_inventory(item_data:ItemData):
	if not inventory.has(item_data):
		inventory.append(item_data)
