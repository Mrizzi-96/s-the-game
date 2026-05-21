extends Node
'''
Handles all scene transitions by adding a loading screen, playing the animations passed as strings.
'''
signal content_finished_loading(content)
signal content_invalid(content_path : String)
signal content_failed_to_load(content_path : String)


var loading_screen : LoadingScreen
var _loading_screen_scene : PackedScene = preload("uid://dg40k88jovfp8")
var _transition : String
var _content_path : String
var _load_progress_timer : Timer

## defines the origin point of the scene
enum Origin {
	NONE,
	MAIN_MENU_HOW_TO_PLAY,
	MAIN_MENU_START_GAME,
	PAUSE_COMPONENT
}
## this variable determines the origin point of the scene
var scene_origin: Origin = Origin.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	content_invalid.connect(_on_content_invalid)
	content_failed_to_load.connect(_on_content_failed_to_load)
	content_finished_loading.connect(_on_content_finished_loading)

func load_new_scene(content_path: String, transition_type: String="fade_to_black") -> void:
	_transition = transition_type
	# add loading screen
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	loading_screen.start_transition(transition_type)
	_load_content(content_path)
	# each scene change, register audio triggers
	if AudioManager != null:
		AudioManager.register_audio_button_triggers()
func _load_content(content_path:String):
	# NOTE: Zelda transitions do not use loaders, so skip loading bar
	if loading_screen != null:
		await loading_screen.transition_in_complete
	
	_content_path = content_path
	# start loading!
	var loader = ResourceLoader.load_threaded_request(content_path)
	if not ResourceLoader.exists(content_path) or loader == null:
		content_invalid.emit(content_path)
		return
	# 
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(monitor_load_status)
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()
	
func monitor_load_status():
	var load_progress = [] # status will come as an array
	# ping the resource loader to check the status
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			content_invalid.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if loading_screen != null:
				loading_screen.update_bar(load_progress[0] * 100)
		ResourceLoader.THREAD_LOAD_FAILED:
			content_failed_to_load.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			if _transition == "zelda":
				# TODO: zelda_content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
				return
			else:
				content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
	
func _on_content_failed_to_load(path: String) -> void:
	printerr("Error: failed to load resource '%s'" % [path])

func _on_content_invalid(path: String) -> void:
	printerr("Error: cannot load resource '%s'" % [path])

func _on_content_finished_loading(content) -> void:
	var outgoing_scene = get_tree().current_scene
	# remove old scene
	outgoing_scene.queue_free()
	
	# add and set the new scene as the current scene
	get_tree().root.call_deferred("add_child", content)
	get_tree().set_deferred("current_scene", content)
	
	# probably not necessary, since we split our content_finished_loading but it won't hurt to have an extra check
	if loading_screen != null:
		loading_screen.finish_transition()
	# wait for loading screen transition to finish playing
	await loading_screen.animation_player.animation_finished
	loading_screen = null

# TODO: add Zelda on content finished loading!
