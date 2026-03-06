extends CanvasLayer

@onready var _is_paused: bool = false

func _ready() -> void:
	get_tree().root.process_mode = Node.PROCESS_MODE_PAUSABLE
	# hide canvas layer
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_released("pause"):
		_is_paused = !_is_paused
		get_tree().paused = _is_paused
		# show/hide canvas layer
		self.visible = _is_paused


func _on_resume_button_up() -> void:
	_is_paused = false
	self.visible = _is_paused
	get_tree().paused = _is_paused


func _on_main_menu_button_up() -> void:
	get_tree().paused = false
	Global.goto_scene("uid://hp147ctfpi5o")
