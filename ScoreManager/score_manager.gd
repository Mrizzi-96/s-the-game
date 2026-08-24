class_name ScoreManager
extends Node2D

enum ScoreRank { E, D, C, B, A, S }

# --- Segnali ---
signal multiplier_changed          # il moltiplicatore combo è cambiato (1 -> X)
signal multiplier_reset            # il moltiplicatore è tornato a 1
signal rank_changed(new_rank: ScoreRank)   # il rank è cambiato: pilota SIA visivo SIA suono

# --- Tabelle di lookup (unica fonte di verità, niente match sparsi) ---
const RANK_LABELS := {
	ScoreRank.E: "",
	ScoreRank.D: "Diarrhea",
	ScoreRank.C: "Crappy",
	ScoreRank.B: "Bootyful",
	ScoreRank.A: "Asstounding",
	ScoreRank.S: "ASS",
}

const RANK_IMAGES := {
	ScoreRank.E: "E.png",
	ScoreRank.D: "D.png",
	ScoreRank.C: "C.png",
	ScoreRank.B: "B.png",
	ScoreRank.A: "A.png",
	ScoreRank.S: "S.png",
}

const RANK_THRESHOLD_MODIFIERS := {
	ScoreRank.E: 0.0,
	ScoreRank.D: 1.0,
	ScoreRank.C: 1.25,
	ScoreRank.B: 1.5,
	ScoreRank.A: 1.75,
	ScoreRank.S: 2.0,
}

# Semitoni sopra il pitch base per l'SFX di rank. E non suona; S ha il suo suono dedicato.
const RANK_SEMITONES := {
	ScoreRank.D: 0,   # Do
	ScoreRank.C: 1,   # Do#
	ScoreRank.B: 2,   # Re
	ScoreRank.A: 3,   # Re#
	ScoreRank.S : 4	  # Mi
}

# --- Configurazione da inspector (NON rinominare: i valori sono serializzati nella scena) ---
@export var _time_value_modifiers: Dictionary[float, float]   # key = tempo, value = moltiplicatore
@export var _rank_threesholds: Dictionary[ScoreRank, int]     # soglie base per rank

# --- Riferimenti a nodi (solo questi meritano @onready) ---
@onready var _timer: Timer = $ScoreTimer
@onready var _score_sfx: AudioStreamPlayer = $ScoreSfx

# --- Stato di runtime ---
var _difficulty: int = 1
var _total_time: float = 3.0
var _combo_times: Array[float] = []                       # tempi combo ordinati (cache)
var _scaled_thresholds: Dictionary[ScoreRank, int] = {}   # soglie scalate per arena/difficoltà

var _arena_score: int = 0
var _enemy_count: int = 0
var _enemies_killed_score: int = 0
var _point_accumulator: int = 0
var _last_enemy_time_elapsed: float = 0.0

var _is_combo_active: bool = false
var _current_multiplier: float = 1.0
var _last_rank: ScoreRank = ScoreRank.E


func init(difficulty: int = 1) -> void:
	_difficulty = difficulty
	_time_value_modifiers.sort()
	if not _time_value_modifiers.is_empty():
		_combo_times.assign(_time_value_modifiers.keys())
		_total_time = _combo_times[_combo_times.size() - 1]  # ordinato -> l'ultima chiave è la più grande
	_timer.wait_time = _total_time
	_setup_ranking_thresholds()


func _setup_ranking_thresholds() -> void:
	# Scrive in un dizionario separato invece di mutare l'export:
	# così re-inizializzare un'altra arena non scala di nuovo valori già scalati.
	_scaled_thresholds.clear()
	var arena_scale: float = float(1 + RunInfo.arena_counter) * float(_difficulty)
	for rank in _rank_threesholds:
		var base: int = _rank_threesholds[rank]
		var modifier: float = RANK_THRESHOLD_MODIFIERS.get(rank, 1.0)
		_scaled_thresholds[rank] = int(base * arena_scale * modifier)


# --- Ciclo del combo -----------------------------------------------------------

