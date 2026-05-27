extends Node2D

@export var player_bullet : PackedScene

var _smoothed_mouse_pos : Vector2 # use to have a smooth leg rotation movement
var max_speed = 2000
@onready var left_leg = $Hips/Ass/LeftLeg
@onready var right_leg = $Hips/Ass/RightLeg

@export var hit_amount: int

# Equipped Weapons references:
var left_leg_weapon
var right_leg_weapon

var max_rotation_speed = 10
var is_game_over: bool

@onready var _hips:=$Hips

@onready var player_gold = %PlayerGold

@onready var crossair =$"Crossair"
#@onready var sfx = %Sfx

@onready var _ass= %Cheeks

# dust particles
@onready var dust_particles : GPUParticles2D = %DustParticles

signal game_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.active_leg = left_leg
	if not RunInfo.ready:
		await ready
	# each time we instantiate the player, we use the RunInfo's player data to build it
	# this way, we always have a snapshot of the player at the time he leaves a shop scene (i.e. current gold, weapons, equipment etc.)
	_setup(RunInfo.player_data)

	is_game_over = false
	#RunInfo.arena_counter = 0
	_change_crossair(left_leg_weapon)

func _setup(player_data : PlayerData):
	# setup right weapon and left weapon to equipment
	left_leg_weapon = equipWeapon(player_data.equipment["LeftLeg"], "LeftLeg")
	right_leg_weapon = equipWeapon("propeller", "RightLeg")
	player_gold.text = str(RunInfo.player_data.gold)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#_smoothed_mouse_pos = lerp(_smoothed_mouse_pos, get_global_mouse_position(), 0.25)
	_smoothed_mouse_pos = get_global_mouse_position()
	_change_crossair_position(_smoothed_mouse_pos)
	# make selected leg look at mouse pos
	Global.active_leg.look_at(crossair.global_position)

func _input(event: InputEvent) -> void:
	# Optional but recommended: only react to mouse press (not release)
	#if event is InputEventMouseButton and not event.pressed:
		#return

	if event.is_action_pressed("act"):
		Global.active_leg = left_leg
		_change_crossair(left_leg_weapon)
		squish(left_leg_weapon)
		var aim_dir = $Hips.global_position.direction_to(crossair.global_position)
		$Hips/Camera2D.shake(1)

	elif event.is_action_pressed("switch"):
		Global.active_leg = right_leg
		_change_crossair(right_leg_weapon)
		squish(right_leg_weapon)
		var aim_dir = $Hips.global_position.direction_to(crossair.global_position)
		$Hips/Camera2D.shake(1)



func squish(weapon):
	if weapon is ShootingWeapon:
		_ass.squish()

func _change_crossair(weapon):
	crossair.texture=weapon.item_data.crossair_texture

func _change_crossair_position(new_pos):
	var min_length=125
	if(_hips.global_position.distance_to(new_pos) >= min_length):
		crossair.global_position=new_pos
	else:
		var direction=(new_pos - _hips.global_position).normalized()
		crossair.global_position=_hips.global_position+direction*min_length

func toggle_active_leg():
	# toggle selected leg
	Global.active_leg = left_leg if Global.active_leg == right_leg else right_leg

func equipWeapon(weapon: String, leg:String):
	var weaponScene = load(Global.weapons[weapon])
	if weaponScene:
		var weaponInstance = weaponScene.instantiate()
		var legNode = get_node("Hips/Ass/" + leg + "/Marker2D")
		for child in legNode.get_children():
			child.queue_free()
		legNode.add_child(weaponInstance)

		# get weaponInstance's ItemData and add it to the player inventory (if not already in)
		# WARNING: may not allow duplicate types!
		var weapon_item_data = weaponInstance.item_data
		RunInfo.player_data.add_to_inventory(weapon_item_data)
		# add leg and weapon to player_equipment
		RunInfo.player_data.add_to_equipment(leg, weaponInstance.item_data.name)
		weaponInstance.position = Vector2.ZERO
		# return weapon instance to have a reference
		return weaponInstance


func _on_hips_body_entered(_body):
	_ass.squish()
	if not dust_particles.emitting:
		dust_particles.restart()

func _physics_process(_delta):
	if $Hips.linear_velocity.length() > max_speed:
		$Hips.linear_velocity = $Hips.linear_velocity.normalized() * max_speed
