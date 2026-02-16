extends Control

var phase:String=""
var selected_arena=false
@export var color:Color
@onready var arena1=$ArenaSelector/Arena1
@onready var arena2=$ArenaSelector/Arena2
@onready var arena3=$ArenaSelector/Arena3
@onready var bg_arena1=$ArenaSelector/BgArena1
@onready var bg_arena2=$ArenaSelector/BgArena2
@onready var bg_arena3=$ArenaSelector/BgArena3
@export var difficulty:Array[Texture2D] = []
@onready var arena_params = ArenaParams.new()


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
	# stub data for preview visibility
	arena_params.difficulty=1
	RunInfo.current_arena_params = arena_params
	################################################
	$Money/TotalMoney.text=str(RunInfo.player_data.gold)
	#start initialize arena number and decided phase for new choice difficulty 
	$ArenaNumber.text="Arena "+str(RunInfo.arena_counter)+":"
	phase=match_phase()
	# initialise arenas
	_init_arena_selectors()

func _init_arena_selectors():
	for i in range(3):
		select_arena(i+1)

func select_arena(i:int):
	var arena = get_node("ArenaSelector/Arena%d" % i)
	var arenaBg = get_node("ArenaSelector/BgArena%d" % i)
	var difficulty_value = _set_arena_difficulty(phase)
	arena.difficulty=difficulty_value
	arena.select_path(str(randi_range(1,RunInfo.arena_playable)))
	# TODO: pass difficulty to ArenaSelector.initialise()
	match difficulty_value:
		1:
			arenaBg.texture=difficulty[0]
		2:
			arenaBg.texture=difficulty[1]
		3:
			arenaBg.texture=difficulty[2]

func match_phase()-> String:
	# TODO: use LINQ - style 
	# new version make a cicle inside a list and check the first that match the number of arena
	for entry in phase_thresholds:
		if RunInfo.arena_counter < entry.limit:
			print(entry.phase)
			return entry.phase
	return "phase_6"
	# old version
	#if RunInfo.arenanumber<20:
		#return "phase_1"
	#elif RunInfo.arenanumber<50:
		#return "phase_2"
	#elif RunInfo.arenanumber<80:
		#return "phase_3"
	#elif RunInfo.arenanumber<120:
		#return "phase_4"
	#elif RunInfo.arenanumber<200:
		#return "phase_5"
	#else:
		#return "phase_6"

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

func shop():
	if selected_arena:
		Global.goto_scene("res://Shop/shop.tscn")

func set_arena_choice(bgbutton : TextureRect, button : Button, arena_path : String, color: Color,reward_type):
	selected_arena=true
	bgbutton.modulate=color
	arena_params.arena_scene = arena_path
	arena_params.difficulty = button.difficulty
	arena_params.reward_type = reward_type
	RunInfo.current_arena_params = arena_params
	print(RunInfo.current_arena_params)

func reset_arena_choice(bgbutton : TextureRect, bgbutton2 : TextureRect, button : Button, button2 : Button, color: Color):
	bgbutton.modulate=color
	bgbutton2.modulate=color
	button.is_active=false
	button2.is_active=false

func _on_arena_1_pressed():
	if arena1.is_active==false:
		arena1.is_active=true
		var arena_path = $ArenaSelector/Arena1.arena_path
		var reward_type=ArenaParams.RewardType.WEAPON
		print("ho selezionato da arena weapon: ", arena_path)
		reset_arena_choice(bg_arena2,bg_arena3,arena2,arena3,Color(1, 1, 1))
		set_arena_choice(bg_arena1, arena1, arena_path , color,reward_type)

func _on_arena_2_pressed():
	if arena2.is_active==false:
		arena2.is_active=true
		var arena_path = arena2.arena_path
		var reward_type=ArenaParams.RewardType.GOLD
		print("ho selezionato da arena gold : ", arena_path)
		reset_arena_choice(bg_arena1,bg_arena3,arena1,arena3,Color(1, 1, 1))
		set_arena_choice(bg_arena2,arena2, arena_path , color,reward_type)

func _on_arena_3_pressed():
	if arena3.is_active==false:
		arena3.is_active=true
		var arena_path = arena3.arena_path
		var reward_type=ArenaParams.RewardType.SKILL
		print("ho selezionato da arena ability: ", arena_path)
		reset_arena_choice(bg_arena2, bg_arena1, arena2, arena1, Color(1, 1, 1))
		set_arena_choice(bg_arena3, arena3, arena_path , color,reward_type)
