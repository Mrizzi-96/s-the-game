class_name PlayerData extends Resource

@export var gold : int
@export var inventory: Array[ItemData]
@export var equipment : Dictionary # here, we set a dictionary with "left_leg" / "right_leg" and String as value (item_data.name lowercased).
@export var health : int

func add_to_equipment(leg: String, item_name : String):
	equipment[leg] = item_name.to_lower() # lowercase since Global.Weapons[key] is lowercase
	
func is_equipped(key: String, item_name: String):
	return equipment[key] == item_name	
	
func get_equipped(key: String):
	return equipment[key]

func is_in_inventory(item_data:ItemData):
	return inventory.has(item_data)

func add_to_inventory(item_data:ItemData):
	if not inventory.has(item_data):
		inventory.append(item_data)
