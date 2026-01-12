extends CanvasLayer

@onready var _is_paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	# hide canvas layer
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_released("pause"):
		_is_paused = !_is_paused
		get_tree().paused = _is_paused
		# show/hide canvas layer
		self.visible = _is_paused
