class_name TwoLegsPlayer
extends Player

@onready var left_crossair=$LeftCrossair
@onready var right_crossair=$RightCrossair

@onready var hips=$Hips

var last_left_vector
var last_right_vector

func _ready() -> void:
	super._ready()
	last_left_vector=Vector2.ZERO
	last_right_vector=Vector2.ZERO

func _process(_delta): #do the active leg basin
	var left_vector=_compute_left_crossair_position()
	var right_vector=_compute_right_crossair_position()
	if(left_vector!=Vector2.ZERO):
		last_left_vector=left_vector
	if(right_vector!=Vector2.ZERO):
		last_right_vector=right_vector
	left_crossair.position=hips.position+last_left_vector*500;
	right_crossair.position=hips.position+last_right_vector*500;
	left_leg.look_at(left_crossair.position)
	right_leg.look_at(right_crossair.position)
	
func _compute_left_crossair_position(): #compute crossair position for leg movement basing on left thumbstick
	var rotationX=-Input.get_axis("rotateX","negativeRotateX")
	var rotationY=Input.get_axis("rotateY","negativeRotateY")
	var vector=Vector2(rotationX,rotationY)
	return vector.normalized()

func _compute_right_crossair_position(): #compute crossair position for leg movement basing on left thumbstick
	var rotationX=-Input.get_axis("rightRotateX","negativeRightRotateX")
	var rotationY=Input.get_axis("rightRotateY","negativeRightRotateY")
	var vector=Vector2(rotationX,rotationY)
	return vector.normalized()
