extends Control

class_name Inventory

# Definiamo la grandezza della griglia (esempio: 5x5)
const GRID_SIZE_X = 4
const GRID_SIZE_Y = 2

# Creiamo una matrice per gli slot
var slots = []

# Inizializziamo l'inventario con slot vuoti
func _init():
	slots.resize(GRID_SIZE_X)
	for x in range(GRID_SIZE_X):
		slots[x] = []
		slots[x].resize(GRID_SIZE_Y)
		for y in range(GRID_SIZE_Y):
			slots[x][y] = null  # Ogni cella è vuota all'inizio

# Funzione per aggiungere un oggetto all'inventario
func add_item(item, size_x, size_y):
	for x in range(GRID_SIZE_X - size_x + 1):
		for y in range(GRID_SIZE_Y - size_y + 1):
			if _can_fit_item(x, y, size_x, size_y):
				_place_item(item, x, y, size_x, size_y)
				return true  # Oggetto aggiunto con successo
	return false  # Nessuno spazio disponibile

# Verifica se l'oggetto può essere posizionato
func _can_fit_item(start_x, start_y, size_x, size_y):
	for x in range(size_x):
		for y in range(size_y):
			if slots[start_x + x][start_y + y] != null:
				return false  # Spazio già occupato
	return true

# Posiziona l'oggetto nel primo slot disponibile
func _place_item(item, start_x, start_y, size_x, size_y):
	for x in range(size_x):
		for y in range(size_y):
			slots[start_x + x][start_y + y] = item
