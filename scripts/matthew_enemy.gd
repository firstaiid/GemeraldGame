class_name MatthewEnemy
extends CharacterBody2D

@export_subgroup("Settings")
@export var speed: float = 1.0
@export var floaty: bool = false

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var right_detector: Area2D
@export var left_detector: Area2D
@export var hurt_box: Area2D
@export var animated_sprite: AnimatedSprite2D

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta, floaty)
	movement_component.handle_horizontal_movement(self, speed)
	
	if velocity.x > 0 or velocity.x < 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	
	move_and_slide()

func _on_left_body_exited(body: Node2D) -> void:
	if body is StaticBody2D:
		speed = 1

func _on_right_body_exited(body: Node2D) -> void:
	if body is StaticBody2D:
		speed = -1

func _on_hurt_box_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		GameController.rage_enemy_squished()
		self.queue_free()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	animated_sprite.visible = true

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	animated_sprite.visible = false

func _on_damage_box_body_entered(body: Node2D) -> void:
	if body is Player:
		print("hit")
		GameController.player_hurt(20.0)
