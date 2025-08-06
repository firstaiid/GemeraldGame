class_name GassyPowerup
extends Node2D

@export_subgroup("Nodes")
@export var sprite: Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		GameController.gassy_powerup_collected()
		self.queue_free()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	sprite.visible = true

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	sprite.visible = false
