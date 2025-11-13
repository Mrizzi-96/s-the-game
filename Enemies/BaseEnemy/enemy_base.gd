extends Node2D

# This class is the base for enemies. If you want to create a new inherited enemy
# you must go in the Filesystem, right click, create new inherited scene and then remove
# the script and create a new one using extends class_name
class_name Enemy

var hit_particles = preload("res://Enemies/BaseEnemy/hit_particle.tscn")

var hp: int = 100
var movement_speed: float = 1.0

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

func _hit(damage: int) -> void:
	$HitFlashAnimationPlayer.play("hit_flash")
	DamageNumbers.display_damage(damage, $RigidBody2D/ParticlePosition.global_position)
	var splat = hit_particles.instantiate()
	splat.global_position = $RigidBody2D.global_position
	splat.emitting = true
	get_tree().current_scene.add_child(splat)
	hp -= damage
	if hp <= 0:
		_death()
	await get_tree().create_timer(splat.lifetime).timeout
	splat.queue_free()
	
	
func _death() -> void:
	if hp <= 0:
		MainUI.unregister_on_screen_enemy(self)
		queue_free()
		Global.enemyNum -= 1
