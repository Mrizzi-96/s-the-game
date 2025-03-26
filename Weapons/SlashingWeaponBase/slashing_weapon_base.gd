extends RigidBody2D

class_name SlashingWeapon

@export var slash_strength = 5000
@export var item_data : ItemData

var knife

func _ready():
	# set this item's sprite to item_data.texture
	%WeaponSprite.texture  = item_data.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("act"):
		act()

func act() -> void:
	add_impulse_player()

func add_impulse_player():
	$"../../../..".apply_impulse(Vector2(slash_strength, 0).rotated($"../..".global_rotation))

func _on_body_entered(body) -> void:
	if body.is_in_group("enemies"):
		body.get_parent()._hit(100)
