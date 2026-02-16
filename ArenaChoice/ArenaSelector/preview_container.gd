extends SubViewportContainer

func _ready() -> void:
	resized.connect(_on_resized)
	_on_resized()
	
func _on_resized():
	$Preview.size = size
