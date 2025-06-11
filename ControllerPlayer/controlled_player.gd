class_name ControlledPlayer
extends Player

@onready var crossair=$Crossair

@onready var hips=$Hips

var last_vector;

func _ready() -> void:
	super._ready()
	last_vector=Vector2.ZERO

func _process(_delta): #do the active leg basin
	var vector=_compute_crossair_position()
	if(vector!=Vector2.ZERO):
		last_vector=vector
	crossair.position=hips.position+last_vector*500;
	Global.active_leg.look_at(crossair.global_position)
	
func _compute_crossair_position(): #compute crossair position for leg movement basing on left thumbstick
	var rotationX=-Input.get_axis("rotateX","negativeRotateX")
	var rotationY=Input.get_axis("rotateY","negativeRotateY")
	var vector=Vector2(rotationX,rotationY)
	return vector.normalized()
