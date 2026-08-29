extends Node

# applica i volumi salvati all'AudioServer all'avvio del gioco, prima che qualunque scena
# (incluso il menu delle impostazioni) venga caricata: senza questo, i valori salvati
# vengono letti solo se il giocatore apre il menu impostazioni in quella sessione
const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "audio"
const AUDIO_BUSES := ["Master", "music", "sfx"]

func _ready() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	for bus_name in AUDIO_BUSES:
		var saved_value = config.get_value(SETTINGS_SECTION, bus_name, null)
		if saved_value != null:
			var bus_index = AudioServer.get_bus_index(bus_name)
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(saved_value))
