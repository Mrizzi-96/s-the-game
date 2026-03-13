extends Node

## returns the reward name as a string.
func get_reward_name(value: int) -> String:
	return ArenaParams.RewardType.keys()[value]

func get_rank_image(value : RankItem.ScoreRank) -> String:
	match value:
		RankItem.ScoreRank.E:
			return ""
		RankItem.ScoreRank.D:
			return "D.png"
		RankItem.ScoreRank.C:
			return "C.png"
		RankItem.ScoreRank.B:
			return "B.png"
		RankItem.ScoreRank.A:
			return "A.png"
		RankItem.ScoreRank.S:
			return "S.png"
	return ""
