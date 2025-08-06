class_name AdvancedJumpComponent
extends Node

@export_subgroup("Settings")
@export var jump_velocity: float = -350.0

var is_going_up: bool = false

func handle_jump(body: CharacterBody2D, want_to_jump: bool, jump_released: bool) -> void:
	if want_to_jump and body.is_on_floor():
		jump(body)
		
	handle_variable_jump_height(body, jump_released)
	
	is_going_up = body.velocity.y < 0 and not body.is_on_floor()
	
func handle_variable_jump_height(body: CharacterBody2D, jump_released: bool) -> void:
	if jump_released and is_going_up:
		body.velocity.y = 0

func jump(body: CharacterBody2D) -> void:
	body.velocity.y = jump_velocity
