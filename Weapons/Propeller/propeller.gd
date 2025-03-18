extends SlashingWeapon


# Called when the node enters the scene tree for the first time.
func _ready():
	item_data = ResourceLoader.load("res://Resources/Items/propeller.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
