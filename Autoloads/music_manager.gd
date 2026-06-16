extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	audio_stream_player.autoplay = !Utils.DEBUG_MODE
