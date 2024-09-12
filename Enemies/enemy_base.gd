extends Node2D

# This class is the base for enemies. If you want to create a new inherited enemy
# you must go in the Filesystem, right click, create new inherited scene and then remove
# the script and create a new one using extends class_name
class_name Enemy

var hp: int = 100

func _getHealth() -> int:
	return hp

func _hit(damage: int) -> void:
	hp -= damage
	
func _death() -> void:
	if hp <= 0:
		queue_free()
