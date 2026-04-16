extends Node2D

@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	particles.restart()
	particles.emitting = true
	
	await get_tree().create_timer(particles.lifetime + 0.1).timeout
	queue_free()
