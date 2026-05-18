extends Control

const WIP_SCENE : String = "uid://xgwpv7t6h6ok"
const ARENA_CHOICE_SCENE: String = "uid://c4yvx7bjrrwf0"
@onready var confirmation_overlay: CanvasLayer = %ConfirmationOverlay

@onready var play : Button = %Play
@onready var quit : Button = %Quit
# Called when the node enters the scene tree for the first time.
func _ready():
@export var DEBUG_MODE:bool=false

@export var DEBUG_MODE:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(not DEBUG_MODE):
		%Test.queue_free()
	# reset arena count, player and run info
	RunInfo.reset()

func _start_game():
	# use a copy of player_start as ther player data, to avoid using the "prefab". each time we start again, we'll have a different player data resource
	RunInfo.player_data = ResourceLoader.load("res://Resources/Player/player_start.tres").duplicate()
	Global.goto_scene(ARENA_CHOICE_SCENE)

func _on_quit_button_up() -> void:
	confirmation_overlay.visible = true

func _on_how_to_play_button_up() -> void:
	Global.goto_scene(WIP_SCENE)

func _on_settings_button_up() -> void:
	Global.goto_scene(WIP_SCENE)

func _on_yes_button_button_up() -> void:
	Global.quit_game()

func _on_no_button_button_up() -> void:
	confirmation_overlay.visible = false


func _on_test_pressed() -> void:
	# Load the player data from the resource file, duplicate it to avoid modifying the original resource, and assign it to RunInfo.player_data. Then, create a new instance of ArenaParams and assign it to RunInfo.current_arena_params. Finally, navigate to the arena test scene.
	RunInfo.player_data = ResourceLoader.load("res://Resources/Player/player_start.tres").duplicate()
	RunInfo.current_arena_params=ArenaParams.new()
	Global.goto_scene("res://Levels/arena_test.tscn")
