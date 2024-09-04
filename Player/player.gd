extends Node2D

var _smoothed_mouse_pos : Vector2 # use to have a smooth leg rotation movement
var max_speed = 2000
@onready var left_leg = $Hips/Ass/LeftLeg
@onready var right_leg = $Hips/Ass/RightLeg

var active_leg
var max_rotation_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	active_leg = right_leg


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos, get_global_mouse_position(), 0.25)
	# make selected leg look at mouse pos
	active_leg.look_at(_smoothed_mouse_pos)
	
func _unhandled_input(event):
	if Input.is_action_pressed("act"):
		print('act')
		# TODO: finish implementing Act
	elif Input.is_action_pressed("switch"):
		toggle_active_leg()
	return 
	
func toggle_active_leg():
	# toggle selected leg
	active_leg = left_leg if active_leg == right_leg else right_leg
