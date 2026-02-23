extends Node2D

var sound_effect_dict = {}
@export var sound_effect_settings: Array[SoundEffectSettings]

func _ready() -> void:
	for sound_effect_setting : SoundEffectSettings in sound_effect_settings:
		sound_effect_dict[sound_effect_setting.type] = sound_effect_setting
	register_audio_button_triggers()
		
func register_audio_button_triggers() -> void:
	# called once each loading screen
	# ALL buttons in group must do the fart sound
	var buttons: Array = get_tree().get_nodes_in_group("Buttons")
	for inst : Button in buttons:
		if not inst.is_connected("button_up", _on_button_down):
			inst.button_up.connect(_on_button_down)

func _on_button_down() -> void:
	self.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.UI_BUTTON_PRESS)

func create_2d_audio_at_location(location, type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if !sound_effect_dict.has(type):
		push_error("Audio Manager failed to find setting for type ", type)
	else:
		var sound_effect_setting : SoundEffectSettings = sound_effect_dict[type]
		if	sound_effect_setting.has_open_limit():
			sound_effect_setting.set_audio_count(1)
			var new_audio = AudioStreamPlayer2D.new()
			self.add_child(new_audio)
			new_audio.position = location
			new_audio.stream = sound_effect_setting.get_random_source()
			new_audio.volume_db = sound_effect_setting.volume
			new_audio.pitch_scale = sound_effect_setting.pitch_scale
			#-sound_effect_setting.pitch_randomness
			#new_audio.pitch_scale = randf_range(0.0, 5.0)#sound_effect_setting.pitch_randomness)
			new_audio.finished.connect(sound_effect_setting.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			
			new_audio.play()

func create_audio(type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if !sound_effect_dict.has(type):
		push_error("Audio Manager failed to find setting for type ", type)
	else:
		var sound_effect_setting : SoundEffectSettings = sound_effect_dict[type]
		if	sound_effect_setting.has_open_limit():
			sound_effect_setting.set_audio_count(1)
			var new_audio = AudioStreamPlayer.new()
			self.add_child(new_audio)
			new_audio.stream = sound_effect_setting.get_random_source()
			new_audio.volume_db = sound_effect_setting.volume
			new_audio.pitch_scale = sound_effect_setting.pitch_scale
			#-sound_effect_setting.pitch_randomness
			#new_audio.pitch_scale = randf_range(0.0, 5.0)#sound_effect_setting.pitch_randomness)
			new_audio.finished.connect(sound_effect_setting.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			
			new_audio.play()
