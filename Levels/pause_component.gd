extends CanvasLayer

@onready var _is_paused: bool = false
@onready var input_blocked : bool = false
@onready var confirmation_overlay: CanvasLayer = %ConfirmationOverlay

func _ready() -> void:
	get_tree().root.process_mode = Node.PROCESS_MODE_PAUSABLE
	# hide canvas layer
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_released("pause") and not input_blocked:
		_is_paused = !_is_paused
		get_tree().paused = _is_paused
		# show/hide canvas layer
		self.visible = _is_paused

func unlock_input():
	self.input_blocked = false
	
func lock_input():
	self.input_blocked = true

func _on_play_button_up() -> void:
	_is_paused = false
	self.visible = _is_paused
	get_tree().paused = _is_paused


func _on_quit_button_up() -> void:
	confirmation_overlay.visible = true
	lock_input()
