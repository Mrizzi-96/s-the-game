extends Enemy

@onready var mosquito_sprite: AnimatedSprite2D = %mosquito_sprite

func _death():
	super._death()
	mosquito_sprite.stop()
	mosquito_sprite.play("death")
