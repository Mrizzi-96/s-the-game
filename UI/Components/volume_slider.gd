class_name VolumeSlider extends HSlider

enum AudioBus { MASTER, MUSIC, SFX }

const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "audio"

@export var audio_bus: AudioBus = AudioBus.MASTER
@onready var bus_index : int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(_bus_name())
	value_changed.connect(_on_value_changed)

	# SettingsManager (autoload) applica già il valore salvato all'AudioServer all'avvio
	# del gioco, quindi qui basta riflettere lo stato attuale del bus
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
	_save_value(in_value)

func _save_value(saved_value: float) -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH) # ok anche se il file non esiste ancora
	config.set_value(SETTINGS_SECTION, _bus_name(), saved_value)
	config.save(SETTINGS_PATH)
