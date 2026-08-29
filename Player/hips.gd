extends RigidBody2D

@export var wall_bounce_strength : float = 1.1
@export var min_bounce_speed : float = 50.0

# Aspettare un contatto reale (get_contact_count) non basta: se il corpo si muove abbastanza
# veloce da penetrare parzialmente nel muro prima che la collisione venga rilevata, la
# correzione di compenetrazione del motore consuma già parte della quantità di moto, e quel
# poco che arriva a _integrate_forces non basta per un rimbalzo pulito (continuous_cd non
# risolve sempre il caso). Invece prevediamo la collisione UN passo prima con
# body_test_motion (lo stesso sweep test "shape-aware" usato da move_and_slide), così il
# rimbalzo scatta prima che avvenga qualunque compenetrazione.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity = state.linear_velocity
	if velocity.length() < min_bounce_speed:
		return

	var params = PhysicsTestMotionParameters2D.new()
	params.from = state.transform
	params.motion = velocity * state.get_step()
	params.margin = 2.0

	var result = PhysicsTestMotionResult2D.new()
	if PhysicsServer2D.body_test_motion(get_rid(), params, result):
		if result.get_collider() is TileMap:
			var normal = result.get_collision_normal()
			if velocity.dot(normal) < 0.0:
				state.linear_velocity = velocity.bounce(normal) * wall_bounce_strength
