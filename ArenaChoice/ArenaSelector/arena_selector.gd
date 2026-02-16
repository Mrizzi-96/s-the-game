class_name ArenaSelector extends Button

@export var preview_scene : PackedScene
@export_category("Difficulty params")
@export var difficulty_texture: Texture

@onready var preview: SubViewport = $PreviewContainer/Preview
@onready var difficulty_container: HBoxContainer = $DifficultyContainer
@onready var reward_label: Label = $RewardContainer/RewardLabel
@onready var arena_params = ArenaParams.new()


# TODO: initialise arena params
func initialise(difficulty : int, arena_path : String,reward_type) -> void:
	load_difficulty(difficulty)
	load_reward(reward_type)
	load_arena_preview()

func load_reward(reward_type) -> void:
	# set reward type && label text
	arena_params.reward_type = reward_type
	reward_label.text = str(reward_type) if reward_type else "NO REWARD SET"

func load_difficulty(difficulty: int) -> void:
	if not difficulty_texture:
		# fallback to basic one
		difficulty_texture = load("uid://codp34uklb815")
	# one textureRect foreach difficulty && set texture settings
	for i in range(difficulty):
		var texture_rect : TextureRect = TextureRect.new()
		texture_rect.texture = difficulty_texture
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		difficulty_container.add_child(texture_rect)

func load_arena_preview():
	if not preview:
		return
	if not preview_scene:
		push_warning("No preview scene selected!")
		return
	for child in preview.get_children():
		child.queue_free()
	var preview_instance = preview_scene.instantiate()
	preview.add_child(preview_instance)
	


func _on_toggled(toggled_on: bool) -> void:
	# if toggled on, pass current arena params to the RunInfo
	RunInfo.current_arena_params = arena_params
