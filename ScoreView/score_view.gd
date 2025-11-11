class_name ScoreView
extends Control

const MAX_LABEL_ROTATION : float = 0
const MIN_LABEL_ROTATION : float = 0.2
const BASE_RANK_IMG_PATH: String = "res://UI/Assets/Score/"

@export var score_manager: ScoreManager

@onready var rank_image: TextureRect  = %RankImage
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

func _reset_label_values():
	rank_label.text = ""
	arena_score_label.text = "0"
	mult_label.text = "x 1"
	enemy_score_label.text = ""
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

func _rotate_label(label : Label, rot : float):
	label.rotation_degrees = rad_to_deg(rot)
