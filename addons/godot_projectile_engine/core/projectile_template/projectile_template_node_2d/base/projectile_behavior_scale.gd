extends ProjectileBehavior
class_name ProjectileBehaviorScale

enum ScaleModifyMethod{
	## Add value to the current scale
	ADDITION,
	## Add value to the base scale
	ADDITION_OVER_BASE,
	## Multiply value to the current scale
	MULTIPLICATION,
	## Multiply value to the base scale
	MULTIPLICATION_OVER_BASE,
	## Override the current scale
	OVERRIDE,
}

enum ScaleProcessMode {
	PHYSICS,
	TICKS
}

var _scale_behavior_values : Dictionary = {}

func process_behavior(_value: Vector2, _context: Dictionary) -> Dictionary:
	return {}

