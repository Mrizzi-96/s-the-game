class_name PauseComponent extends CanvasLayer

@onready var _is_paused: bool = false
@onready var _input_blocked : bool = false
@onready var confirmation_overlay: CanvasLayer = %ConfirmationOverlay
@onready var controls_scene: Control = %Controls
@onready var settings_scene: Control = %SettingsMenu

func _ready() -> void:
	get_tree().root.process_mode = Node.PROCESS_MODE_PAUSABLE
	SceneManager.scene_origin = SceneManager.Origin.PAUSE_COMPONENT
	# initialise return buttons
	controls_scene.init()
	settings_scene.init()
	# hide canvas layer and controls scene
	self.visible = false
	controls_scene.visible = false
	# When instantiated, cannot open until arena countdown ends
	lock_input()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("pause") and not _input_blocked:
		_is_paused = !_is_paused
		get_tree().paused = _is_paused
		# show/hide canvas layer
		self.visible = _is_paused
		if not _is_paused:
			# always hide controls and settings menu when not paused (i.e. player presses pause action while in settings)
			controls_scene.visible = false
			settings_scene.visible = false

func unlock_input():
	_input_blocked = false
	
func lock_input():
	_input_blocked = true

func _on_play_button_up() -> void:
	_is_paused = false
	self.visible = _is_paused
	get_tree().paused = _is_paused
	
func _on_quit_button_up() -> void:
	confirmation_overlay.visible = true
	lock_input()

func _on_how_to_play_button_up() -> void:
	# set origin to pause
	SceneManager.scene_origin = SceneManager.Origin.PAUSE_COMPONENT
	controls_scene.visible = true


func _on_settings_button_up() -> void:
	# set origin to pause
	SceneManager.scene_origin = SceneManager.Origin.PAUSE_COMPONENT
	settings_scene.visible = true
