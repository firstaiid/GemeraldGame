class_name MainMenu
extends Control

@export_subgroup("Nodes")
@export var play_button: Button
@export var achievements_button: Button
@export var settings_button: Button

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
