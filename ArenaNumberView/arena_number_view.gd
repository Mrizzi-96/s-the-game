class_name ArenaNumberView
extends Control

@export var interval:float

@export var hide_interval:float

@export var autorstart:bool=false

@export var one_shot:bool=false

@export var ignore_time_scale:bool=false

@export var number:int=0

signal start

func _enter_tree() -> void:
	$Timer.wait_time=interval
	$Timer.autostart=autorstart
	$Timer.one_shot=one_shot
	$Timer.ignore_time_scale=ignore_time_scale
	
	$Timer2.wait_time=hide_interval
	$Timer2.autostart=autorstart
	$Timer2.one_shot=one_shot
	$Timer2.ignore_time_scale=ignore_time_scale

func _ready() -> void:
	$Label.text="Arena "+str(number)
	$Timer.start()
	


func _on_timer_timeout() -> void:
	start.emit()
	$Label.text="Go!"
	$Timer2.start()



func _on_timer_2_timeout() -> void:
	self.visible=false
