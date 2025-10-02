class_name blinking
extends Timer

@export var step:float

@export var sprites_to_blink:Array[Sprite2D]

@export var blink_color:Color=Color.from_rgba8(255,255,255,0)

@onready var blink_state="NOT_COLOURED"

@onready var _is_active=false

@onready var _base_color=Color.from_rgba8(255,255,255,255)

var _current_color

@onready var _alpha=0

func blink(value):
	_is_active=value
	
func _ready() -> void:
	timeout.connect(on_timer_timeout)

func _process(delta: float) -> void:
	if _is_active:
		if is_stopped():
			start()
	
func on_timer_timeout():
	if _current_color==blink_color:
		_current_color=_base_color
	else: _current_color=blink_color
	if _is_active:
		start()
	else: _current_color=_base_color
	for sprite in sprites_to_blink:
		sprite.modulate=_current_color
	
