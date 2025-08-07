extends Node

var intro_played: bool = false
var ingame: bool = false
var fullscreen: bool = true
var vsync: bool = true

func _ready():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
