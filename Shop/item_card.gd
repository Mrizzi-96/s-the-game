class_name ItemShopCard extends TextureRect

var image_path : String
var item_data : ItemData

@onready var image_texture : TextureRect = $"."
var margin:float=5.0
@export var start_position: Vector2
var grab :bool= true
@onready var center=size/2
#@onready var my_node = $".."
var slot:int=0
var needed_slot=1
var can_place:bool=false
var nearest_collider
var has_dragged:bool=true
var can_grab:bool=false
var creator

@onready var image_gun : TextureRect = %ImageTexture
#@onready var item_price = %ItemPrice
#@onready var buy_button : Button = %BuyButton
#@onready var title : Label = %Title
signal item_bought(item_data: ItemData)

func init(item: ItemData):
	if not is_node_ready():
		await ready
	self.item_data = item
	# set image
	image_gun.texture = item.texture
	#needed_slot=item.slots
	var collider = create_collision_polygon(texture, margin)  # Margine di 5 pixel
	$collider.add_child(collider)
	# ignore size of image to have them all same size
	#image_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE	
	#image_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# set price
	#item_price.set_text(str(item_data.price))
	# disable buy button if player has not enough money
	#buy_button.disabled = item_data.price > RunInfo.player_data.gold

#func buy():
	#var player_gold = RunInfo.player_data.gold
	#if item_data.price > player_gold:
		#print("NOT ABLE TO BUY")
	#else:
		## remove item price from player gold
		#RunInfo.player_data.gold = player_gold - item_data.price
		#if	RunInfo.player_data.gold < 0:
			#RunInfo.player_data.gold = 0
			#
		## add to RunInfo player_inventory
		#RunInfo.player_data.add_to_inventory(item_data)
		## tell shop manager to instantiate a new inventory card
		#item_bought.emit(item_data)
		## remove card from shop
		#queue_free()

func _ready():
	#print(my_node.bought)  # Assicurati che 'bought' esista
	start_position = position


func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("rotate_powerUP"):  # Correct usage
		#$".".rotation_degrees+=90
	if grab:
		global_position = get_global_mouse_position()-center
	if slot==needed_slot:
		can_place=true
		#%Clip.get_nearest_collider_center()
	else:
		can_place=false
	

func _input(event):
	#print(needed_slot)
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
				global_position = nearest_collider.global_position-center#Vector2(129.5,85.5)
				#print("Nearest collider global position:", nearest_collider.global_position)
				has_dragged = false  # Reset per la prossima interazione
				#print("slot ",slot)
				$collider.disable_colliders(creator)
				print("collegato a ", creator)
			else:
				creator.reset()
				queue_free()
			#print("following ",grab)


func create_collision_polygon(texture: Texture, margin: float):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_image())  
	var rect = Rect2(Vector2.ZERO, texture.get_size())
	var polygons = bitmap.opaque_to_polygons(rect, margin) 
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon = polygons[0]  # Usa il primo poligono generato
	return collision_polygon


func _on_collider_area_entered(area: Area2D) -> void:
	if area.is_in_group("LeftLeg") or area.is_in_group("RightLeg"):
		#print("slots+1")
		#if slot<needed_slot:
			slot+=1
			print(slot)


func _on_collider_area_exited(area: Area2D) -> void:
	if area.is_in_group("LeftLeg") or area.is_in_group("RightLeg"):
		#print("slots-1")
		if slot>0:
			slot-=1


func _on_mouse_entered() -> void:
	can_grab=true


func _on_mouse_exited() -> void:
	can_grab=false


func _on_clip_area_entered(area: Area2D) -> void:
	%Clip.get_nearest_collider_weapon()
