extends MarginContainer

@onready var play = $VBoxContainer/VBoxContainer/Play
@onready var quit = $VBoxContainer/VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	play.pressed.connect(Global.load_random_arena_scene)
	quit.pressed.connect(Global.quit_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
