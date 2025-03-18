extends SlashingWeapon

func _ready():
	item_data = ResourceLoader.load("res://Resources/Items/knife.tres")
	
func add_impulse_player():
	$"../../../..".apply_impulse(Vector2(slash_strength, 0).rotated($"../..".global_rotation))
