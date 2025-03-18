extends SlashingWeapon

func _ready():
	item_data = ResourceLoader.load("res://Resources/Items/knife.tres")
	
func add_impulse_player():
	super.add_impulse_player()
