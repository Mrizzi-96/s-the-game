class_name ArenaParams extends Resource

enum RewardType {
	NONE = 0,
	WEAPON = 1,
	GOLD = 2,
	SKILL = 3
}

@export var arena_preview: Image
@export var arena_scene: String
@export var difficulty : int=1
@export var reward_type : RewardType
