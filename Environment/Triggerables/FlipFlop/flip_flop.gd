class_name flip_flop
extends Node2D

@export var wait_time:float

@export var trigger_all_nodes_in_group:bool

@export var group_to_trigger:String

@export var function_to_run:String

@onready var timer:Timer =$Timer



signal flip_flop_triggered

func _ready() -> void:
	timer.wait_time=wait_time
	timer.timeout.connect(on_timeout)
	timer.one_shot=true
	timer.start()
	if trigger_all_nodes_in_group:
		flip_flop_triggered.connect(on_flip_flop_triggered_all_nodes)
	
func _process(delta: float) -> void:
	pass
	
func on_timeout():
	flip_flop_triggered.emit()
	timer.start()

func on_flip_flop_triggered_all_nodes(): #
	if group_to_trigger!="" and function_to_run!="":
		get_tree().call_group(group_to_trigger,function_to_run)
