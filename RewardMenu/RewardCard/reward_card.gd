class_name RewardCard extends Control

@export var item_data : ItemData

@onready var reward_image: TextureRect = %RewardImage
@onready var reward_name: Label = %RewardName
const BASE_GOLD_AMOUNT : int = 300

func _ready() -> void:
	update_reward_preview()

func update_reward_preview() -> void:
	# for now, calculate reward based on randomness and difficulty
	# TODO: calculate correct reward with the right algorithm
	var reward_type = RunInfo.current_arena_params.reward_type
	match reward_type:
		ArenaParams.RewardType.WEAPON:
			var p_data = RunInfo.player_data
			var player_weapons = p_data.get_inventory().filter(func (i): return i.type == ItemData.Type.WEAPON)
			var all_weapons = RunInfo.items.filter(func(w : ItemData): return w.type == ItemData.Type.WEAPON)
			# get randomized weapon which the player doesn't have
			var reward_candidates : Array[ItemData] = all_weapons.filter(func(i): return i not in player_weapons)
			if reward_candidates.size() == 0:
				# use placeholder
				reward_image.texture = load("res://Weapons/Assets/gun_locked.png")
				reward_name.text = "Coming soon!"
				pass
			else:
				# set rewardImage
				var candidate = reward_candidates[randi_range(0, reward_candidates.size() -1)]
				reward_image.texture = candidate.texture
				reward_name.text = candidate.name.capitalize()
				# NOTE: add reward to player's inventory
				p_data.add_to_inventory(candidate)
		ArenaParams.RewardType.GOLD:
			# set gold image
			reward_image.texture = load("res://Shop/Assets/butt coin.png")
			# starting from 300 (base gold), we add a .3 percentage per level * difficulty modifier
			var arena_counter = RunInfo.arena_counter
			var arena_counter_rate = .3 * arena_counter
			var difficulty = RunInfo.current_arena_params.difficulty
			var difficulty_modifier = get_gold_difficulty_modifier(difficulty)
			var gold_reward_amount : int = round(BASE_GOLD_AMOUNT + (BASE_GOLD_AMOUNT * arena_counter_rate)) * difficulty_modifier
			# label
			reward_name.text = "+%s G." % str(gold_reward_amount)
			# NOTE: add gold to player's reserve
			RunInfo.player_data.gold += gold_reward_amount
		ArenaParams.RewardType.SKILL:
			# TODO: get skill reward
			reward_image.texture = load("res://Weapons/Assets/gun_locked.png")
			reward_name.text = "Coming soon!"
			# TODO: add skill to player
		
func get_gold_difficulty_modifier(difficulty : int)-> float:
	var rank : RankItem.ScoreRank = RunInfo.current_arena_params.score_rank
	match rank:
		RankItem.ScoreRank.D:
			if difficulty == 1:
				return 1
			elif difficulty == 2:
				return 1.1
			else:
				# diff = 3
				return 1.3
		RankItem.ScoreRank.C:
			if difficulty == 1:
				return 1.1
			elif difficulty == 2:
				return 1.3
			else:
				# diff = 3
				return 1.5
		RankItem.ScoreRank.B:
			if difficulty == 1:
				return 1.3
			elif difficulty == 2:
				return 1.5
			else:
				# diff = 3
				return 2
		RankItem.ScoreRank.A:
			if difficulty == 1:
				return 1.5
			elif difficulty == 2:
				return 2
			else:
				# diff = 3
				return 3
		RankItem.ScoreRank.S:
			if difficulty == 1:
				return 2
			elif difficulty == 2:
				return 3
			else:
				# diff = 3
				return 4
	return 1
