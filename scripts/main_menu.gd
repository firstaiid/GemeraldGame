class_name MainMenu
extends Control

#shitty code please ignore :(

@export_subgroup("Nodes")
@export var play_button: Button
@export var achievements_button: Button
@export var settings_button: Button
@export var intro: Control
@export var intro_video: VideoStreamPlayer
@export var skip_button: Button
@export var quit_button: Button
@export var menu_buttons: Control
@export var settings_buttons: Control
@export var music: AudioStreamPlayer2D
@export var video_settings_buttons: Control
@export var full_screen_button: Button
@export var vsync_button: Button
@export var ui: CanvasLayer

func _ready():
	intro.visible = false
	menu_buttons.visible = true
	settings_buttons.visible = false
	video_settings_buttons.visible = false
	ui.visible = true

func _on_play_button_pressed() -> void:
	if !Global.intro_played:
		intro.visible = true
		intro_video.play()
		music.stop()
	else:
		Global.ingame = true
		GameController.start_game()
		get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_intro_video_finished() -> void:
	Global.intro_played = true
	Global.ingame = true
	GameController.start_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_skip_button_pressed() -> void:
	intro_video.stop()
	intro.visible = false
	Global.intro_played = true
	Global.ingame = true
	GameController.start_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	menu_buttons.visible = false
	settings_buttons.visible = true

func _on_back_button_pressed() -> void:
	menu_buttons.visible = true
	settings_buttons.visible = false

func _on_video_button_pressed() -> void:
	settings_buttons.visible = false
	video_settings_buttons.visible = true

func _on_video_back_button_pressed() -> void:
	settings_buttons.visible = true
	video_settings_buttons.visible = false

func _on_fullscreen_button_pressed() -> void:
	if Global.fullscreen:
		Global.fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_window().size = Vector2(1280,720)
	else:
		Global.fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
func _on_vsync_button_pressed() -> void:
	if Global.vsync:
		Global.vsync = false
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		Global.vsync = false
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
