class_name VolumeSlider extends HSlider

enum AudioBus { MASTER, MUSIC, SFX }

@export var audio_bus: AudioBus = AudioBus.MASTER
@onready var bus_index : int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(_bus_name())
	value_changed.connect(_on_value_changed)
	
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)
	
func _bus_name() -> String:
	match audio_bus:
		AudioBus.MASTER: return "Master"
		AudioBus.MUSIC:  return "music"
		AudioBus.SFX:    return "sfx"
	return "Master"
	
func _on_value_changed(in_value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(in_value) # convert slider value to db to avoid errors
	)
