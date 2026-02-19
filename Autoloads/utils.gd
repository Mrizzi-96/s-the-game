extends Node

## returns the reward name as a string.
func get_reward_name(value: int) -> String:
	return ArenaParams.RewardType.keys()[value]
