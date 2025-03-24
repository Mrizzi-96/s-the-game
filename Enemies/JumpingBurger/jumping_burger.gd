extends Enemy

var is_falling = true
var jump_direction = Vector2(0, -100)
var player_position
var distance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$RigidBody2D/Sprite2D.global_rotation = 0
	player_position = get_node("../Player/Hips").global_position
	distance = $RigidBody2D.global_position - player_position
	if distance.x < 0:
		jump_direction.x = 100
		if is_falling == false:
			$RigidBody2D/Sprite2D.flip_h = true
	elif distance.x > 0:
		jump_direction.x = -100
		if is_falling == false:
			$RigidBody2D/Sprite2D.flip_h = false
	hop(jump_direction)
	
func hop(direction):	
	if is_falling == false:
		$RigidBody2D.apply_impulse(direction)
		is_falling = true

func _on_rigid_body_2d_body_entered(body):
	if body.is_in_group("ground"):
		is_falling = false
		$RigidBody2D.linear_velocity = Vector2.ZERO
	
