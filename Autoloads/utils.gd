extends Node

const MAIN_MENU_SCENE : String = "uid://hp147ctfpi5o"
const WIP_SCENE : String = "uid://xgwpv7t6h6ok"
const ARENA_CHOICE_SCENE: String = "uid://c4yvx7bjrrwf0"
const TEST_SCENE : String = "uid://cv7lkm38tb6o5"
var DEBUG_MODE : bool = false

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
