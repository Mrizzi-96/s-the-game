extends Node2D

# This class is the base for enemies. If you want to create a new inherited enemy
# you must go in the Filesystem, right click, create new inherited scene and then remove
# the script and create a new one using extends class_name
class_name Enemy

var hit_particles = preload("res://Enemies/BaseEnemy/hit_particle.tscn")

var hp: int = 100
var movement_speed: float = 1.0

@export var points:int=100
@onready var hit_flash_animation_player: AnimationPlayer = %HitFlashAnimationPlayer
@onready var hit_impact_animation: AnimatedSprite2D = %HitImpactAnimation
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var sprite_2d: Sprite2D = %Sprite2D


func _ready():
	MainUI.register_on_screen_enemy(self)

func _getHealth() -> int:
	return hp
	
func _getSpeed() -> int:
	return movement_speed

func _setHealth(health: int) -> void:
	hp = health
	
func _setSpeed(speed: float) -> void:
	movement_speed = speed

func animate_hit_particle():
		hit_flash_animation_player.stop()
		hit_impact_animation.stop()
		hit_flash_animation_player.play("hit_flash")
		hit_impact_animation.play("hit_impact")

func _hit(damage: int) -> void:
	DamageNumbers.display_damage(damage, $RigidBody2D/ParticlePosition.global_position)
	hp -= damage
	if hp <= 0:
		_death.call_deferred()
	else:
		# activate hit sound and animation
		AudioManager.create_2d_audio_at_location(self.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_ENEMY_HIT)
		animate_hit_particle()
	
	
func _death() -> void:
	AudioManager.create_2d_audio_at_location(self.global_position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_ENEMY_DEATH)
	animate_hit_particle()
	sprite_2d.visible = false
	collision_shape_2d.disabled = true
	await hit_impact_animation.animation_finished
	MainUI.unregister_on_screen_enemy(self)
	queue_free()
	Global.enemyNum -= 1
	var score_manager=get_tree().get_first_node_in_group("score")
	score_manager.add_points(points)
