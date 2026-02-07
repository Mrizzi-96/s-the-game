class_name LoadingScreen extends CanvasLayer

const DEFAULT_ANIMATION_TO_NAME : String = "fade_to_black"
const DEFAULT_ANIMATION_FROM_NAME : String = "fade_from_black"

signal transition_in_complete

@onready var progress_bar : ProgressBar = %ProgressBar
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var timer: Timer = $Timer

var starting_animation_name : String

func _ready() -> void:
	progress_bar.visible = false

func start_transition(animation_name : String) -> void:
	if !animation_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist!" % animation_name)
		animation_name = DEFAULT_ANIMATION_TO_NAME
	starting_animation_name = animation_name
	animation_player.play(animation_name)
	
	# if timer reaches the end before finishing loading, show progress bar
	timer.start()

func update_bar(val : float) -> void:
	progress_bar.value = val

# called by SceneManager to play the outro to the transition once the content is loaded
func finish_transition() -> void:
	if timer:
		timer.stop()
	# construct 2nd half of transition's animation name
	var ending_animation_name: String = starting_animation_name.replace("to", "from")
	
	if !animation_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist!" % ending_animation_name)
		ending_animation_name = DEFAULT_ANIMATION_FROM_NAME
	animation_player.play(ending_animation_name)
	
	# once the final animation plays, we can free this scene
	await animation_player.animation_finished
	queue_free()

# reports the mid point between the animations
func report_midpoint() -> void:
	transition_in_complete.emit()

func _on_timer_timeout() -> void:
	progress_bar.visible = true
