class_name Player 
extends CharacterBody2D

@export_subgroup("Settings")
@export var health: float = 100.0
@export var gassy: bool

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: AdvancedJumpComponent
@export var sprite: AnimatedSprite2D

@export_subgroup("Sounds")
@export var music: AudioStreamPlayer2D
@export var vril_coin: AudioStreamPlayer2D
@export var gassy_sound: AudioStreamPlayer2D
@export var squish_sound: AudioStreamPlayer2D

func _ready() -> void:
	EventHandler.connect("vril_coin_collected",vril_coin_collected)
	EventHandler.connect("rage_enemy_squished",rage_enemy_squished)
	EventHandler.connect("gassy_powerup_collected",gassy_powerup_collected)
	EventHandler.connect("player_hurt",damage)
	GameController.player_health(health)

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta, gassy)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	animation_component.handle_move_animation(input_component.input_horizontal, gassy)
	jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released())
	animation_component.handle_jump_animation(jump_component.is_going_up, gravity_component.is_falling, gassy)
	
	if self.global_position.y > 3000.0 or health <= 0:
		get_tree().reload_current_scene()
	
	move_and_slide()
	health_handler()

func vril_coin_collected():
	vril_coin.play()
	GameController.print_to_console("vril coin collected")
	
func rage_enemy_squished():
	velocity.y = -1000
	squish_sound.play()
	GameController.print_to_console("enemy killed")

func gassy_powerup_collected():
	gassy_sound.play()
	gassy = true
	GameController.print_to_console("gassy power collected")

func damage(value: float):
	if !gassy:
		velocity.y = -500
	else:
		velocity.y = -600
		
	if sprite.flip_h:
		velocity.x = 1000
	else:
		velocity.x = -1000
		
	health -= value
	
	GameController.print_to_console("player take damage value " + str(value))

func health_handler():
	GameController.player_health(health)
