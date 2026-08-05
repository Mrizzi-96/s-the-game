class_name PropellerVFX extends Node2D
@onready var bubbles_trail: CPUParticles2D = $BubblesTrail
@onready var bubbles_trail_bg: CPUParticles2D = $BubblesTrailBG
@onready var bubbles_sprouts: CPUParticles2D = $BubblesSprouts

func _ready() -> void:
	stop_bubbles()

func start_bubbles():
	bubbles_trail.emitting = true
	bubbles_trail_bg.emitting = true
	#bubbles_sprouts.emitting = true

func stop_bubbles():
	bubbles_trail.emitting = false
	bubbles_trail_bg.emitting = false
	#bubbles_sprouts.emitting = false
