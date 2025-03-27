extends Control

@onready var play = %Play
@onready var quit = %Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	quit.pressed.connect(Global.quit_game)

func _start_game():
	# use a copy of player_start as ther player data, to avoid using the "prefab". each time we start again, we'll have a different player data resource
	RunInfo.player_data = ResourceLoader.load("res://Resources/Player/player_start.tres").duplicate()
	Global.goto_scene("res://ArenaChoice/arena_choice.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
