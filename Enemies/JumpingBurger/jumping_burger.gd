extends Enemy

var is_jumping = true
var is_grounded = false
var jump_direction = Vector2(0, -100)
var player_position
var distance

var land_cooldown = 0.1     # secondi di grazia dopo lo spawn/salto
var hop_cooldown = 0.1    # secondi a terra prima del prossimo salto
var time_since_hop = 0.0
var time_since_land = 0.0

@onready var burger_sprite: AnimatedSprite2D = %BurgerSprite

func _process(delta):
	burger_sprite.global_rotation = 0
	time_since_hop += delta

	if is_grounded:
		time_since_land += delta

	player_position = get_tree().get_first_node_in_group("player").get_node("Hips").global_position
	distance = $RigidBody2D.global_position - player_position

	if distance.x < 0:
		jump_direction.x = 100
		if not is_jumping:
			burger_sprite.flip_h = false
	elif distance.x > 0:
		jump_direction.x = -100
		if not is_jumping:
			burger_sprite.flip_h = true

	if not is_jumping and is_grounded and time_since_land >= hop_cooldown:
		hop(jump_direction)

func hop(direction):
	is_grounded = false
	time_since_land = 0.0
	time_since_hop = 0.0
	$RigidBody2D.apply_impulse(direction)
	is_jumping = true
	burger_sprite.stop()
	burger_sprite.play("jumping")

func _death():
	super._death()
	burger_sprite.stop()
	burger_sprite.play("death")

func _on_rigid_body_2d_body_entered(body):
	if body.is_in_group("ground") and time_since_hop > land_cooldown:
		stop_jumping()

func stop_jumping():
	if is_jumping == false:
		return
	is_jumping = false
	is_grounded = true
	time_since_land = 0.0
	burger_sprite.stop()
	burger_sprite.play("grounded")
