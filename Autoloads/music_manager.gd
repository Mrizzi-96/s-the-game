extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@export var DEBUG_MODE : bool = Utils.DEBUG_MODE # modify it from Utils

func _ready() -> void:
	if !DEBUG_MODE:
		audio_stream_player.autoplay = true
		audio_stream_player.play()
