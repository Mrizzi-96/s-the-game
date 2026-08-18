class_name RewardMenu
extends Control

const BASE_RANK_IMG_PATH: String = "res://UI/Assets/Score/"

@onready var rank_texture: TextureRect = %RankTexture
@onready var arena_score_label: Label = %ArenaScoreLabel
@onready var total_score_label: Label = %TotalScoreLabel
@onready var inventory_button: Button = %InventoryButton
@onready var next_arena_button: Button = %NextArenaButton
# TODO: switch to instantiated scene instead of static one
@onready var reward_card: RewardCard = $MarginContainer/HBoxContainer/RewardsContainer/VBoxContainer/RewardCard

@export var final_multiplier:int=1

var reward_type : ArenaParams.RewardType
var total_score : int

func _ready() -> void:
	if RunInfo.arena_counter>10:
		%FinalArenaButton.visible=true
		%NextArenaButton.visible=false
	else:
		%FinalArenaButton.visible=false
		%NextArenaButton.visible=true
	# RunInfo.current_arena_params.reward_type
	# TODO: calculate reward based on type and difficulty.
	update_score_labels()
	update_rank_img()
	await reward_card.ready
	reward_card.update_reward_preview()
	
	
func update_score_labels() -> void:
	# update current score
	arena_score_label.text = str(RunInfo.current_arena_params.arena_score)
	total_score_label.text = str(RunInfo.total_score)

func update_rank_img() -> void:
	var img_path = Utils.get_rank_image(RunInfo.current_arena_params.score_rank)
	if img_path != "":
		var texture : Texture2D = load(BASE_RANK_IMG_PATH.path_join(img_path))
		rank_texture.set_texture(texture)


func _on_next_arena_button_button_up() -> void:
	RunInfo.calculate_next_arena_params()
	Global.goto_scene(RunInfo.current_arena_params.arena_scene)

func _on_inventory_button_button_up() -> void:
	Global.goto_scene("res://Shop/shop.tscn")


func _on_final_arena_button_2_button_up() -> void:
	RunInfo.calculate_final_arena_params()
	Global.goto_scene(RunInfo.current_arena_params.arena_scene)
