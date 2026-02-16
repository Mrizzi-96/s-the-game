extends Control

## Number of selectors to show (default: 3)
@export_range(1, 3) var selectors_to_show: int

@onready var arena_selector_scene : PackedScene = preload("uid://cqi2f1edijnvs")

func _ready() -> void:
	for i in selectors_to_show:
		# instantiate new selector
		var s : ArenaSelector = arena_selector_scene.instantiate()
		# setup
		s.initialise()
