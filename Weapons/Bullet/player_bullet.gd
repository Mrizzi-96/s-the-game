extends Area2D

@export var despawn_after_seconds: float = 2.0
@export var speed: float = 750
@export var wall_impact_particle: PackedScene
@export var spawn_grace: float = 0.05

var direction: Vector2
var _alive_time: float = 0.0

func _ready():
	direction = Vector2(cos(rotation), sin(rotation))

	get_tree().create_timer(despawn_after_seconds).timeout.connect(_despawn_silent)
	_check_spawn_overlap()

func _check_spawn_overlap() -> void:
	# non ci si può fidare di body_entered per un overlap già in corso alla nascita:
	# controlliamo attivamente se il punto di spawn è già dentro un muro
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collision_mask = collision_mask
	query.collide_with_areas = false
	query.collide_with_bodies = true
	for result in space_state.intersect_point(query):
		if result.collider is TileMap:
			_spawn_wall_impact(result.collider, _get_wall_normal(result.collider))
			queue_free()
			return

func _physics_process(delta):
	_alive_time += delta
	var prev_pos = global_position
	var next_pos = prev_pos + direction * speed * delta

	if _alive_time >= spawn_grace and _sweep_hit_wall(prev_pos, next_pos):
		return

	position = next_pos

func _sweep_hit_wall(from: Vector2, to: Vector2) -> bool:
	# Area2D non ha collisione continua: a velocità/angoli diagonali il proiettile può
	# "saltare" oltre un muro sottile tra un tick fisico e l'altro senza mai sovrapporsi
	# per un frame intero. Un raycast lungo tutto il tragitto percorso in questo tick
	# copre il percorso invece di controllare solo il punto finale.
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = collision_mask
	query.collide_with_areas = false
	var result = space_state.intersect_ray(query)
	if result and not result.collider.is_in_group("enemies"):
		global_position = result.position
		_spawn_wall_impact(result.collider, result.normal)
		queue_free()
		return true
	return false

func _on_body_entered(body):
	# spawn_grace evita che il proiettile si autocolpisca appena nasce (stesso layer del player),
	# ma un muro deve comunque distruggerlo subito anche se ci nasce dentro
	if _alive_time < spawn_grace and not body is TileMap:
		return
	
	if body.is_in_group("enemies"):
		body.get_parent()._hit(50)
		queue_free()
		return
	
	_spawn_wall_impact(body, _get_wall_normal(body))
	queue_free()

func _spawn_wall_impact(_wall: Node, normal: Vector2):
	if wall_impact_particle == null:
		return
	
	var impact = wall_impact_particle.instantiate()
	impact.global_position = global_position
	impact.rotation = normal.angle()
	
	get_tree().current_scene.add_child(impact)

func _despawn_silent():
	if is_inside_tree():
		queue_free()

func _get_wall_normal(_wall: Node2D) -> Vector2:
	var space_state = get_world_2d().direct_space_state
	var dirs = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
	var normals = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	var closest_dist = INF
	var best_normal = -direction
	
	for i in 4:
		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + dirs[i] * 24.0
		)
		query.collision_mask = collision_mask
		
		var result = space_state.intersect_ray(query)
		if result:
			var dist = global_position.distance_to(result.position)
			if dist < closest_dist:
				closest_dist = dist
				best_normal = normals[i]
	
	return best_normal
