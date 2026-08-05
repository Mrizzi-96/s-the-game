class_name ScoreView
extends Control

const MAX_LABEL_ROTATION : float = 0
const MIN_LABEL_ROTATION : float = 0.2
const BASE_RANK_IMG_PATH: String = "res://UI/Assets/Score/"

@export var score_manager: ScoreManager

@export var fill_tween_duration : float = 0.4

@onready var rank_image: TextureRect  = %RankImage
@onready var _rank_fill_material : ShaderMaterial = rank_image.material

var _fill_tween : Tween
var _current_rank : ScoreManager.ScoreRank = ScoreManager.ScoreRank.E
var _fill_target : float = -1.0  # sentinel: nessun target ancora impostato
@onready var total_score_label = %TotalScoreLabel
@onready var enemy_score_label = %EnemyScoreLabel
@onready var mult_label = %MultiplierLabel
@onready var arena_score_label = %ArenaScoreLabel
@onready var rank_label = %RankLabel

func _ready():
	var rng = RandomNumberGenerator.new()
	var rot = rng.randf_range(MIN_LABEL_ROTATION, MAX_LABEL_ROTATION)
	_rotate_label(mult_label, rot)
	_rotate_label(enemy_score_label, rot)
	_rotate_label(arena_score_label, rot)
	_reset_label_values()
	score_manager.multiplier_changed.connect(_on_multiplier_changed)
	score_manager.multiplier_reset.connect(_on_multiplier_reset)

func _reset_label_values():
	rank_label.text = ""
	arena_score_label.text = "0"
	mult_label.text = "x 1"
	mult_label.hide()
	enemy_score_label.text = ""
	if score_manager != null:
		if score_manager.get_total_score() == 0:
			total_score_label.text = "TS: 0"

func _process(_delta: float) -> void:
	# TODO: move to signals
	if(score_manager != null):
		_update_score_labels()
		_update_rank_img()

func _update_score_labels():
	var enemies_killed_score = score_manager.get_enemies_killed_score()
	enemy_score_label.text = "+ %s" % str(enemies_killed_score) if enemies_killed_score != 0 else "" 
	arena_score_label.text = "%s" % str(score_manager.get_arena_score())
	mult_label.text = "x %s" % str(score_manager.get_current_multiplier())
	rank_label.text = "%s" % str(score_manager.get_current_rank_label())
	total_score_label.text = "TS: %s" % str(score_manager.get_total_score())

func _update_rank_img():
	var img_path = score_manager.get_current_rank_image()
	if img_path != "":
		var texture : Texture2D = load(BASE_RANK_IMG_PATH.path_join(img_path))
		rank_image.set_texture(texture)
	_update_rank_fill()

func _update_rank_fill():
	var rank = score_manager.get_rank()
	if rank == ScoreManager.ScoreRank.E or rank == ScoreManager.ScoreRank.S:
		rank_image.material = null
		_current_rank = rank
		_fill_target = -1.0
		return

	rank_image.material = _rank_fill_material

	if rank != _current_rank:
		# nuova lettera: azzera subito il riempimento, senza tween
		_current_rank = rank
		if _fill_tween:
			_fill_tween.kill()
		_rank_fill_material.set_shader_parameter("progress", 0.0)
		_fill_target = -1.0

	var progress = score_manager.get_rank_progress()
	if not is_equal_approx(progress, _fill_target):
		_fill_target = progress
		if _fill_tween:
			_fill_tween.kill()
		_fill_tween = create_tween()
		_fill_tween.set_ease(Tween.EASE_OUT)
		_fill_tween.set_trans(Tween.TRANS_CUBIC)
		_fill_tween.tween_property(_rank_fill_material, "shader_parameter/progress", progress, fill_tween_duration)

func _rotate_label(label : Label, rot : float):
	label.rotation_degrees = rad_to_deg(rot)

func _on_multiplier_reset():
	mult_label.hide()

func _on_multiplier_changed():
	mult_label.show()
