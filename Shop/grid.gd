extends Control

const CELL_SIZE = 64  # Dimensione delle celle della griglia
var grid_8 = Vector2(4, 2)  # Dimensione della griglia
#var grid_12 = Vector2(3, 4)  # Dimensione della griglia
var grid = []  # Array bidimensionale per la griglia
#var grid_leg1 = []  # Array bidimensionale per la griglia
#var grid_leg2 = []  # Array bidimensionale per la griglia
var selected_texture = null  # TextureRect selezionata per il drag

# Creazione della griglia vuota all'avvio
func _ready():
	grid = create_empty_grid(grid_8)
	#grid_leg1 = create_empty_grid(grid_12)
	#grid_leg2 = create_empty_grid(grid_12)

# Funzione per creare una griglia vuota
func create_empty_grid(size):
	var new_grid = []
	for y in range(size.y):
		new_grid.append([])
		for x in range(size.x):
			new_grid[y].append(null)  # Celle inizialmente vuote
	return new_grid

# Snap alla griglia per allineare TextureRect
func snap_to_grid(position):
	return Vector2(floor(position.x / CELL_SIZE) * CELL_SIZE, floor(position.y / CELL_SIZE) * CELL_SIZE)

# Controllo se una cella è vuota
func is_cell_empty(x, y):
	return grid[y][x] == null

# Posizionamento della TextureRect sulla griglia
func place_texture(texture_rect, x, y):
	if is_cell_empty(x, y):  # Controlla se la cella è libera
		grid[y][x] = texture_rect
		texture_rect.position = snap_to_grid(Vector2(x * CELL_SIZE, y * CELL_SIZE))
	else:
		print("La cella è già occupata!")

# Drag & Drop per muovere la TextureRect
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:  # Se il tasto del mouse è premuto
			selected_texture = get_texture_under_mouse()
		elif selected_texture:  # Se l'utente rilascia il mouse
			var mouse_pos = get_global_mouse_position()
			var grid_pos = Vector2(mouse_pos.x / CELL_SIZE, mouse_pos.y / CELL_SIZE)
			place_texture(selected_texture, int(grid_pos.x), int(grid_pos.y))
			selected_texture = null  # Reset dopo il rilascio

# Trova una TextureRect sotto il mouse
func get_texture_under_mouse():
	for texture in get_tree().get_nodes_in_group("textures"):
		if texture.get_global_rect().has_point(get_global_mouse_position()):
			return texture
	return null
