extends Node2D

@export var flash_color: Color = Color(1.0, 0.9, 0.4, 1.0)
@export var flash_size: float = 64.0
@export var flash_duration: float = 0.06

const TEX_SIZE: int = 128

@onready var flash: Sprite2D = $Flash
@onready var particles: GPUParticles2D = $GPUParticles2D

func fire(direction: Vector2 = Vector2.RIGHT) -> void:	
	particles.restart()
	particles.emitting = true
