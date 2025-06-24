class_name flip_flop
extends Node2D

@export var wait_time:float

@export var trigger_all_nodes_in_group:bool

@export var group_to_trigger:String

@export var flip_function_to_run:String

@export var flop_function_to_run:String

@onready var timer:Timer =$Timer

var state:bool

signal flip_triggered

signal flop_triggered

func _ready() -> void:
	state=false
	timer.wait_time=wait_time
	timer.timeout.connect(on_timeout)
	timer.one_shot=true
	timer.start()
	if trigger_all_nodes_in_group:
		flip_triggered.connect(on_flip_triggered_all_nodes)
		flop_triggered.connect(on_flop_triggered_all_nodes)
	
func _process(delta: float) -> void:
	pass
	
func on_timeout():
	if(state):
		flip_triggered.emit()
	else: flop_triggered.emit()
	timer.start()

func on_flip_triggered_all_nodes(): #
	if group_to_trigger!="" and flip_function_to_run!="":
		get_tree().call_group(group_to_trigger,flip_function_to_run)
		
func on_flop_triggered_all_nodes(): #
	if group_to_trigger!="" and flop_function_to_run!="":
		get_tree().call_group(group_to_trigger,flop_function_to_run)
