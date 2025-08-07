extends ProjectileBehaviorDirection
class_name ProjectileDirectionHomingSimple

## Simple homing behavior that steers projectiles toward a target group

## Group name to target
@export var target_group: String = ""

## Speed at which the projectile steers toward target (radians per second)
@export var steer_speed: float = 5.0

## Strength of homing effect (0.0 to 1.0)
@export var homing_strength: float = 1.0

## Maximum distance at which homing is active (0 = unlimited)
@export var max_homing_distance: float = 0.0


## Returns required context values for this behavior
func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.PHYSICS_DELTA,
		ProjectileEngine.BehaviorContext.GLOBAL_POSITION,
	]


## Processes homing behavior by steering toward nearest target in group
func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	if not _context.has(ProjectileEngine.BehaviorContext.PHYSICS_DELTA):
		return {"direction_overwrite": _value}
	
	if target_group.is_empty():
		return {"direction_overwrite": _value}
	
	var delta: float = _context[ProjectileEngine.BehaviorContext.PHYSICS_DELTA]
	
	
	var projectile_position: Vector2 =_context[ProjectileEngine.BehaviorContext.GLOBAL_POSITION]
	
	# Find nearest target in group
	var target_position: Vector2 = _find_nearest_target(projectile_position)
	if target_position == Vector2.ZERO:
		return {"direction_overwrite": _value}
	
	# Calculate distance to target
	var distance_to_target: float = projectile_position.distance_to(target_position)
	
	# Check distance constraint
	if max_homing_distance > 0.0 and distance_to_target > max_homing_distance:
		return {"direction_overwrite": _value}
	
	# Calculate desired direction toward target
	var desired_direction: Vector2 = projectile_position.direction_to(target_position)
	
	# Gradually steer toward target
	var new_direction: Vector2 = _value.move_toward(desired_direction, steer_speed * delta)
	var final_direction: Vector2 = new_direction.normalized() * homing_strength + _value * (1.0 - homing_strength)
	
	return {"direction_overwrite": final_direction.normalized()}


## Finds the nearest target in the specified group
func _find_nearest_target(projectile_position: Vector2) -> Vector2:
	var group_nodes: Array[Node] = ProjectileEngine.get_tree().get_nodes_in_group(target_group)
	if group_nodes.is_empty():
		return Vector2.ZERO
	
	var nearest_target: Node2D = null
	var nearest_distance: float = INF
	
	for node in group_nodes:
		if node is Node2D and is_instance_valid(node):
			var distance: float = projectile_position.distance_to(node.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_target = node
	
	if nearest_target:
		return nearest_target.global_position
	
	return Vector2.ZERO
