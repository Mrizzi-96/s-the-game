extends Control

@onready var proceed_button: Button = %ProceedButton

func _ready() -> void:
	match SceneManager.scene_origin:
		SceneManager.Origin.MAIN_MENU_HOW_TO_PLAY:
			proceed_button.text = "Main menu"
		SceneManager.Origin.MAIN_MENU_START_GAME:
			proceed_button.text = "Start game"
		SceneManager.Origin.PAUSE_COMPONENT:
			proceed_button.text = "Go back"
		_:
			proceed_button.text = "Main menu"  # fallback

func _on_proceed_button_up() -> void:
	match SceneManager.scene_origin:
		SceneManager.Origin.MAIN_MENU_HOW_TO_PLAY:
			SceneManager.scene_origin = SceneManager.Origin.NONE
			SceneManager.load_new_scene(Utils.MAIN_MENU_SCENE)
		SceneManager.Origin.MAIN_MENU_START_GAME:
			SceneManager.scene_origin = SceneManager.Origin.NONE
			# reset and go to first arena
			RunInfo.reset()
			SceneManager.load_new_scene(RunInfo.current_arena_params.arena_scene)
		# for pause component, we simply hide this menu 
		SceneManager.Origin.PAUSE_COMPONENT:
			self.visible = false
		_:
			# fallback
			SceneManager.scene_origin = SceneManager.Origin.NONE
			SceneManager.load_new_scene(Utils.MAIN_MENU_SCENE)
