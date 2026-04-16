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

func _physics_process(delta):
	_alive_time += delta
	position += direction * speed * delta

func _on_body_entered(body):
	if _alive_time < spawn_grace:
		return
	
	if body.is_in_group("enemies"):
		body.get_parent()._hit(50)
		queue_free()
		return
	
	_spawn_wall_impact(body, _get_wall_normal(body))
	queue_free()

func _spawn_wall_impact(wall: Node, normal: Vector2):
	if wall_impact_particle == null:
		return
	
	var impact = wall_impact_particle.instantiate()
	impact.global_position = global_position
	impact.rotation = normal.angle()
	
	get_tree().current_scene.add_child(impact)

func _despawn_silent():
	if is_inside_tree():
		queue_free()

func _get_wall_normal(wall: Node2D) -> Vector2:
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
