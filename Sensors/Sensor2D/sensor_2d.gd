class_name Sensor2D
extends Node2D

signal sensor_detected(target: Node)
signal sensor_lost(target: Node)

@export var detection_mask: int
@export var occlusion_mask: int

var _candidates: Dictionary = {}
var _dirty: bool = true
var _last_detected: Node = null

var _last_position := Vector2.ZERO
var _last_rotation := 0.0


func mark_dirty() -> void:
	_dirty = true
	_evaluate()
	queue_redraw()


func _evaluate() -> void:
	if not _dirty:
		return

	var seen := detect()
	var previous := _last_detected

	if seen != null:
		if previous != seen:
			if previous != null:
				sensor_lost.emit(previous)
			sensor_detected.emit(seen)
		_last_detected = seen
	else:
		if previous != null:
			sensor_lost.emit(previous)
		_last_detected = null

	_dirty = false


func _process(_delta: float) -> void:
	if global_position != _last_position or rotation != _last_rotation:
		_last_position = global_position
		_last_rotation = rotation
		mark_dirty()


func detect() -> Node:
	return null


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.collision_layer & detection_mask != 0:
		_candidates[body] = true
		mark_dirty()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if _candidates.erase(body):
		mark_dirty()
