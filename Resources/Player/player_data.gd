class_name PlayerData extends Resource

@export var gold : int
@export var inventory: Array[ItemData]
@export var equipment : Dictionary # here, we set a dictionary with "left_leg" / "right_leg" and ItemData as value.
@export var health : int

func add_to_equipment(leg: String, item_data : ItemData):
	equipment[leg] = item_data
	
func add_to_inventory(item_data:ItemData):
	if not inventory.has(item_data):
		inventory.append(item_data)
