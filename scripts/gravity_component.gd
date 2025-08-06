class_name GravityComponent
extends Node

@export_subgroup("Settings")
@export var gravity: float = 1000.0

var is_falling: bool = false

func handle_gravity(body: CharacterBody2D, delta: float, gassy: bool) -> void:
	if not body.is_on_floor():
		if !gassy:
			body.velocity.y += gravity * delta
		else:
			body.velocity.y += (gravity * 0.6) * delta
		
	is_falling = body.velocity.y > 0 and not body.is_on_floor()
