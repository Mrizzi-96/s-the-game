class_name ScoreManager
extends Node2D

enum ScoreRank
{
	E,
	D,
	C,
	B,
	A,
	S
}

@export var _time_value_modifiers:Dictionary[float,float] # key = time, #value = modifiers

@export var _rank_threesholds:Dictionary[ScoreRank,int]

@onready var _total_time:float=3.0

@onready var _timer:Timer = $ScoreTimer

@onready var _total_points:int=0

@onready var _enemy_count:int=0

@onready var _point_accumulator:int=0

@onready var _last_enemy_time_elapsed:float=0


func init():
	_time_value_modifiers.sort()
	if not _time_value_modifiers.is_empty():
		var keys=_time_value_modifiers.keys();
		_total_time=keys[len(keys)-1] #because the dictionary is sorted, the last key has the greatest value
	_timer.wait_time=_total_time				
		
func _compute_points(modifier:float): #compute the combo points and refresh the variables
	var combo_points:int=modifier*_point_accumulator
	_total_points+=combo_points
	_refresh_values()

func _refresh_values():
	_enemy_count=0
	_point_accumulator=0
	_last_enemy_time_elapsed=0
	_timer.wait_time=_total_time

func _on_timer_timeout() -> void:
	var modifier=get_current_modifier()
	_compute_points(modifier)

func _compute_nearest_time(_time_elapsed): #given the time passed, it compute the nearest combo time
	var times=_time_value_modifiers.keys()
	times.reverse()
	var nearest_time=times[0]
	for time in times:
		if _time_elapsed <= time:
			nearest_time = time
	return nearest_time

func add_points(points):
	_point_accumulator+=points
	if len(_time_value_modifiers)==0: #I compute combos only if there are modifiers
		print("Add values to use combos!")
		return;
	_enemy_count+=1
	if _timer.is_stopped(): #case 1: I hit the first enemy, i start the combo
		_timer.start()
	if _enemy_count == 2: #case 2: I hit the second enemy, the combo is valid
		_last_enemy_time_elapsed = _timer.wait_time - _timer.time_left
		_timer.paused=true
		_timer.wait_time = _compute_nearest_time(_last_enemy_time_elapsed)
		_timer.paused=false

func get_total_points():
	return _total_points

func get_current_modifier():
	if _timer.is_stopped() or _enemy_count<=1:
		return 1;
	var time=_compute_nearest_time(_last_enemy_time_elapsed)
	return _time_value_modifiers[time]

func get_current_rank():
	var rank=ScoreRank.E
	if _rank_threesholds.is_empty():
		return _rank_to_str(rank)
	for key in _rank_threesholds.keys():
		if _total_points>=_rank_threesholds[key]:
			rank=key
	return _rank_to_str(rank)

func _rank_to_str(rank):
	match rank:
		ScoreRank.E:
			return "E"
		ScoreRank.D:
			return "D"
		ScoreRank.C:
			return "C"
		ScoreRank.B:
			return "B"
		ScoreRank.A:
			return "A"
		ScoreRank.S:
			return "S"
