extends Node

var intro_played: bool = false

func _ready():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
