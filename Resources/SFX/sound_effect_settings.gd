### This class is used for adding global sound effects to the game
class_name SoundEffectSettings extends Resource

enum SOUND_EFFECT_TYPE {
	ON_WEAPON_SHOOT,
	ON_ENEMY_HIT,
	ENEMY_JUMP,
	ITEM_BOUGHT,
	UI_BUTTON_PRESS,
	ON_SLASHING_WEAPON_EQUIP,
	ON_SHOOTING_WEAPON_EQUIP,
	ON_ENEMY_DEATH
}

@export_range(0,10) var limit : int = 5
@export var type : SOUND_EFFECT_TYPE
@export var sources : Array[AudioStream]
@export_range(-40, 20) var volume = 0
@export_range(0.0,4.0,.01) var pitch_scale = 1.0
@export_range(0.0,1.0,.01) var pitch_randomness = 0.0

var _audio_count = 0

## returns a random AudioStream in the sources array to the caller.
func get_random_source() -> AudioStream:
	if sources.is_empty():
		return null
	return sources[randi_range(0, sources.size() - 1)]

func set_audio_count(amount : int):
	_audio_count = max(0, _audio_count + amount)
	
func has_open_limit() -> bool:
	return _audio_count < limit

func on_audio_finished():
	set_audio_count(-1)	
