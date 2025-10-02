extends Node2D

@export var player_bullet : PackedScene

var _smoothed_mouse_pos : Vector2 # use to have a smooth leg rotation movement
var max_speed = 2000
@onready var left_leg = $Hips/Ass/LeftLeg
@onready var right_leg = $Hips/Ass/RightLeg
@onready var _invicibility_timer=$InvincibilityTimer
@onready var blinking=$BlinkTimer
@onready var _blinking=$Blinking

@export var health_bar : ProgressBar
@export var hit_amount: int

signal player_damaged

# Equipped Weapons references:
var left_leg_weapon
var right_leg_weapon 

var max_rotation_speed = 10
var is_game_over: bool
@onready var player_gold = %PlayerGold
#@onready var sfx = %Sfx

signal game_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.active_leg = left_leg
	if not RunInfo.ready:
		await ready
	# each time we instantiate the player, we use the RunInfo's player data to build it
	# this way, we always have a snapshot of the player at the time he leaves a shop scene (i.e. current gold, weapons, equipment etc.)
	_setup(RunInfo.player_data)
	_invicibility_timer.timeout.connect(on_invincibility_timer_timeout)
	
	is_game_over = false
	player_damaged.connect(on_player_damaged)

func on_player_damaged(cause):
	if !is_game_over and _invicibility_timer.is_stopped():
			player_hit(hit_amount)
			_invicibility_timer.start()
			_blinking.blink(true)
	
func on_invincibility_timer_timeout():
	_blinking.blink(false)

func _setup(player_data : PlayerData):
	# setup health 
	health_bar.value = player_data.health
	# setup right weapon and left weapon to equipment
	left_leg_weapon = equipWeapon(player_data.equipment["LeftLeg"], "LeftLeg")
	right_leg_weapon = equipWeapon(player_data.equipment["RightLeg"], "RightLeg")
	player_gold.text = str(RunInfo.player_data.gold)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos, get_global_mouse_position(), 0.25)
	# make selected leg look at mouse pos
	Global.active_leg.look_at(_smoothed_mouse_pos)
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("act"):
		if Global.active_leg != left_leg:
			# left click ==> left leg
			toggle_active_leg()
	if Input.is_action_just_pressed("switch"):
		if Global.active_leg != right_leg:
			toggle_active_leg()
	return 
	
func toggle_active_leg():
	# toggle selected leg
	Global.active_leg = left_leg if Global.active_leg == right_leg else right_leg

func player_hit(amount):
	health_bar.value -= amount
	# when player is hit, update player_data health value
	RunInfo.player_data.health = health_bar.value
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
		
		# get weaponInstance's ItemData and add it to the player inventory (if not already in)
		# WARNING: may not allow duplicate types!
		var weapon_item_data = weaponInstance.item_data
		RunInfo.player_data.add_to_inventory(weapon_item_data)
		# add leg and weapon to player_equipment
		RunInfo.player_data.add_to_equipment(leg, weaponInstance.item_data.name)
		weaponInstance.position = Vector2.ZERO
		# return weapon instance to have a reference
		return weaponInstance


func _on_hips_body_entered(body):
	if body.is_in_group("enemies") or body.is_in_group("damage"):
		player_damaged.emit(body)
		#if !is_game_over:
		#	player_hit(hit_amount)

func _physics_process(delta):
	if $Hips.linear_velocity.length() > max_speed:
		$Hips.linear_velocity = $Hips.linear_velocity.normalized() * max_speed
