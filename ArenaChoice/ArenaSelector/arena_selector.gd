class_name ArenaSelector extends Button

@export var preview_scene : PackedScene
@export_category("Difficulty params")
@export var difficulty_texture: Texture

var preview: SubViewport
var difficulty_container: HBoxContainer
var reward_label: Label
var arena_params : ArenaParams = ArenaParams.new()

const REWARD_LABEL_OFFSET_Y : float = 7
var is_toggled : bool
	
func initialise(difficulty : int, arena_path : String, reward_type : ArenaParams.RewardType) -> void:
	difficulty_container = $DifficultyContainer
	reward_label = $RewardContainer/RewardLabel
	preview = $PreviewContainer/Preview
	load_difficulty(difficulty)
	load_reward(reward_type)
	load_arena_preview(arena_path)

func load_reward(reward_type : ArenaParams.RewardType) -> void:
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

func load_arena_preview(arena_path : String):
	if not preview:
		return
	preview_scene = load(arena_path)
	if not preview_scene:
		push_warning("No preview scene selected!")
		return
	for child in preview.get_children():
		child.queue_free()
	var preview_instance = preview_scene.instantiate()
	preview_instance.is_preview = true
	preview.add_child(preview_instance)
	
func _on_toggled(toggled_on: bool) -> void:
	is_toggled = toggled_on
	# if toggled on, pass current arena params to the RunInfo
	RunInfo.current_arena_params = arena_params

func _on_mouse_entered():
	if not is_toggled:
		reward_label.position.y += REWARD_LABEL_OFFSET_Y

func _on_mouse_exited() -> void:
	if not is_toggled:
		reward_label.position.y -= REWARD_LABEL_OFFSET_Y
