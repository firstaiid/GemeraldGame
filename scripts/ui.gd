class_name UI
extends Control

@export_subgroup("Nodes")
@export var y_coord: Label
@export var vril_coins: Label
@export var fps_label: Label
@export var health_bar: ProgressBar
@export var health_label: Label
@export var health_value: Label
@export var pause_menu: Control
@export var reset_button: Button
@export var quit_button: Button
@export var settings_button: Button
@export var console: Control
@export var console_text: RichTextLabel

var coins: int = 0

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		GameController.pause()
	elif event.is_action_pressed("developer_console"):
		GameController.developer_console()

func _ready() -> void:
	EventHandler.connect("player_pos",player_pos)
	EventHandler.connect("vril_coin_collected",vril_coin_collected)
	EventHandler.connect("player_health",player_health)
	EventHandler.connect("pause",pause)
	EventHandler.connect("developer_console",developer_console)
	EventHandler.connect("print_to_console",print_to_console)
	pause_menu.visible = false
	console.visible = false

func _process(_delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func player_pos(value: Vector2) -> void:
	y_coord.text = str(value)
	
func vril_coin_collected():
	coins += 1
	vril_coins.text = "Vril Coins: " + str(coins)

func player_health(value: float):
	health_bar.value = value
	health_value.text = str(int(value))

func pause():
	if !pause_menu.visible:
		pause_menu.visible = true
		get_tree().paused = true
	else:
		pause_menu.visible = false
		get_tree().paused = false
		
func developer_console():
	if !console.visible:
		console.visible = true
	else:
		console.visible = false

func print_to_console(value: String):
	if console_text.get_parsed_text() == "":
		console_text.add_text(value)
	else:
		console_text.add_text("\n" + value)

func _on_reset_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
