class_name PickUP
extends TextureRect

var item_data : ItemData

@onready var image_texture : TextureRect = $"."
var margin:float=5.0
@export var start_position: Vector2
var grab :bool= true
var center
#@onready var my_node = $".."
var slot:int=0
var needed_slot=0
var can_place:bool=false
var nearest_collider
var has_dragged:bool=true
var can_grab:bool=false
var creator

func init(item: ItemData):
	if not is_node_ready():
		await ready
	self.item_data = item
	# set image
	image_texture.texture = item.pickable_texture
	needed_slot=item.slots
	var collider = create_collision_polygon(texture, margin)  # Margine di 5 pixel
	$collider.add_child(collider)

func _ready():
	#print(my_node.bought)  # Assicurati che 'bought' esista
	start_position = position

func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("rotate_powerUP"):  # Correct usage
		#$".".rotation_degrees+=90
	if grab:
		global_position = get_global_mouse_position()-Vector2(32,32)
	if slot==needed_slot:
		can_place=true
		#%Clip.get_nearest_collider_center()
	else:
		can_place=false
	

func _input(event):
	print(needed_slot)
	#if my_node.bought==true:
	if event is InputEventMouseButton:
		if event.pressed and can_grab:#get_node(".").get_rect().has_point(get_local_mouse_position()):
			#slot=0
			grab = true
			has_dragged = true
			#%PickUP.visible=true
			$collider.enable_colliders()
		if not event.pressed and grab:
			grab = false
			if has_dragged and can_place:  # Check viene eseguito solo se è stato trascinato almeno una volta
				global_position = nearest_collider.global_position-Vector2(32,32)
				#print("Nearest collider global position:", nearest_collider.global_position)
				has_dragged = false  # Reset per la prossima interazione
				#print("slot ",slot)
				$collider.disable_colliders()
				creator.equip()
			else:
				creator.reset()
				queue_free()
			#print("following ",grab)


func create_collision_polygon(_texture: Texture, _margin: float):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(_texture.get_image())  
	var rect = Rect2(Vector2.ZERO, _texture.get_size())
	var polygons = bitmap.opaque_to_polygons(rect, _margin) 
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


func _on_mouse_entered() -> void:
	can_grab=true


func _on_mouse_exited() -> void:
	can_grab=false


func _on_clip_area_entered(_area: Area2D) -> void:
	%Clip.get_nearest_collider_powerUP()
