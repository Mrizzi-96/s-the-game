extends RigidBody2D

@export var player_bullet : PackedScene

var knife
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(_event):
	if Input.is_action_just_pressed("knife"):
		act()

func act():
	add_impulse_player()
	# TODO: add opposing force to player

func add_impulse_player():
	var direction = ($Direction.global_position - global_position).normalized()
	var impulse_strength = 5000  # Puoi modificare questa forza come preferisci
	var impulse = direction * impulse_strength
	$"../../..".apply_central_impulse(impulse)
