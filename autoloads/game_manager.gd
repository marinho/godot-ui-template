extends Node

@export var current_game_id : int = 0
@export var current_scene_path : String

var current_game = null


func set_current_game(new_game):
	current_game = new_game
	

func load_scene(scene_file_path):
	current_scene_path = scene_file_path
	get_tree().change_scene_to_file(scene_file_path)
	
