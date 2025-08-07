extends ProjectileUpdater2D
class_name ProjectileUpdaterAdvanced2D


var projectile_velocity : Vector2 = Vector2.ZERO

var projectile_life_time_second_max : float = 10.0
var projectile_life_distance_max : float = 300.0

var destroy_on_body_collide : bool
var destroy_on_area_collide : bool

var projectile_speed_acceleration : float = 0.0
var projectile_speed_max : float = 0.0

var projectile_is_use_homing : bool = false
var projectile_homing_target_group : String
var projetile_max_homing_distance : float
var projectile_steer_speed : float
var projectile_homing_strength : float
var _homing_group_nodes : Array[Node]
var _homing_nearest_target : Node2D
var _homing_nearest_distance : float
var _homing_distance : float
var _homing_target_position : Vector2
var _homing_distance_to_target : float
var _homing_desired_direction : Vector2
var _homing_new_direction : Vector2
var _homing_final_direction : Vector2

var projectile_rotation_speed : float
var projectile_rotation_follow_direction : bool
var projectile_direction_follow_rotation : bool

var projectile_scale_acceleration : float
var projectile_scale_max : Vector2

var projectile_is_use_trigger : bool
var projectile_trigger_name : StringName
var projectile_trigger_amount : int
var projectile_trigger_life_time : float
var projectile_trigger_life_distance : float


func init_updater_variable() -> void:
	projectile_template_2d = projectile_template_2d as ProjectileTemplateAdvanced2D
	projectile_speed = projectile_template_2d.speed
	projectile_speed_acceleration = projectile_template_2d.speed_acceleration
	projectile_speed_max = projectile_template_2d.speed_max
	# projectile_direction = projectile_template_2d.direction
	projectile_life_time_second_max  = projectile_template_2d.life_time_second_max
	projectile_life_distance_max  = projectile_template_2d.life_distance_max
	projectile_direction_follow_rotation = projectile_template_2d.rotation_follow_direction

	destroy_on_body_collide = projectile_template_2d.destroy_on_body_collide
	destroy_on_area_collide = projectile_template_2d.destroy_on_area_collide

	_new_projectile_instance = Callable(ProjectileInstanceAdvanced2D, "new")
	pass

#region Spawn Projectile

func spawn_projectile_pattern(pattern_composer_pack: Array[PatternComposerData]) -> void:
	for pattern_data : PatternComposerData in pattern_composer_pack:

		_projectile_instance = projectile_instance_array[projectile_pooling_index]

		_projectile_instance.global_position = pattern_data.position
		_projectile_instance.speed = projectile_speed
		_projectile_instance.base_speed = projectile_speed
		_projectile_instance.base_direction = pattern_data.direction

		if projectile_template_2d.direction_follow_rotation:
			_projectile_instance.direction = _projectile_instance.base_direction.rotated(pattern_data.rotation)
		else:
			_projectile_instance.direction = pattern_data.direction

		if projectile_template_2d.rotation_follow_direction:
			_projectile_instance.rotation = pattern_data.direction.angle()
		else:
			_projectile_instance.rotation = pattern_data.rotation

		_projectile_instance.scale = projectile_template_2d.scale

		_projectile_instance.velocity = pattern_data.direction * projectile_speed * (1.0 / Engine.physics_ticks_per_second)

		_projectile_instance.transform = Transform2D(
			_projectile_instance.rotation,
			projectile_template_2d.scale,
			projectile_template_2d.skew,
			_projectile_instance.global_position
			)
		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(
				projectile_area_rid,
				projectile_pooling_index,
				_projectile_instance.transform
				)
			PS.area_set_shape_disabled(
				projectile_area_rid,
				projectile_pooling_index,
				false
				)

		_projectile_instance.life_time_second = 0.0
		_projectile_instance.life_distance = 0.0

		_projectile_instance.trigger_count = 0

		projectile_instance_array[projectile_pooling_index] = _projectile_instance

		if projectile_pooling_index not in projectile_active_index:
			projectile_active_index.append(projectile_pooling_index)

		projectile_pooling_index += 1

		if projectile_pooling_index >= projectile_max_pooling:
			projectile_pooling_index = 0

#endregion


#region Update Projectile

