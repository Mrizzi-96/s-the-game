extends ShootingWeapon

func _ready():
	item_data = ResourceLoader.load("res://Resources/Items/gun.tres")

func spawn_bullet() -> void:
	super.spawn_bullet()
