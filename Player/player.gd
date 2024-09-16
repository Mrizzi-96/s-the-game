extends Node2D

@export var player_bullet : PackedScene

var _smoothed_mouse_pos : Vector2 # use to have a smooth leg rotation movement
var max_speed = 2000
@onready var left_leg = $Hips/Ass/LeftLeg
@onready var right_leg = $Hips/Ass/RightLeg
@export var health_bar : ProgressBar
@export var hit_amount: int
var active_leg
var max_rotation_speed = 10
var is_game_over: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	active_leg = right_leg
	# setup to max value
	health_bar.value = health_bar.max_value
	is_game_over = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos, get_global_mouse_position(), 0.25)
	# make selected leg look at mouse pos
	active_leg.look_at(_smoothed_mouse_pos)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("act"):
		print('act')
		pistol_shoot()
		# TODO: finish implementing Act
	elif Input.is_action_pressed("switch"):
		toggle_active_leg()
	# TODO: move hit logic on Area2D colliding with enemy!
	elif Input.is_key_pressed(KEY_H):
		if !is_game_over:
			player_hit(hit_amount) # amount will vary based on enemy
	return 
	
func toggle_active_leg():
	# toggle selected leg
	active_leg = left_leg if active_leg == right_leg else right_leg

func player_hit(amount):
	health_bar.value -= amount
	if health_bar.value <= 0:
		health_bar.value = 0
		is_game_over = true
		print("GAME_OVER!")
		# TODO: call global game_over()!

func pistol_shoot():
	var bullet = player_bullet.instantiate()
	bullet.position =$Hips/Ass/RightLeg/Pistol/BulletSpawn.global_position
	bullet.rotation =$Hips/Ass/RightLeg/Pistol/BulletSpawn.global_rotation 
	var level_node = get_level_node()
	if level_node:
		level_node.add_child(bullet)
	else:
		print("Level node not found")
		
	# Calcola la direzione opposta
	#var direction = Vector2(cos($BulletSpawn.global_rotation), sin($BulletSpawn.global_rotation)).normalized() * -1
	#var force = direction * 100  # Modifica il valore della forza secondo necessità

	# Applica la forza al player
	#apply_impulse(Vector2(), force)

func get_level_node():
	var node = self
	while node and not node.is_in_group("Level"):
		node = node.get_parent()
	return node
