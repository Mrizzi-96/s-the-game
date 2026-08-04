extends Node2D

@onready var _mesh: MeshInstance2D = $MeshInstance2D
@onready var _anim_player: AnimationPlayer = $AnimationPlayer

var _base_rotation : float
var _base_scale : Vector2

func _ready() -> void:
	visible = false
	_base_rotation = _mesh.rotation
	_base_scale = _mesh.scale
	_anim_player.animation_finished.connect(_on_animation_finished)

func play(clockwise: bool = true) -> void:
	if clockwise:
		_mesh.rotation = _base_rotation
		_mesh.scale = _base_scale
	else:
		_mesh.rotation = _base_rotation + PI
		_mesh.scale = Vector2(-_base_scale.x, _base_scale.y)
	visible = true
	_anim_player.stop()
	_anim_player.play(&"Slash", -1, 2.0)

func _on_animation_finished(_anim_name: StringName) -> void:
	visible = false
