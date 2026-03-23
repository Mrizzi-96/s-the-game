extends Control

var phase:String=""
var selected_arena=false

@export var difficulty:Array[Texture2D] = []
@onready var arena_params = ArenaParams.new()
@onready var selector_container: HBoxContainer = $SelectorContainer
@onready var shop_button: Button = $Shop

const CHOICES_NUM : int = 3

var difficulty_variant = {
	"phase_1": {1: 70, 2: 25, 3: 5},
	"phase_2": {1: 50, 2: 30, 3: 20},
	"phase_3": {1: 20, 2: 50, 3: 30},
	"phase_4": {1: 10, 2: 50, 3: 40},
	"phase_5": {1: 5, 2: 25, 3: 70},
	"phase_6": {1: 0, 2: 0, 3: 100}
}

var phase_thresholds = [
	{ "limit": 20, "phase": "phase_1" },
	{ "limit": 50, "phase": "phase_2" },
	{ "limit": 80, "phase": "phase_3" },
	{ "limit": 120, "phase": "phase_4" },
	{ "limit": 200, "phase": "phase_5" },
]
	
func _ready():
	# initialize arena params
	arena_params.difficulty = 1
	RunInfo.current_arena_params = arena_params
	# setup money
	$Money/TotalMoney.text=str(RunInfo.player_data.gold)
	# initialize arena counter 
	$ArenaCounter.text="Arena %s:" % str(RunInfo.arena_counter)
	# set arena phase
	phase = match_phase()
	# initialise arena selectors
	_init_arena_selectors()

func _init_arena_selectors():
	for i in range(1, CHOICES_NUM + 1):
		# set difficulty
		var difficulty_value = _set_arena_difficulty(phase)
		# initialize arena selector
		var arena_selector = load("uid://cqi2f1edijnvs") # "res://ArenaChoice/ArenaSelector/arena_selector.tscn"
		var selector_instance : ArenaSelector = arena_selector.instantiate()
		selector_container.add_child(selector_instance)
		# finally initialise arena path (random from 0 to 3)
		# TODO: choose path using pools and levels based on current player progression
		var arena_path : String = "res://Levels/arena%d" % randi_range(1,RunInfo.arena_playable) +".tscn"
		selector_instance.initialise(difficulty_value, arena_path, i)
		# connect to signal to handle continue button
		selector_instance.arena_selected.connect(_on_arena_selected)

func match_phase()-> String:
	# TODO: use filter() to avoid cycling through all phases ?
	# new version make a cicle inside a list and check the first that match the number of arena
	for entry in phase_thresholds:
		if RunInfo.arena_counter < entry.limit:
			print(entry.phase)
			return entry.phase
	return "phase_6"

# TODO: move to difficulty calculator component && return single number
func _set_arena_difficulty(phase: String) -> int:
	var chances = difficulty_variant.get(phase)
	var pool = []
	for i in range(int(chances[1])):
		pool.append(1)
	for i in range(int(chances[2])):
		pool.append(2)
	for i in range(int(chances[3])):
		pool.append(3)
	pool.shuffle()
	return pool[randi() % pool.size()]

func _on_arena_selected(arena_selector : ArenaSelector) -> void:
	selected_arena = true
	RunInfo.current_arena_params = arena_selector.arena_params
	# activate continue button
	#shop_button.visible = true
	#shop_button.disabled = false
	Global.goto_scene(RunInfo.current_arena_params.arena_scene)