func update_projectile_instances(delta: float) -> void:
	projectile_speed = projectile_template_2d.speed
	projectile_speed_acceleration = projectile_template_2d.speed_acceleration
	projectile_speed_max = projectile_template_2d.speed_max
	projectile_is_use_homing = projectile_template_2d.is_use_homing

	if projectile_is_use_homing:
		projectile_homing_target_group = projectile_template_2d.target_group
		projetile_max_homing_distance = projectile_template_2d.max_homing_distance
		projectile_steer_speed = projectile_template_2d.steer_speed
		projectile_homing_strength = projectile_template_2d.homing_strength

	projectile_rotation_speed = projectile_template_2d.rotation_speed
	projectile_rotation_follow_direction = projectile_template_2d.rotation_follow_direction
	projectile_direction_follow_rotation = projectile_template_2d.direction_follow_rotation

	projectile_scale_acceleration = projectile_template_2d.scale_acceleration
	projectile_scale_max = Vector2.ONE * projectile_template_2d.scale_max


	projectile_life_time_second_max  = projectile_template_2d.life_time_second_max
	projectile_life_distance_max  = projectile_template_2d.life_distance_max

	projectile_is_use_trigger = projectile_template_2d.is_use_trigger
	projectile_trigger_name = projectile_template_2d.trigger_name
	projectile_trigger_amount = projectile_template_2d.trigger_amount
	projectile_trigger_life_time = projectile_template_2d.trigger_life_time
	projectile_trigger_life_distance = projectile_template_2d.trigger_life_distance


	# Check for projectile destroy condition
	for index : int in projectile_active_index:
		_projectile_instance = projectile_instance_array[index]

		# Life Time & Distance
		if projectile_life_time_second_max >= 0:
			_projectile_instance.life_time_second += delta
			if _projectile_instance.life_time_second >= projectile_life_time_second_max:
				projectile_remove_index.append(index)
				continue

		if projectile_life_distance_max >= 0:
			_projectile_instance.life_distance += _projectile_instance.velocity.length()
			if _projectile_instance.life_distance >= projectile_life_distance_max:
				projectile_remove_index.append(index)
				continue

		if destroy_on_area_collide:
			if has_overlapping_areas(index):
				for _overlap_area in get_overlapping_areas(index):
					if not _overlap_area.collision_layer & projectile_collision_mask:
						continue
					projectile_remove_index.append(index)

		if destroy_on_body_collide:
			if has_overlapping_bodies(index):
				for _overlap_body in get_overlapping_bodies(index):
					if not _overlap_body.collision_layer & projectile_collision_mask:
						continue
					projectile_remove_index.append(index)

	# Destroy projectile
	if projectile_remove_index.size() > 0:
		for index : int in projectile_remove_index:
			projectile_active_index.erase(index)
			PS.area_set_shape_disabled(projectile_area_rid, index, true)
		projectile_remove_index.clear()

	# Update active projectile instances array
	_active_instances.clear()
	for index : int in projectile_active_index:
		_active_instances.append(projectile_instance_array[index])
	if _active_instances.size() <= 0: return
	# Update active projectile
	for _active_instance : ProjectileInstanceAdvanced2D in _active_instances:

		if projectile_is_use_trigger:
			if _active_instance.trigger_count < projectile_trigger_amount:
				if projectile_trigger_life_time > 0:
					if _active_instance.life_time_second >= projectile_trigger_life_time * _active_instance.trigger_count:
						ProjectileEngine.projectile_instance_triggered.emit(projectile_trigger_name, _active_instance)
						_active_instance.trigger_count += 1
				if projectile_trigger_life_distance > 0:
					if _active_instance.life_distance >= projectile_trigger_life_distance * _active_instance.trigger_count:
						ProjectileEngine.projectile_instance_triggered.emit(projectile_trigger_name, _active_instance)
						_active_instance.trigger_count += 1

		if projectile_is_use_homing:
			_homing_group_nodes = get_tree().get_nodes_in_group(projectile_homing_target_group)
			if !_homing_group_nodes.is_empty():
				_homing_nearest_target = null
				_homing_nearest_distance = INF

				for node in _homing_group_nodes:
					if node is Node2D and is_instance_valid(node):
						_homing_distance = _active_instance.global_position.distance_to(node.global_position)
						if _homing_distance < _homing_nearest_distance:
							_homing_nearest_distance = _homing_distance
							_homing_nearest_target = node

					if _homing_nearest_target:
						_homing_target_position = _homing_nearest_target.global_position

					# Calculate distance to target
					_homing_distance_to_target = _active_instance.global_position.distance_to(_homing_target_position)

					# Check distance constraint
					if projetile_max_homing_distance <= 0.0 or _homing_distance_to_target <= projetile_max_homing_distance:
						# Calculate desired direction toward target
						_homing_desired_direction = _active_instance.global_position.direction_to(_homing_target_position)

						# Gradually steer toward target
						_homing_new_direction = _active_instance.direction.move_toward(_homing_desired_direction, projectile_steer_speed * delta)
						_homing_final_direction = _homing_new_direction.normalized() * projectile_homing_strength + _active_instance.direction * (1.0 - projectile_homing_strength)

						_active_instance.direction = _homing_final_direction.normalized()

			if projectile_speed_acceleration == 0:
				_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta

		if projectile_rotation_follow_direction:
			_active_instance.rotation = _active_instance.direction.angle()

		if projectile_rotation_speed != 0:
			_active_instance.rotation += deg_to_rad(projectile_rotation_speed) * delta
		if projectile_direction_follow_rotation:
			_active_instance.direction = Vector2.RIGHT.rotated(_active_instance.rotation)
			_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta

		if projectile_speed_acceleration != 0:
			if _active_instance.speed < projectile_speed_max:
				_active_instance.speed = move_toward(
					_active_instance.speed, projectile_speed_max, projectile_speed_acceleration * delta
					)

			_active_instance.velocity = _active_instance.speed * _active_instance.direction * delta


		if projectile_scale_acceleration != 0 and _active_instance.scale < projectile_scale_max:
			_active_instance.scale = _active_instance.scale.move_toward(projectile_scale_max, projectile_scale_acceleration * delta)

		_active_instance.global_position += _active_instance.velocity

		_active_instance.transform = Transform2D(
			_active_instance.rotation,
			_active_instance.scale,
			_active_instance.skew,
			_active_instance.global_position
			)

		if projectile_template_2d.collision_shape:
			PS.area_set_shape_transform(
				projectile_area_rid,
				_active_instance.area_index,
				_active_instance.transform
				)


#endregion
