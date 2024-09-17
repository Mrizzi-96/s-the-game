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
var right_leg_weapon : PackedScene

signal game_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	active_leg = right_leg
	# setup to max value
	health_bar.value = health_bar.max_value
	is_game_over = false
	# TODO: add Equip(weapon_scene_path) method to change weapons
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos, get_global_mouse_position(), 0.25)
	# make selected leg look at mouse pos
	active_leg.look_at(_smoothed_mouse_pos)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("act"):
		print('act')
		
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
		emit_signal("game_ended")
