extends Area2D


var speed = 750

var direction = Vector2()

func _ready():
	# Imposta la direzione del proiettile in base alla rotazione del nodo padre (l'arma)
	direction = Vector2(cos(rotation), sin(rotation))
	
func _physics_process(delta):
	position += direction * speed * delta
	await get_tree().create_timer(5.0).timeout
	queue_free()
