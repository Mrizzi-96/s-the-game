extends Control

const WIP_SCENE : String = "uid://xgwpv7t6h6ok"
const ARENA_CHOICE_SCENE: String = "uid://c4yvx7bjrrwf0"

@onready var play : Button = %Play
@onready var quit : Button = %Quit
# Called when the node enters the scene tree for the first time.
func _ready():
	# reset arena count, player and run info
	RunInfo.reset()

func _start_game():
	# use a copy of player_start as ther player data, to avoid using the "prefab". each time we start again, we'll have a different player data resource
	RunInfo.player_data = ResourceLoader.load("res://Resources/Player/player_start.tres").duplicate()
	Global.goto_scene(ARENA_CHOICE_SCENE)

func _on_quit_button_up() -> void:
	Global.quit_game()

func _on_how_to_play_button_up() -> void:
	Global.goto_scene(WIP_SCENE)

func _on_settings_button_up() -> void:
	Global.goto_scene(WIP_SCENE)
