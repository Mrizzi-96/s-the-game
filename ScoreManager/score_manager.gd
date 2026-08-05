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

@onready var _arena_score: int = 0
@onready var _enemy_count: int = 0
@onready var _enemies_killed_score : int = 0

@onready var _point_accumulator: int = 0

@onready var _last_enemy_time_elapsed: float = 0

var _difficulty=1

var _is_combo_active=false

signal multiplier_changed # called when the multiplier changes
signal multiplier_reset # called when the mult comes back at 1

func init(difficulty=1):
	_time_value_modifiers.sort()
	if not _time_value_modifiers.is_empty():
		var keys=_time_value_modifiers.keys();
		_total_time=keys[len(keys)-1] #because the dictionary is sorted, the last key has the greatest value
	_timer.wait_time=_total_time
	_difficulty=difficulty
	_setup_ranking_thresholds()
	
func _setup_ranking_thresholds():
	for rank in _rank_threesholds.keys():
		var threshold=_rank_threesholds[rank]
		threshold= threshold*(1+RunInfo.arena_counter)*_get_threshold_modifier(rank)*_difficulty
		_rank_threesholds[rank]=int(threshold)		
		
func _on_timer_timeout() -> void:
	var modifier = get_current_multiplier()
	_compute_points(modifier)
	# after points are computed, mult changes back to 1

func _compute_points(modifier:float): #compute the combo points and refresh the variables
	var combo_points:int = floori(modifier*_point_accumulator)
	_arena_score += combo_points
	# add arena score to total score
	RunInfo.total_score += combo_points
	_refresh_values()

func _refresh_values():
	_enemy_count = 0
	_enemies_killed_score = 0
	_point_accumulator = 0
	_last_enemy_time_elapsed = 0
	_timer.wait_time = _total_time
	_is_combo_active=false

func _compute_nearest_time(_time_elapsed): #given the time passed, it compute the nearest combo time
	var times=_time_value_modifiers.keys()
	times.reverse()
	var nearest_time=times[0]
	for time in times:
		if _time_elapsed <= time:
			nearest_time = time
	return nearest_time

func add_points(points):
	_point_accumulator += points
	_enemies_killed_score = _point_accumulator 
	if len(_time_value_modifiers) == 0: #I compute combos only if there are modifiers
		print("Add values to use combos!")
		return;
	_enemy_count+=1
	if _timer.is_stopped(): #case 1: I hit the first enemy, i start the combo
		_timer.start()
	if _enemy_count == 2: #case 2: I hit the second enemy, the combo is valid
	# determine multiplier
		multiplier_changed.emit()
		_last_enemy_time_elapsed = _timer.wait_time - _timer.time_left
		#_timer.paused=true
		if not _is_combo_active:
			_timer.stop()
			_timer.wait_time = _compute_nearest_time(_last_enemy_time_elapsed)
			_timer.start()
			_is_combo_active=true
		#_timer.paused=false

func get_enemies_killed_score():
	return _enemies_killed_score

func get_total_score():
	return RunInfo.total_score

func get_arena_score():
	# include i punti già accumulati in questo combo (non ancora "bancati" dal timer),
	# così il punteggio mostrato si aggiorna subito all'uccisione, non al termine del combo
	return _arena_score + floori(get_current_multiplier() * _point_accumulator)

func get_current_multiplier():
	if _timer.is_stopped() or _enemy_count<=1:
		# signal that mult has reset
		multiplier_reset.emit()
		return 1;
	var time=_compute_nearest_time(_last_enemy_time_elapsed)
	return _time_value_modifiers[time]

func get_rank() -> ScoreRank:
	var rank = ScoreRank.E
	if _rank_threesholds.size() > 0:
		for key in _rank_threesholds.keys():
			if get_arena_score() >= _rank_threesholds[key]:
				rank = key
	return rank

func get_current_rank_label():
	var rank = get_rank()
	return _get_rank_label(rank)

func _get_rank_label(rank):
	match rank:
		ScoreRank.E:
			return ""
		ScoreRank.D:
			return "Diarrhea"
		ScoreRank.C:
			return "Crappy"
		ScoreRank.B:
			return "Bootyful"
		ScoreRank.A:
			return "Asstounding"
		ScoreRank.S:
			return "ASS"

func get_current_rank_image():
	return _get_rank_image(get_rank())

func get_rank_progress() -> float:
	var rank = get_rank()
	if rank == ScoreRank.E or rank == ScoreRank.S:
		return 0.0
	var next_rank = rank + 1
	if not _rank_threesholds.has(rank) or not _rank_threesholds.has(next_rank):
		return 0.0
	var current_threshold = _rank_threesholds[rank]
	var next_threshold = _rank_threesholds[next_rank]
	if next_threshold <= current_threshold:
		return 0.0
	var progress = float(get_arena_score() - current_threshold) / float(next_threshold - current_threshold)
	return clampf(progress, 0.0, 1.0)

func _get_rank_image(rank : ScoreRank):
	match rank:
		ScoreRank.E:
			return ""
		ScoreRank.D:
			return "D.png"
		ScoreRank.C:
			return "C.png"
		ScoreRank.B:
			return "B.png"
		ScoreRank.A:
			return "A.png"
		ScoreRank.S:
			return "S.png"

func _get_threshold_modifier(rank: ScoreRank):
	match rank:
		ScoreRank.E:
			return 0
		ScoreRank.D:
			return 1
		ScoreRank.C:
			return 1.25
		ScoreRank.B:
			return 1.5
		ScoreRank.A:
			return 1.75
		ScoreRank.S:
			return 2
			
