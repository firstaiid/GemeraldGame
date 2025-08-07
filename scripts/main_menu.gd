class_name MainMenu
extends Control

@export_subgroup("Nodes")
@export var play_button: Button
@export var achievements_button: Button
@export var settings_button: Button
@export var intro: Control
@export var intro_video: VideoStreamPlayer
@export var skip_button: Button
@export var quit_button: Button

func _ready():
	intro.visible = false

func _on_play_button_pressed() -> void:
	if !Global.intro_played:
		intro.visible = true
		intro_video.play()
	else:
		get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_intro_video_finished() -> void:
	Global.intro_played = true
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_skip_button_pressed() -> void:
	intro_video.stop()
	intro.visible = false
	Global.intro_played = true
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
