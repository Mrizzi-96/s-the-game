class_name TimerView
extends Control

@onready var timer=$Timer

@onready var label=$Label

@export var time:float=60.0

@export var one_shot:bool=false

@export var autostart:bool=false

@export var ignore_time_scale:bool=false

signal timeout

func _ready() -> void:
	timer.wait_time=time
	timer.one_shot=one_shot
	timer.ignore_time_scale=ignore_time_scale
	if autostart:
		timer.start()
	
func _process(delta: float) -> void:
	var current_time=timer.time_left
	var minutes=int(current_time/60)
	var seconds=int(current_time - minutes*60)
	#var text= _to_time_string(minutes) + ":" + _to_time_string(seconds)
	var text=_to_time_string(int(current_time))
	label.text=text

func _to_time_string(num):
	var text:String=str(num)
	if len(text)==1:
		text="0"+text
	return text

func start():
	timer.start()

func _on_timer_timeout() -> void:
	timeout.emit()
