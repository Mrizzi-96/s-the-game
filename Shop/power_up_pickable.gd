extends TextureRect

var item_data : ItemData
var margin:float=5.0
@export var start_position: Vector2
var grab = false
@onready var center=size/2
@onready var my_node = $".."
var slot:int=0
var needed_slot=2
var can_place:bool=false
var nearest_collider
var has_dragged=false

func _ready():
	var collider = create_collision_polygon(texture, margin)  # Margine di 5 pixel
	$collider.add_child(collider)
	print(my_node.bought)  # Assicurati che 'bought' esista
	start_position = position

func _process(delta: float) -> void:
	if grab:
		global_position = get_global_mouse_position()-Vector2(32,32)
	if slot==needed_slot:
		can_place=true
		%Clip.get_nearest_collider_center()
	else:
		can_place=false
	

func _input(event):
	if my_node.bought==true:
		if event is InputEventMouseButton:
			if event.pressed and get_node("%PowerUPCard").get_rect().has_point(get_local_mouse_position()):
				#slot=0
				grab = true
				has_dragged = true
				%PickUP.visible=true
				$collider.enable_colliders()
			if not event.pressed and grab:
				grab = false
				if has_dragged and can_place:  # Check viene eseguito solo se è stato trascinato almeno una volta
					global_position = nearest_collider.global_position-Vector2(32,32)
					print("Nearest collider global position:", nearest_collider.global_position)
					has_dragged = false  # Reset per la prossima interazione
					print("slot ",slot)
					$collider.disable_colliders()
				print("following",grab)


func create_collision_polygon(texture: Texture, margin: float):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_image())  
	var rect = Rect2(Vector2.ZERO, texture.get_size())
	var polygons = bitmap.opaque_to_polygons(rect, margin) 
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = polygons[0]  # Usa il primo poligono generato
	return collision_polygon


func _on_collider_area_entered(area: Area2D) -> void:
	if area.is_in_group("grid"):
		#print("slots+1")
		#if slot<needed_slot:
			slot+=1
			print(slot)


func _on_collider_area_exited(area: Area2D) -> void:
	if area.is_in_group("grid"):
		#print("slots-1")
		if slot>0:
			slot-=1


#func _on_clip_area_entered(area: Area2D) -> void:
	#if area.is_in_group("collide"):
		#nearest_collider=area.position
		#print("Nearest collider global position:", nearest_collider.global_position)
