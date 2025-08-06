class_name JumpComponent
extends Node

@export_subgroup("Settings")
@export var jump_velocity: float = -1000

func handle_jump(body: CharacterBody2D) -> void:
	body.velocity.y = jump_velocity
