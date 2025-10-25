class_name ArenaParams extends Resource

enum RewardType {
    NONE = 0,
    WEAPON = 1,
    GOLD = 2,
    SKILL = 3
}

@export var arena_preview: Image
@export var arena_scene: PackedScene
@export var difficulty : int
@export var reward_type : RewardType