func add_points(points: int) -> void:
	_point_accumulator += points
	_enemies_killed_score = _point_accumulator

	if not _time_value_modifiers.is_empty():
		_enemy_count += 1

		if _timer.is_stopped():   # primo nemico: parte il combo
			_timer.start()

		if _enemy_count == 2:     # secondo nemico: il combo è valido
			_last_enemy_time_elapsed = _timer.wait_time - _timer.time_left
			if not _is_combo_active:
				_timer.stop()
				_timer.wait_time = _compute_nearest_time(_last_enemy_time_elapsed)
				_timer.start()
				_is_combo_active = true
			var time := _compute_nearest_time(_last_enemy_time_elapsed)
			_set_multiplier(_time_value_modifiers[time])
	else:
		push_warning("ScoreManager: aggiungi dei time value modifiers per abilitare i combo.")

	# Rank valutato UNA volta sola, a stato ormai definitivo (accumulator + moltiplicatore).
	# Da qui partono insieme visivo e suono, cosi' non possono sfasarsi.
	_refresh_rank()


func _on_timer_timeout() -> void:
	_compute_points(_current_multiplier)


func _compute_points(modifier: float) -> void:
	var combo_points: int = floori(modifier * _point_accumulator)
	_arena_score += combo_points
	RunInfo.total_score += combo_points
	_refresh_values()


func _refresh_values() -> void:
	_enemy_count = 0
	_enemies_killed_score = 0
	_point_accumulator = 0
	_last_enemy_time_elapsed = 0.0
	_timer.wait_time = _total_time
	_is_combo_active = false
	_reset_multiplier()
	_refresh_rank()   # i punti sono stati bancati: riallinea anche il rank


func _compute_nearest_time(elapsed: float) -> float:
	# Il piu' piccolo tempo-soglia >= elapsed; se elapsed li supera tutti, il piu' grande.
	var nearest: float = _combo_times[_combo_times.size() - 1]
	for t in _combo_times:
		if elapsed <= t:
			nearest = t
			break
	return nearest


# --- Moltiplicatore (stato + eventi, niente side-effect nei getter) -------------

func _set_multiplier(value: float) -> void:
	if is_equal_approx(_current_multiplier, value):
		return
	_current_multiplier = value
	multiplier_changed.emit()


func _reset_multiplier() -> void:
	if is_equal_approx(_current_multiplier, 1.0):
		return
	_current_multiplier = 1.0
	multiplier_reset.emit()


func get_current_multiplier() -> float:
	return _current_multiplier


# --- Rank + SFX ----------------------------------------------------------------

func get_rank() -> ScoreRank:
	var score := get_arena_score()
	var rank := ScoreRank.E
	for r in ScoreRank.values():   # ordine crescente: vince l'ultima soglia raggiunta
		if _scaled_thresholds.has(r) and score >= _scaled_thresholds[r]:
			rank = r
	return rank


func _refresh_rank() -> void:
	var current := get_rank()
	if current == _last_rank:
		return
	var went_up := current > _last_rank
	_last_rank = current
	rank_changed.emit(current)   # visivo E suono partono dalla STESSA valutazione
	if went_up:
		_play_rank_sfx(current)


func _play_rank_sfx(rank: ScoreRank) -> void:
	if not RANK_SEMITONES.has(rank):
		return   # E non suona
	_score_sfx.pitch_scale = pow(2.0, RANK_SEMITONES[rank] / 12.0)
	_score_sfx.play()


# --- Getter pubblici -----------------------------------------------------------

func get_enemies_killed_score() -> int:
	return _enemies_killed_score


func get_total_score() -> int:
	return RunInfo.total_score


func get_arena_score() -> int:
	# Include i punti del combo in corso (non ancora "bancati" dal timer),
	# cosi' il punteggio mostrato si aggiorna subito all'uccisione.
	return _arena_score + floori(_current_multiplier * _point_accumulator)


func get_current_rank_label() -> String:
	return RANK_LABELS.get(get_rank(), "")


func get_current_rank_image() -> String:
	return RANK_IMAGES.get(get_rank(), "E.png")


func get_rank_progress() -> float:
	var rank := get_rank()
	if rank == ScoreRank.E or rank == ScoreRank.S:
		return 0.0
	var next_rank: ScoreRank = rank + 1
	if not _scaled_thresholds.has(rank) or not _scaled_thresholds.has(next_rank):
		return 0.0
	var current_threshold := _scaled_thresholds[rank]
	var next_threshold := _scaled_thresholds[next_rank]
	if next_threshold <= current_threshold:
		return 0.0
	var progress := float(get_arena_score() - current_threshold) / float(next_threshold - current_threshold)
	return clampf(progress, 0.0, 1.0)
