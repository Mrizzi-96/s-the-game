class_name ScoreView
extends Control

@export var score_manager:ScoreManager

@onready var score_label=$ScoreLabel

@onready var modifier_label=$ModifierLabel

@onready var rank_label=$RankLabel

func _process(delta: float) -> void:
	if(score_manager!=null):
		score_label.text=str(score_manager.get_total_points())
		modifier_label.text=str(score_manager.get_current_modifier())
		rank_label.text=str(score_manager.get_current_rank())
