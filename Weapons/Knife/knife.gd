extends SlashingWeapon

func _ready():
	item_data = ResourceLoader.load("res://Resources/Items/knife.tres")
	super.init()
	
