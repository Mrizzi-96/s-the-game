class_name squish_animation
extends Node2D

@export var step=5

@export var limitX:float

@export var limitY:float

var _can_squish=true

@onready var _squish_state

var _original_scale

var _squished_scale

@onready var _alpha=0

func _ready() -> void:
	_original_scale=scale
	_squished_scale=Vector2(limitX,limitY)
	_squish_state="STOP"

func _process(delta: float) -> void:
	if _squish_state=="DECREASE":
		_squish_process(delta,_original_scale,_squished_scale,"INCREASE")
	elif _squish_state=="INCREASE":
		_squish_process(delta,_squished_scale,_original_scale,"STOP")
	
func _squish_process(delta,from,to,next_state):
		interpolation(from,to,delta)
		if _alpha>=1:
			_alpha=0
			_squish_state=next_state
		
func interpolation(from,to,delta):
	scale=lerp(from,to,_alpha)
	_alpha=_alpha+step*delta

func squish():
	_squish_state="DECREASE"
