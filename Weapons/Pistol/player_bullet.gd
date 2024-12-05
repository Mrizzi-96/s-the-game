extends Area2D

@export var despawn_after_seconds : float
var speed = 750
var direction : Vector2

func _ready():
	# Sets the bullet direction depending on the father(weapon) node's rotation
	direction = Vector2(cos(rotation), sin(rotation))
	
func _physics_process(delta):
	position += direction * speed * delta
	# despawn after 5 secs 
	await get_tree().create_timer(despawn_after_seconds).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.get_parent()._hit(50)
	queue_free()
