extends Node2D

@export var player_bullet : PackedScene

var _smoothed_mouse_pos : Vector2 # use to have a smooth leg rotation movement
var max_speed = 2000
@onready var left_leg = $Hips/Ass/LeftLeg
@onready var right_leg = $Hips/Ass/RightLeg
@export var health_bar : ProgressBar
@export var hit_amount: int

# Equipped Weapons references:
var left_leg_weapon
var right_leg_weapon 

var max_rotation_speed = 10
var is_game_over: bool

signal game_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.active_leg = left_leg
	# setup to max value
	health_bar.value = health_bar.max_value
	is_game_over = false
	right_leg_weapon = equipWeapon("shooting_weapon_base", "RightLeg")
	left_leg_weapon = equipWeapon("slashing_weapon_base", "LeftLeg")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos, get_global_mouse_position(), 0.25)
	# make selected leg look at mouse pos
	Global.active_leg.look_at(_smoothed_mouse_pos)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("act"):
		if Global.active_leg != left_leg:
			# left click ==> left leg
			toggle_active_leg()
	if Input.is_action_just_pressed("switch"):
		if Global.active_leg != right_leg:
			toggle_active_leg()
	elif Input.is_key_pressed(KEY_H):
		if !is_game_over:
			player_hit(hit_amount) # amount will vary based on enemy
	return 
	
func toggle_active_leg():
	# toggle selected leg
	Global.active_leg = left_leg if Global.active_leg == right_leg else right_leg

func player_hit(amount):
	health_bar.value -= amount
	if health_bar.value <= 0:
		health_bar.value = 0
		is_game_over = true
		emit_signal("game_ended")
		
func equipWeapon(weapon: String, leg:String):
	var weaponScene = load(Global.weapons[weapon])
	if weaponScene:
		var weaponInstance = weaponScene.instantiate()
		var legNode = get_node("Hips/Ass/" + leg + "/Marker2D")
		for child in legNode.get_children():
			child.queue_free()
		legNode.add_child(weaponInstance)
		weaponInstance.position = Vector2.ZERO
		# return weapon instance to have a reference
		return weaponInstance
