class_name env_switch
extends Area2D

@export var trigger_all_nodes_in_group:bool

@export var group_to_trigger:String

@export var function_to_run:String

@export var state:bool

@onready var sprite=$CollisionShape2D/Sprite2D

signal switch_triggered

func _ready() -> void:
	change_color()
	if trigger_all_nodes_in_group:
		switch_triggered.connect(on_switch_triggered_all_nodes)
	area_entered.connect(_on_area_entered)
	
func _process(delta: float) -> void:
	pass
	
func change_color(): #change color of the switch
	var color = Color.DARK_RED
	if state:
		color=Color.AQUAMARINE
	sprite.modulate=color
	
func on_switch_triggered_all_nodes(): #
	if group_to_trigger!="" and function_to_run!="":
		get_tree().call_group(group_to_trigger,function_to_run)

func _on_area_entered(area: Area2D) -> void:
	state=not state
	change_color()
	switch_triggered.emit()
