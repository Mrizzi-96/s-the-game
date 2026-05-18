extends Control

@onready var play = %Play
@onready var quit = %Quit

@export var DEBUG_MODE:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(not DEBUG_MODE):
		%Test.queue_free()
	quit.pressed.connect(quit_game)
	# reset arena count, player and run info
	RunInfo.reset()

func _start_game():
	# use a copy of player_start as ther player data, to avoid using the "prefab". each time we start again, we'll have a different player data resource
	RunInfo.player_data = ResourceLoader.load("res://Resources/Player/player_start.tres").duplicate()
	Global.goto_scene("res://ArenaChoice/arena_choice.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func quit_game():
	Global.quit_game()



func _on_test_pressed() -> void:
	RunInfo.player_data = ResourceLoader.load("res://Resources/Player/player_start.tres").duplicate()
	RunInfo.current_arena_params=ArenaParams.new()
	Global.goto_scene("res://Levels/arena_test.tscn")
