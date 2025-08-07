extends Node



signal projectile_instance_triggered(trigger_name: String, projectile_instance: ProjectileInstance2D)
signal projectile_node_triggered(trigger_name: String, projectile_node: Projectile2D)
signal projectile_instance_pierced(projectile_node: ProjectileInstance2D, pierced_node: Node2D)

signal projectile_instance_body_shape_entered(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_body_shape_exited(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_body_entered(
	projectile_instance, body: Node,
	)

signal projectile_instance_body_exited(
	projectile_instance, body: Node,
	)

signal projectile_instance_area_shape_entered(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_area_shape_exited(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int
	)

signal projectile_instance_area_entered(
	projectile_instance, area: Node,
	)

signal projectile_instance_area_exited(
	projectile_instance, area: Node,
	)


enum BehaviorContext{
	PHYSICS_DELTA,
	GLOBAL_POSITION,
	PROJECTILE_OWNER,
	BEHAVIOR_OWNER,
	LIFE_TIME_TICK,
	LIFE_TIME_SECOND,
	LIFE_DISTANCE,
	BASE_SPEED,
	DIRECTION_COMPONENT,
	DIRECTION,
	BASE_DIRECTION,
	BASE_SCALE,
	ROTATION,
	RANDOM_NUMBER_GENERATOR,
	ARRAY_VARIABLE,
}

var active_projectile_count : int:
	get():
		return get_active_projectile_count()

var active_projectile_instance_count : int:
	get():
		return get_active_projectile_instance_count()
var active_projectile_node_count : int :
	get():
		return get_active_projectile_node_count()

var projectile_environment : ProjectileEnvironment2D
var projectile_boundary_2d : ProjectileBoundary2D

var projectile_composer_nodes : Dictionary[String, PatternComposer2D]

var projectile_updater_2d_nodes : Dictionary[RID, ProjectileUpdater2D]
var projectile_node_manager_2d_nodes : Dictionary[StringName, ProjectileNodeManager2D]

var _projectile_count_temp : int

func _ready() -> void:
	# projectile_instance_triggered.connect(_test_projectile_instance_triggered)
	# projectile_node_triggered.connect(_test_projectile_node_triggered)

	# projectile_instance_body_shape_entered.connect(_test_projectile_instance_body_shape_entered)
	# projectile_instance_body_shape_exited.connect(_test_projectile_instance_body_shape_exited)
	# projectile_instance_body_entered.connect(_test_projectile_instance_body_entered)
	# projectile_instance_body_exited.connect(_test_projectile_instance_body_exited)

	# projectile_instance_area_shape_entered.connect(_test_projectile_instance_area_shape_entered)
	# projectile_instance_area_shape_exited.connect(_test_projectile_instance_area_shape_exited)
	# projectile_instance_area_entered.connect(_test_projectile_instance_area_entered)
	# projectile_instance_area_exited.connect(_test_projectile_instance_area_exited)
	pass


func get_projectile_instance(area_rid: RID, area_shape_index: int) -> ProjectileInstance2D:
	if !projectile_updater_2d_nodes.has(area_rid):
		return null
	var _projectile_updater_2d_node : ProjectileUpdater2D = projectile_updater_2d_nodes.get(area_rid)
	if !_projectile_updater_2d_node:
		return null
	if _projectile_updater_2d_node.projectile_instance_array.size() < area_shape_index:
		return null
	return _projectile_updater_2d_node.projectile_instance_array[area_shape_index]
	pass


## Count all active Projectiles
func get_active_projectile_count() -> int:
	return get_active_projectile_instance_count() + get_active_projectile_node_count()


## Count the active ProjectileInstances
func get_active_projectile_instance_count() -> int:
	_projectile_count_temp = 0
	for projectile_updater in projectile_updater_2d_nodes.values():
		if !projectile_updater: continue
		_projectile_count_temp += projectile_updater.get_active_projectile_count()
		# print(projectile_updater.get_active_projectile_count())
	return _projectile_count_temp


## Count the active ProjectileNode2D
func get_active_projectile_node_count() -> int:
	_projectile_count_temp = 0
	for _projectile_node_manager in projectile_node_manager_2d_nodes.values():
		if !_projectile_node_manager: continue
		_projectile_count_temp += _projectile_node_manager.get_active_projectile_count()
	return _projectile_count_temp
	pass


## Cleanup Projectile Engine to default stage.
## Good for switching scene.
func refresh_projectile_engine() -> void:
	clear_all_projectiles()
	active_projectile_count = 0
	projectile_environment = null
	projectile_boundary_2d = null
	projectile_updater_2d_nodes.clear()
	projectile_node_manager_2d_nodes.clear()
	projectile_composer_nodes.clear()
	pass


## Clear all projectiles
func clear_all_projectiles() -> void:
	clear_projectile_instances()
	clear_projectile_nodes()
	pass


## Clear all ProjectileInstances
func clear_projectile_instances() -> void:
	for _projectile_udpater_node : ProjectileUpdater2D in projectile_updater_2d_nodes.values():
		_projectile_udpater_node.clear_projectiles()
	pass


## Clear all ProjectileNode2Ds
func clear_projectile_nodes() -> void:
	for _projectile_node_manager : ProjectileNodeManager2D in projectile_node_manager_2d_nodes.values():
		_projectile_node_manager.clear_projectiles()
	pass


func _test_projectile_instance_triggered(trigger_name: String, projectile_instance) -> void:
	print("Projectile instance triggered: ", trigger_name , " - ", projectile_instance)
	pass


func _test_projectile_node_triggered(trigger_name: String, projectile_node: Projectile2D) -> void:
	print("Projectile node2d triggered: ", trigger_name , " - ", projectile_node)
	pass


func _test_projectile_instance_body_shape_entered(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		body_rid, body, body_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass


func _test_projectile_instance_body_shape_exited(
	projectile_instance, 
	body_rid : RID, body: Node, body_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		body_rid, body, body_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass


func _test_projectile_instance_body_entered(
	projectile_instance, body) -> void:
	
	print("{0} - {1}".format([projectile_instance, body]))
	pass

func _test_projectile_instance_body_exited(
	projectile_instance, body) -> void:
	
	print("{0} - {1}".format([projectile_instance, body]))
	pass


func _test_projectile_instance_area_shape_entered(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		area_rid, area, area_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass


func _test_projectile_instance_area_shape_exited(
	projectile_instance, 
	area_rid : RID, area: Node, area_shape_idx: int, 
	projectile_rid: RID, projectile_idx:int) -> void:
	
	print("{0} - {1} - {2} - {3} - {4} - {5}".format([
		projectile_instance, 
		area_rid, area, area_shape_idx,
		projectile_rid, projectile_idx
		]))
	pass


func _test_projectile_instance_area_entered(
	projectile_instance, area) -> void:
	
	print("{0} - {1}".format([projectile_instance, area]))
	pass


func _test_projectile_instance_area_exited(
	projectile_instance, area) -> void:
	
	print("{0} - {1}".format([projectile_instance, area]))
	pass
