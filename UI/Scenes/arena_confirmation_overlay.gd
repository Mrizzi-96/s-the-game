extends CanvasLayer

@onready var pause_component: CanvasLayer = $"../PauseComponent"

func _on_yes_button_button_up() -> void:
	get_tree().paused = false
	Global.goto_scene(Utils.MAIN_MENU_SCENE)


func _on_no_button_button_up() -> void:
	self.visible = false
	pause_component.unlock_input()
