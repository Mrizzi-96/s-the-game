extends Label

func _ready():
	text=text.to_upper()
	adjust_font_size()

func adjust_font_size():
	#print(str($".".label_settings.font_size))
	var font_size = label_settings.font_size
	var max_width = 120  # Larghezza massima consentita
	while font_size > 8 and $".".size.x > max_width:
		font_size -= 1
		label_settings.font_size = font_size
